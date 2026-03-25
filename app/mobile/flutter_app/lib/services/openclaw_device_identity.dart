import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';

import '../persistence/device_identity_store.dart';
import 'openclaw_device_auth_payload.dart';

/// Base64URL without padding (matches OpenClaw UI `base64UrlEncode`).
String base64UrlNoPad(List<int> bytes) {
  return base64Url.encode(bytes).replaceAll('=', '');
}

List<int> base64UrlDecodeNoPad(String input) {
  String s = input.replaceAll('-', '+').replaceAll('_', '/');
  final int pad = (4 - s.length % 4) % 4;
  s += '=' * pad;
  return base64Url.decode(s);
}

/// SHA256(publicKey) as lowercase hex — same as `fingerprintPublicKey` in OpenClaw UI.
String fingerprintPublicKeyHex(Uint8List publicKeyBytes) {
  return sha256.convert(publicKeyBytes).toString();
}

/// Loads or creates a persistent Ed25519 identity compatible with OpenClaw gateway device auth.
Future<DeviceIdentityRecord> loadOrCreateDeviceIdentity() async {
  final DeviceIdentityRecord? existing = await DeviceIdentityStore.read();
  if (existing != null) {
    try {
      final List<int> pkBytes = base64UrlDecodeNoPad(existing.publicKeyBase64Url);
      final String derived = fingerprintPublicKeyHex(Uint8List.fromList(pkBytes));
      if (derived == existing.deviceId) {
        return existing;
      }
    } catch (_) {
      // regenerate
    }
  }

  final Ed25519 algorithm = Ed25519();
  final SimpleKeyPair keyPair = await algorithm.newKeyPair();
  final SimpleKeyPairData data = await keyPair.extract();
  final SimplePublicKey publicKey = data.publicKey;
  final List<int> pkBytes = publicKey.bytes;
  final List<int> seedBytes = data.bytes;
  final String deviceId = fingerprintPublicKeyHex(Uint8List.fromList(pkBytes));
  final DeviceIdentityRecord r = DeviceIdentityRecord(
    deviceId: deviceId,
    publicKeyBase64Url: base64UrlNoPad(pkBytes),
    privateKeySeedBase64Url: base64UrlNoPad(seedBytes),
  );
  await DeviceIdentityStore.write(r);
  return r;
}

Future<String> signDeviceAuthPayloadV3({
  required DeviceIdentityRecord identity,
  required String gatewayToken,
  required String nonce,
  required int signedAtMs,
}) async {
  final String payload = buildDeviceAuthPayloadV3(
    deviceId: identity.deviceId,
    clientId: 'pocketclaw',
    clientMode: 'operator',
    role: 'operator',
    scopes: <String>['operator.read', 'operator.write'],
    signedAtMs: signedAtMs,
    token: gatewayToken,
    nonce: nonce,
    platform: 'android',
    deviceFamily: 'phone',
  );
  final List<int> seed = base64UrlDecodeNoPad(identity.privateKeySeedBase64Url);
  final Ed25519 algorithm = Ed25519();
  final SimpleKeyPair keyPair = await algorithm.newKeyPairFromSeed(seed);
  final Signature sig = await algorithm.sign(
    utf8.encode(payload),
    keyPair: keyPair,
  );
  return base64UrlNoPad(sig.bytes);
}

String randomRequestId() {
  final Random r = Random.secure();
  return 'pc-${DateTime.now().microsecondsSinceEpoch}-${r.nextInt(1 << 30)}';
}
