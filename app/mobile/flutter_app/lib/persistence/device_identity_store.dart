import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persisted Ed25519 device identity (OpenClaw-compatible: SHA256(pub) = deviceId).
abstract final class DeviceIdentityStore {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const String _kJson = 'pc_openclaw_device_identity_v1';

  static Future<DeviceIdentityRecord?> read() async {
    final String? raw = await _storage.read(key: _kJson);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      final Map<String, dynamic> m = jsonDecode(raw) as Map<String, dynamic>;
      if (m['version'] != 1) {
        return null;
      }
      final String? deviceId = m['deviceId'] as String?;
      final String? publicKey = m['publicKey'] as String?;
      final String? privateKeySeed = m['privateKeySeed'] as String?;
      if (deviceId == null || publicKey == null || privateKeySeed == null) {
        return null;
      }
      return DeviceIdentityRecord(
        deviceId: deviceId,
        publicKeyBase64Url: publicKey,
        privateKeySeedBase64Url: privateKeySeed,
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> write(DeviceIdentityRecord r) async {
    await _storage.write(
      key: _kJson,
      value: jsonEncode(<String, Object?>{
        'version': 1,
        'deviceId': r.deviceId,
        'publicKey': r.publicKeyBase64Url,
        'privateKeySeed': r.privateKeySeedBase64Url,
      }),
    );
  }

  static Future<void> clear() => _storage.delete(key: _kJson);
}

class DeviceIdentityRecord {
  const DeviceIdentityRecord({
    required this.deviceId,
    required this.publicKeyBase64Url,
    required this.privateKeySeedBase64Url,
  });

  final String deviceId;
  final String publicKeyBase64Url;
  final String privateKeySeedBase64Url;
}
