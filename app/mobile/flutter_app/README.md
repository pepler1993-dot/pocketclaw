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

**API key (Settings → OpenAI):** optional `sk-…` stored in **secure storage**; Chat Completions **prefer this** over the OAuth access token so local dev can get real replies without a proxy.

**OpenClaw Gateway (Settings → OpenClaw Gateway):** optional **base URL + operator token**. When **Use gateway for chat** is on, chat (including **streaming**) goes to the gateway’s **`/v1/chat/completions`** and overrides direct OpenAI. **Test WebSocket** runs a real **`connect` → `hello-ok`** handshake (Ed25519 device identity + protocol 3). See **[docs/GATEWAY_HTTP.md](docs/GATEWAY_HTTP.md)**.

**Note:** OAuth-only tokens are often **not** accepted by `api.openai.com`. Production should prefer a **backend**; the in-app key path is for dev/personal use.

## Documentation

- **[docs/GATEWAY_HTTP.md](docs/GATEWAY_HTTP.md)** — HTTP gateway URL + token, probe, chat priority
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

### Windows Desktop (`flutter run -d windows`)

Builds **need symlink support**. Enable **Entwicklermodus** (Developer Mode), then restart the terminal:

```bat
start ms-settings:developers
```

Details: **[docs/WINDOWS_DESKTOP.md](docs/WINDOWS_DESKTOP.md)** · helper script: [`scripts/open-developer-settings.ps1`](scripts/open-developer-settings.ps1).

If the repo lives under **Nextcloud** and builds still fail, try a clone on a local **NTFS** path (sync can interfere with symlinks).

**Web without symlinks:** `flutter run -d chrome` (see `.vscode/launch.json` → „PocketClaw (Chrome)“).
