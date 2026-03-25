# Next steps

Single place for **what to do next**. Older split docs (`NEXT_STEPS_PRIORITY`, `NEXT_IMPLEMENTATION_STEP`) were merged here.

## Done recently (Flutter, 2026-03)

- **OpenClaw Gateway HTTP:** optional **Settings → OpenClaw Gateway** (base URL, operator token, `GET /v1/models` probe). When enabled, chat uses **`UnifiedChatService`** → gateway **`/v1/chat/completions`** (takes priority over direct OpenAI).
- **SSE streaming** for chat completions on both gateway and direct OpenAI paths when credentials allow.
- **WebSocket control plane:** **Test WebSocket (hello-ok)** performs a real **`connect` → `hello-ok`** handshake (protocol 3, Ed25519 device identity, `connect.challenge` handling). See [`app/mobile/flutter_app/docs/GATEWAY_HTTP.md`](../app/mobile/flutter_app/docs/GATEWAY_HTTP.md).
- **Runtime UI** remains mock-backed; deployment labels persist as before.

## Now (validation)

1. On a machine with Flutter on `PATH`: `cd app/mobile/flutter_app` → `flutter pub get` → `flutter analyze` → `flutter test` → `flutter run` / `flutter build apk` on a **real device or emulator**.
2. **Direct OpenAI:** optional **API key** under **Settings → OpenAI** (or OAuth where `api.openai.com` accepts the token).
3. **Via OpenClaw Gateway:** run a gateway (e.g. default port `18789`), set URL + token in **Settings → OpenClaw Gateway**, enable **Use gateway for chat**, then **Test connection** / **Test WebSocket** before relying on chat.

## Then (product + depth)

1. **Runtime:** second `RuntimeClient` implementation — real Android process/gateway IPC or remote health (see `docs/android/`). `MockRuntimeService` stays the default until then.
2. **Gateway:** optional WebSocket session after handshake (RPC, events, reconnect); persist `deviceToken` from `hello-ok` if you want retry flows like the Control UI.
3. **Chat:** OAuth token refresh if you keep browser OAuth; **never log secrets** (tokens, keys).

## Parallel (Android / OpenClaw)

1. Runtime feasibility: app ↔ local service/process boundary (see `docs/android/`).
2. Spike order and architecture choices remain documented under `docs/android/` and `docs/architecture/`.

## Principle

**Run first, refine second** — a working build on a real device beats more blind UI-only iteration.
