# OpenAI sign-in (OAuth PKCE)

PocketClaw uses **OAuth 2.0 authorization code + PKCE** (no client secret in the app) for the “Sign in with OpenAI” step, then a **ChatGPT-class model** is chosen in the next screen.

## Optional API key (recommended for real chat)

`https://api.openai.com` typically accepts **`Authorization: Bearer` with an API key** (`sk-…`), not arbitrary OAuth access tokens.

In **Settings → OpenAI**, you can store an **optional API key** in **flutter_secure_storage** (device-only). The chat client **prefers this key** over the OAuth access token when calling Chat Completions.

- Use keys from [platform.openai.com/api-keys](https://platform.openai.com/api-keys).
- Treat keys like passwords; prefer a **backend proxy** for production. This in-app path is for **development and personal testing**.

## Important (OAuth alone)

- OAuth for “ChatGPT login” is **product-specific**; tokens may not work on the public API unless your OAuth app is set up for it.
- Configure redirect URI **`pocketclaw://oauth-callback`** (or your custom `OPENAI_OAUTH_REDIRECT_URI`) in your OAuth app and in Android/iOS URL handlers.

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
