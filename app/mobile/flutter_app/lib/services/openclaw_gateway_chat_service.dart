import 'dart:convert';

import 'package:http/http.dart' as http;

import '../persistence/app_prefs.dart';
import '../persistence/gateway_token_store.dart';
import 'openai_chat_service.dart';
import 'openclaw_gateway_util.dart';

/// HTTP client for OpenClaw Gateway OpenAI-compatible API (default port 18789).
///
/// See: [Gateway Runbook](https://docs.openclaw.ai/gateway) — `/v1/chat/completions`, `/v1/models`.
class OpenClawGatewayChatService {
  static Future<bool> gatewayReady() async {
    final AppPrefsSnapshot snap = await AppPrefs.load();
    if (!snap.useGatewayForChat) {
      return false;
    }
    final String base = snap.gatewayBaseUrl.trim();
    if (base.isEmpty) {
      return false;
    }
    return GatewayTokenStore.hasToken();
  }

  static Future<GatewayProbeResult> probe({
    required String normalizedBaseUrl,
    required String bearerToken,
  }) async {
    final Uri url = openClawGatewayUri(normalizedBaseUrl, '/v1/models');
    try {
      final http.Response res = await http
          .get(
            url,
            headers: <String, String>{
              'Authorization': 'Bearer ${bearerToken.trim()}',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 12));
      if (res.statusCode < 200 || res.statusCode >= 300) {
        return GatewayProbeResult(
          ok: false,
          statusCode: res.statusCode,
          detail: res.body.length > 280 ? '${res.body.substring(0, 280)}…' : res.body,
        );
      }
      int modelCount = 0;
      try {
        final Map<String, dynamic> json = jsonDecode(res.body) as Map<String, dynamic>;
        final List<dynamic>? data = json['data'] as List<dynamic>?;
        modelCount = data?.length ?? 0;
      } catch (_) {
        modelCount = 0;
      }
      return GatewayProbeResult(ok: true, statusCode: res.statusCode, modelCount: modelCount);
    } catch (e) {
      return GatewayProbeResult(ok: false, statusCode: null, detail: e.toString());
    }
  }

  static Stream<String> streamCompletionAccumulated({
    required String model,
    required String userText,
  }) async* {
    final AppPrefsSnapshot snap = await AppPrefs.load();
    final String? token = await GatewayTokenStore.readToken();
    if (token == null || token.isEmpty) {
      return;
    }
    final String base = snap.gatewayBaseUrl.trim();
    if (base.isEmpty) {
      return;
    }

    final Uri url = openClawGatewayUri(base, '/v1/chat/completions');
    final http.Client client = http.Client();
    try {
      final http.Request request = http.Request('POST', url);
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = 'Bearer ${token.trim()}';
      request.body = jsonEncode(<String, Object?>{
        'model': model,
        'messages': <Map<String, String>>[
          <String, String>{'role': 'user', 'content': userText},
        ],
        'stream': true,
      });
      final http.StreamedResponse response = await client.send(request);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final String body = await response.stream.bytesToString();
        throw GatewayHttpException(response.statusCode, body);
      }

      String accumulated = '';
      await for (final String line
          in response.stream.transform(utf8.decoder).transform(const LineSplitter())) {
        final String? delta = openAiChatCompletionDeltaFromSseLine(line);
        if (delta != null && delta.isNotEmpty) {
          accumulated += delta;
          yield accumulated;
        }
      }
    } finally {
      client.close();
    }
  }

  static Future<String?> completeOrNull({
    required String model,
    required String userText,
  }) async {
    final AppPrefsSnapshot snap = await AppPrefs.load();
    final String? token = await GatewayTokenStore.readToken();
    if (token == null || token.isEmpty) {
      return null;
    }
    final String base = snap.gatewayBaseUrl.trim();
    if (base.isEmpty) {
      return null;
    }
    final Uri url = openClawGatewayUri(base, '/v1/chat/completions');
    final http.Response res = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.trim()}',
      },
      body: jsonEncode(<String, Object?>{
        'model': model,
        'messages': <Map<String, String>>[
          <String, String>{'role': 'user', 'content': userText},
        ],
      }),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw GatewayHttpException(res.statusCode, res.body);
    }

    final Map<String, dynamic> json = jsonDecode(res.body) as Map<String, dynamic>;
    final List<dynamic>? choices = json['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      return null;
    }
    final Map<String, dynamic> first = choices.first as Map<String, dynamic>;
    final Map<String, dynamic>? message = first['message'] as Map<String, dynamic>?;
    return message?['content'] as String?;
  }
}

class GatewayProbeResult {
  const GatewayProbeResult({
    required this.ok,
    this.statusCode,
    this.modelCount,
    this.detail,
  });

  final bool ok;
  final int? statusCode;
  final int? modelCount;
  final String? detail;
}

class GatewayHttpException implements Exception {
  GatewayHttpException(this.statusCode, this.body);
  final int statusCode;
  final String body;

  @override
  String toString() => 'Gateway HTTP $statusCode: $body';
}
