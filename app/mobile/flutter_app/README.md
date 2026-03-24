# PocketClaw Flutter app

Flutter UI shell for the Android-first PocketClaw mobile app (`app/mobile/flutter_app`).

## First-run flow

1. **Onboarding** → **Sign in with OpenAI** (OAuth 2.0 authorization code + PKCE, no client secret in the app).
2. **Choose a ChatGPT-class model** (e.g. GPT-4o, GPT-4o mini).
3. **Main shell** — chat, runtime (mock), diagnostics, settings.

Runtime **location** (where the gateway runs) defaults to *This phone* and is changed under **Settings**, not during first-run.

## OAuth configuration

See **[docs/OPENAI_OAUTH.md](docs/OPENAI_OAUTH.md)** — pass `--dart-define` values for `OPENAI_OAUTH_CLIENT_ID`, `OPENAI_OAUTH_AUTH_URL`, and `OPENAI_OAUTH_TOKEN_URL`.  
Redirect URI defaults to **`pocketclaw://oauth-callback`** (registered in Android/iOS).

**Debug:** “Simulate OAuth” on the sign-in screen skips the browser (mock token; chat uses mock replies unless a real API token works).

**Note:** Many OAuth tokens are **not** accepted by `https://api.openai.com` (which expects **API keys**). Real end-to-end chat often needs a **backend** or an IdP/token exchange your OpenAI project accepts. The app still performs the OAuth UI flow and calls the Chat Completions API when the stored token works.

## Documentation

- **[docs/RUNTIME_DEPLOYMENT.md](docs/RUNTIME_DEPLOYMENT.md)** — gateway deployment (mock-backed)
- **[docs/OPENAI_OAUTH.md](docs/OPENAI_OAUTH.md)** — OAuth build flags
- **[docs/IMPLEMENTATION_NOTES.md](docs/IMPLEMENTATION_NOTES.md)** — scaffold notes

Repo-wide docs: **[`../../../docs/README.md`](../../../docs/README.md)**.

## Local dev

```bash
cd app/mobile/flutter_app
flutter pub get
flutter analyze
flutter test
flutter run
```
