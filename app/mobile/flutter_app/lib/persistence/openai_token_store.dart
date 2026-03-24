import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores OpenAI-oriented OAuth tokens (not SharedPreferences).
abstract final class OpenAiTokenStore {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const String _kAccess = 'pc_openai_oauth_access';
  static const String _kRefresh = 'pc_openai_oauth_refresh';
  static const String _kExpiresAt = 'pc_openai_oauth_expires_at';
  static const String _kMock = 'pc_openai_oauth_mock';

  /// Optional `sk-…` key for `api.openai.com` (development / when OAuth token is not accepted).
  static const String _kApiKey = 'pc_openai_api_key';

  static Future<bool> hasAccessToken() async {
    final String? t = await _storage.read(key: _kAccess);
    return t != null && t.isNotEmpty;
  }

  static Future<bool> isMockSession() async {
    final String? m = await _storage.read(key: _kMock);
    return m == '1';
  }

  static Future<void> writeTokens({
    required String accessToken,
    String? refreshToken,
    DateTime? accessTokenExpiresAt,
    bool mockSession = false,
  }) async {
    await _storage.write(key: _kAccess, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _kRefresh, value: refreshToken);
    } else {
      await _storage.delete(key: _kRefresh);
    }
    if (accessTokenExpiresAt != null) {
      await _storage.write(
        key: _kExpiresAt,
        value: accessTokenExpiresAt.millisecondsSinceEpoch.toString(),
      );
    } else {
      await _storage.delete(key: _kExpiresAt);
    }
    await _storage.write(key: _kMock, value: mockSession ? '1' : '0');
  }

  static Future<String?> readAccessToken() => _storage.read(key: _kAccess);

  static Future<String?> readRefreshToken() => _storage.read(key: _kRefresh);

  static Future<String?> readApiKey() => _storage.read(key: _kApiKey);

  static Future<bool> hasApiKey() async {
    final String? k = await readApiKey();
    return k != null && k.isNotEmpty;
  }

  static Future<void> writeApiKey(String apiKey) async {
    final String t = apiKey.trim();
    if (t.isEmpty) {
      await _storage.delete(key: _kApiKey);
    } else {
      await _storage.write(key: _kApiKey, value: t);
    }
  }

  static Future<void> deleteApiKey() => _storage.delete(key: _kApiKey);

  static Future<void> clearAll() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
    await _storage.delete(key: _kExpiresAt);
    await _storage.delete(key: _kMock);
    await _storage.delete(key: _kApiKey);
  }
}
