# OpenAI sign-in (OAuth PKCE)

PocketClaw uses **OAuth 2.0 authorization code + PKCE** (no client secret in the app) for the “Sign in with OpenAI” step, then a **ChatGPT-class model** is chosen in the next screen.

## Important

- The public **OpenAI API** is usually authenticated with **API keys**. OAuth for end-user “ChatGPT account” access is **product-specific**; you must register an OAuth client that can return tokens accepted by `https://api.openai.com` (or your proxy). If you only have an **API key**, use a small backend — the mobile app should not embed API keys.
- Configure redirect URI **`pocketclaw://oauth-callback`** (or your custom value matching `OPENAI_OAUTH_REDIRECT_URI`) in your OAuth app and in Android/iOS URL handlers.

## Build-time defines

Pass when running or building:

| Define | Meaning |
|--------|---------|
| `OPENAI_OAUTH_CLIENT_ID` | OAuth client id |
| `OPENAI_OAUTH_AUTH_URL` | Authorization endpoint URL |
| `OPENAI_OAUTH_TOKEN_URL` | Token endpoint URL |
| `OPENAI_OAUTH_SCOPE` | Optional; space-separated scopes |
| `OPENAI_OAUTH_REDIRECT_URI` | Optional; default `pocketclaw://oauth-callback` |

Example:

```bash
flutter run --dart-define=OPENAI_OAUTH_CLIENT_ID=your_id \
  --dart-define=OPENAI_OAUTH_AUTH_URL=https://example.com/authorize \
  --dart-define=OPENAI_OAUTH_TOKEN_URL=https://example.com/token
```

If defines are **empty**, release builds should show the configuration hint; **debug** builds can use “Simulate OAuth” for UI testing only.
