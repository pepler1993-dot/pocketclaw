/// OpenAI OAuth (PKCE) — configure via `--dart-define` when you have a registered OAuth client.
///
/// OpenAI’s **HTTP API** normally uses **API keys**. OAuth-style “Sign in with ChatGPT” is used in
/// products like Codex; mobile redirect URIs must be registered for **your** OAuth client.
/// See `docs/OPENAI_OAUTH.md` in this app folder.
abstract final class OpenAiOAuthConfig {
  /// Public OAuth client id (no secret in the app — use PKCE).
  static const String clientId = String.fromEnvironment(
    'OPENAI_OAUTH_CLIENT_ID',
    defaultValue: '',
  );

  static const String authorizationEndpoint = String.fromEnvironment(
    'OPENAI_OAUTH_AUTH_URL',
    defaultValue: '',
  );

  static const String tokenEndpoint = String.fromEnvironment(
    'OPENAI_OAUTH_TOKEN_URL',
    defaultValue: '',
  );

  /// Space-separated scopes (OpenID-style), e.g. `openid profile offline_access` — depends on IdP.
  static const String scope = String.fromEnvironment(
    'OPENAI_OAUTH_SCOPE',
    defaultValue: 'openid profile offline_access',
  );

  /// Must match the redirect URL allowlisted for the OAuth client (custom scheme for the app).
  static const String redirectUri = String.fromEnvironment(
    'OPENAI_OAUTH_REDIRECT_URI',
    defaultValue: 'pocketclaw://oauth-callback',
  );

  static bool get isConfigured =>
      clientId.isNotEmpty &&
      authorizationEndpoint.isNotEmpty &&
      tokenEndpoint.isNotEmpty;
}
