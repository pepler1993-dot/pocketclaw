import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// OpenClaw Gateway operator token (same trust boundary as `gateway.auth.token`).
abstract final class GatewayTokenStore {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const String _kToken = 'pc_openclaw_gateway_token';

  static Future<String?> readToken() => _storage.read(key: _kToken);

  static Future<void> writeToken(String? token) async {
    final String t = token?.trim() ?? '';
    if (t.isEmpty) {
      await _storage.delete(key: _kToken);
    } else {
      await _storage.write(key: _kToken, value: t);
    }
  }

  static Future<bool> hasToken() async {
    final String? t = await readToken();
    return t != null && t.isNotEmpty;
  }
}
