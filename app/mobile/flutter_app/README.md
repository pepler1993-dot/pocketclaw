# PocketClaw Flutter app

Flutter UI shell for the Android-first PocketClaw mobile app (`app/mobile/flutter_app`).

## What’s in the tree

- **`lib/`** — onboarding, provider + runtime deployment setup, main shell (chat, runtime, diagnostics, settings)
- **Platform hosts** — `android/`, `ios/`, etc. (from `flutter create`)

## Documentation

- **[docs/RUNTIME_DEPLOYMENT.md](docs/RUNTIME_DEPLOYMENT.md)** — where the gateway is expected to run (mock-backed; persisted)
- **[docs/IMPLEMENTATION_NOTES.md](docs/IMPLEMENTATION_NOTES.md)** — scaffold / implementation notes

Repo-wide product and planning docs: **[`../../../docs/README.md`](../../../docs/README.md)** (from this folder: `docs/README.md` at repository root).

## Local dev

```bash
cd app/mobile/flutter_app
flutter analyze
flutter test
flutter run
```
