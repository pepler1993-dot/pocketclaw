# Next steps

Single place for **what to do next**. Older split docs (`NEXT_STEPS_PRIORITY`, `NEXT_IMPLEMENTATION_STEP`) were merged here.

## Now (validation)

1. On a machine with Flutter on `PATH`: `cd app/mobile/flutter_app` → `flutter pub get` → `flutter analyze` → `flutter test` → `flutter run` / `flutter build apk` on a **real device or emulator**.
2. For **real Chat Completions**: add an OpenAI **API key** under **Settings → OpenAI** (secure storage), or supply OAuth tokens that `api.openai.com` actually accepts (rare without a backend).

## Then (product + mock depth)

1. **Runtime abstraction:** `RuntimeClient` in `app/mobile/flutter_app/lib/services/runtime_client.dart` — `MockRuntimeService` is the first implementation; add a second (Android gateway / IPC) when ready.
2. **Chat:** streaming (SSE) responses, token refresh for OAuth if you keep it, and **no secrets in logs**.

## Parallel (Android / OpenClaw)

1. Runtime feasibility: app ↔ local service/process boundary (see `docs/android/`).
2. Spike order and architecture choices remain documented under `docs/android/` and `docs/architecture/`.

## Principle

**Run first, refine second** — a working build on a real device beats more blind UI-only iteration.
