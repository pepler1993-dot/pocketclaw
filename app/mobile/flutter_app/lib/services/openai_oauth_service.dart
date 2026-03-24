import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

import '../config/openai_oauth_config.dart';
import '../persistence/openai_token_store.dart';

/// OAuth 2.0 authorization code + PKCE for OpenAI-oriented login.
class OpenAiOAuthService {
  static String _base64UrlNoPad(List<int> bytes) {
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  static String generateCodeVerifier() {
    final Random random = Random.secure();
    final List<int> bytes = List<int>.generate(48, (_) => random.nextInt(256));
    return _base64UrlNoPad(bytes);
  }

  static String codeChallengeS256(String verifier) {
    final List<int> bytes = utf8.encode(verifier);
    final Digest digest = sha256.convert(bytes);
    return _base64UrlNoPad(digest.bytes);
  }

  static String generateState() {
    final Random random = Random.secure();
    final List<int> bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return _base64UrlNoPad(bytes);
  }

  /// Debug-only simulated login (no browser).
  static Future<void> signInSimulatedForDebug() async {
    assert(kDebugMode);
    await OpenAiTokenStore.writeTokens(
      accessToken: 'mock_oauth_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: null,
      accessTokenExpiresAt: DateTime.now().add(const Duration(hours: 1)),
      mockSession: true,
    );
  }

  /// Production path: browser OAuth, then token exchange.
  static Future<void> signInWithPkce() async {
    if (!OpenAiOAuthConfig.isConfigured) {
      throw StateError('OpenAI OAuth is not configured (dart-define).');
    }
    final String verifier = generateCodeVerifier();
    final String challenge = codeChallengeS256(verifier);
    final String state = generateState();

    final Uri authUri = Uri.parse(OpenAiOAuthConfig.authorizationEndpoint).replace(
      queryParameters: <String, String>{
        'response_type': 'code',
        'client_id': OpenAiOAuthConfig.clientId,
        'redirect_uri': OpenAiOAuthConfig.redirectUri,
        'scope': OpenAiOAuthConfig.scope,
        'state': state,
        'code_challenge': challenge,
        'code_challenge_method': 'S256',
      },
    );

    final String result = await FlutterWebAuth2.authenticate(
      url: authUri.toString(),
      callbackUrlScheme: Uri.parse(OpenAiOAuthConfig.redirectUri).scheme,
    );

    final Uri callback = Uri.parse(result);
    final String? code = callback.queryParameters['code'];
    final String? returnedState = callback.queryParameters['state'];
    final String? error = callback.queryParameters['error'];
    if (error != null) {
      throw StateError('OAuth error: $error ${callback.queryParameters['error_description'] ?? ''}');
    }
    if (code == null || code.isEmpty) {
      throw StateError('OAuth callback missing code.');
    }
    if (returnedState != state) {
      throw StateError('OAuth state mismatch.');
    }

    final http.Response tokenResponse = await http.post(
      Uri.parse(OpenAiOAuthConfig.tokenEndpoint),
      headers: const <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': OpenAiOAuthConfig.redirectUri,
        'client_id': OpenAiOAuthConfig.clientId,
        'code_verifier': verifier,
      },
    );

    if (tokenResponse.statusCode < 200 || tokenResponse.statusCode >= 300) {
      throw StateError('Token exchange failed: ${tokenResponse.statusCode} ${tokenResponse.body}');
    }

    final Map<String, dynamic> json =
        jsonDecode(tokenResponse.body) as Map<String, dynamic>;
    final String? access = json['access_token'] as String?;
    final String? refresh = json['refresh_token'] as String?;
    final int? expiresIn = json['expires_in'] as int?;
    if (access == null || access.isEmpty) {
      throw StateError('Token response missing access_token.');
    }

    final DateTime? exp = expiresIn != null
        ? DateTime.now().add(Duration(seconds: expiresIn))
        : null;

    await OpenAiTokenStore.writeTokens(
      accessToken: access,
      refreshToken: refresh,
      accessTokenExpiresAt: exp,
      mockSession: false,
    );
  }
}
