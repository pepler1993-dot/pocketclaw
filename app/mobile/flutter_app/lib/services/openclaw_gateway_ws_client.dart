import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../persistence/device_identity_store.dart';
import 'openclaw_device_identity.dart';
import 'openclaw_gateway_util.dart';

/// Result of a one-shot WebSocket `connect` handshake (OpenClaw [Gateway protocol](https://docs.openclaw.ai/gateway/protocol)).
class GatewayWsHandshakeResult {
  const GatewayWsHandshakeResult({
    required this.ok,
    this.protocol,
    this.serverVersion,
    this.connId,
    this.errorMessage,
    this.rawPayload,
  });

  final bool ok;
  final int? protocol;
  final String? serverVersion;
  final String? connId;
  final String? errorMessage;
  final Object? rawPayload;
}

/// Minimal WebSocket client: `connect.challenge` → signed `connect` → `hello-ok`.
///
/// Mirrors the Control UI flow (challenge nonce, 750 ms fallback, Ed25519 v3 payload).
abstract final class OpenClawGatewayWsClient {
  static Future<GatewayWsHandshakeResult> handshakeOnce({
    required String normalizedHttpBase,
    required String gatewayToken,
    Duration timeout = const Duration(seconds: 22),
  }) async {
    final Uri wsUri = httpBaseToWsUri(normalizedHttpBase);
    final WebSocketChannel channel = WebSocketChannel.connect(wsUri);

    final String reqId = randomRequestId();
    final Completer<GatewayWsHandshakeResult> completer = Completer<GatewayWsHandshakeResult>();

    Timer? fallbackTimer;
    bool connectSent = false;
    String? challengeNonce;

    Future<void> sendConnect() async {
      if (connectSent) {
        return;
      }
      connectSent = true;
      fallbackTimer?.cancel();

      final DeviceIdentityRecord identity = await loadOrCreateDeviceIdentity();
      final int signedAtMs = DateTime.now().millisecondsSinceEpoch;
      final String nonce = challengeNonce ?? '';
      final String signature = await signDeviceAuthPayloadV3(
        identity: identity,
        gatewayToken: gatewayToken.trim(),
        nonce: nonce,
        signedAtMs: signedAtMs,
      );

      final Map<String, Object?> params = <String, Object?>{
        'minProtocol': 3,
        'maxProtocol': 3,
        'client': <String, Object?>{
          'id': 'pocketclaw',
          'version': '0.1.0',
          'platform': 'android',
          'mode': 'operator',
        },
        'role': 'operator',
        'scopes': <String>['operator.read', 'operator.write'],
        'caps': <String>[],
        'auth': <String, String>{'token': gatewayToken.trim()},
        'locale': 'en-US',
        'userAgent': 'pocketclaw-flutter/0.1.0',
        'device': <String, Object?>{
          'id': identity.deviceId,
          'publicKey': identity.publicKeyBase64Url,
          'signature': signature,
          'signedAt': signedAtMs,
          'nonce': nonce,
        },
      };

      channel.sink.add(
        jsonEncode(<String, Object?>{
          'type': 'req',
          'id': reqId,
          'method': 'connect',
          'params': params,
        }),
      );
    }

    void finish(GatewayWsHandshakeResult r) {
      if (!completer.isCompleted) {
        completer.complete(r);
      }
      unawaited(channel.sink.close());
    }

    fallbackTimer = Timer(const Duration(milliseconds: 750), () {
      unawaited(sendConnect());
    });

    late final StreamSubscription<dynamic> sub;
    sub = channel.stream.listen(
      (dynamic data) {
        if (completer.isCompleted) {
          return;
        }
        final String raw = data is String ? data : utf8.decode(data as List<int>);
        Map<String, dynamic>? json;
        try {
          json = jsonDecode(raw) as Map<String, dynamic>?;
        } catch (_) {
          return;
        }
        if (json == null) {
          return;
        }

        final String? type = json['type'] as String?;
        if (type == 'event') {
          final String? event = json['event'] as String?;
          if (event == 'connect.challenge') {
            final Object? payload = json['payload'];
            if (payload is Map<String, dynamic>) {
              final Object? n = payload['nonce'];
              if (n is String && n.isNotEmpty) {
                challengeNonce = n;
                fallbackTimer?.cancel();
                unawaited(sendConnect());
              }
            }
          }
          return;
        }

        if (type == 'res') {
          final String? id = json['id'] as String?;
          if (id != reqId) {
            return;
          }
          final bool ok = json['ok'] as bool? ?? false;
          if (!ok) {
            final Object? err = json['error'];
            String msg = 'connect failed';
            if (err is Map<String, dynamic>) {
              msg = err['message'] as String? ?? jsonEncode(err);
            }
            finish(GatewayWsHandshakeResult(ok: false, errorMessage: msg));
            return;
          }
          final Object? payload = json['payload'];
          if (payload is Map<String, dynamic>) {
            final String? t = payload['type'] as String?;
            if (t == 'hello-ok') {
              final int? proto = (payload['protocol'] as num?)?.toInt();
              final Map<String, dynamic>? server =
                  payload['server'] as Map<String, dynamic>?;
              finish(
                GatewayWsHandshakeResult(
                  ok: true,
                  protocol: proto,
                  serverVersion: server?['version'] as String?,
                  connId: server?['connId'] as String?,
                  rawPayload: payload,
                ),
              );
              return;
            }
          }
          finish(GatewayWsHandshakeResult(ok: true, rawPayload: payload));
        }
      },
      onError: (Object e) {
        finish(GatewayWsHandshakeResult(ok: false, errorMessage: e.toString()));
      },
      onDone: () {
        if (!completer.isCompleted) {
          finish(
            const GatewayWsHandshakeResult(
              ok: false,
              errorMessage: 'WebSocket closed before connect response',
            ),
          );
        }
      },
      cancelOnError: false,
    );

    final Timer deadline = Timer(timeout, () {
      finish(
        const GatewayWsHandshakeResult(
          ok: false,
          errorMessage: 'Handshake timed out',
        ),
      );
    });
    try {
      return await completer.future;
    } finally {
      deadline.cancel();
      await sub.cancel();
      fallbackTimer?.cancel(); // ignore: invalid_null_aware_operator
    }
  }
}
