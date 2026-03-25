# PocketClaw Agent Handoff

**Location:** `docs/development/AGENT_HANDOFF.md` (snapshot updated 2026-03-25; update in place when context changes.)

## Purpose
This document is meant to let another agent take over the PocketClaw task quickly without losing context.

---

## Project summary
PocketClaw is a mobile-first product concept that aims to make OpenClaw usable on smartphones through a clean, user-friendly app interface.

Current strategic direction:
- Android first
- local-first where possible
- Flutter for app/product shell
- likely native Android service/runtime handling where needed
- dark black/red visual identity inspired by OpenClaw

---

## Repository
GitHub repo:
- `https://github.com/pepler1993-dot/pocketclaw.git`

Local path (examples):
- Linux/agent environment: `/root/.openclaw/workspace/pocketclaw`
- Windows (typical): `C:\Users\<user>\Nextcloud\pocketclaw\pocketclaw`

Branch currently used:
- `main`

Push access is already working via stored GitHub token.

---

## Major work completed so far

### Product / strategy documentation
- **[`docs/README.md`](../README.md)** — index of all docs (product, architecture, Android, planning, dependencies, meta, development)
- **Next steps:** [`docs/planning/NEXT_STEPS.md`](../planning/NEXT_STEPS.md)
- **This handoff / status:** [`AGENT_HANDOFF.md`](AGENT_HANDOFF.md), [`PROJECT_STATUS.md`](PROJECT_STATUS.md)

### GitHub issues created
Issues were created progressively and should already exist in the repo, including Android feasibility, stack decision, runtime architecture, service model, spike planning, and UI/screen-flow related items.

### Flutter app shell created
Path:
- `app/mobile/flutter_app`

App shell includes:
- onboarding flow
- provider setup screen (two sections: **where OpenClaw runs** vs **model/API provider**)
- main shell
- chat screen
- runtime screen
- diagnostics screen
- settings screen (including **runtime location** / deployment)
- theme
- product widgets
- simple app flow controller
- **Runtime deployment** persisted separately from provider (`SharedPreferences` key `pc_runtime_deployment`; default *This phone*)

Important files:
- `lib/main.dart`
- `lib/app.dart`
- `lib/theme/app_theme.dart`
- `lib/flow/app_flow_controller.dart` (incl. `selectedDeployment`, `setDeployment`, `hydrateFromPrefs` with `runtimeDeploymentLabel`)
- `lib/models/runtime_deployment_model.dart` — where the gateway runs (phone / LAN / cloud / custom)
- `lib/persistence/app_prefs.dart` — `runtimeDeploymentLabel`, `saveRuntimeDeploymentLabel`
- `lib/services/mock_runtime_service.dart` — takes `deployment`, drives mock logs/mode/chat; `setDeployment` persists label
- `app/mobile/flutter_app/docs/RUNTIME_DEPLOYMENT.md` — runtime deployment feature (repo root–relative path)
- `lib/widgets/product_widgets.dart`
- `lib/screens/onboarding_screen.dart`
- `lib/screens/provider_setup_screen.dart`
- `lib/screens/chat_screen.dart`
- `lib/screens/runtime_screen.dart`
- `lib/screens/diagnostics_screen.dart`
- `lib/screens/settings_screen.dart` (includes **`GatewaySettingsSection`** — OpenClaw Gateway URL, token, HTTP probe, WebSocket handshake test)

### Visual direction already applied
- dark-first theme
- black / charcoal surfaces
- red accent color
- OpenClaw-inspired visual direction

---

## Environment work already done

### Flutter / Android tooling installed on host
Installed:
- Flutter SDK at `/opt/flutter`
- Android SDK at `/opt/android-sdk`
- Java 17
- Android platform tools
- Android platform 35
- Android build tools 35.0.0
- Android licenses accepted

Environment notes:
- current execution happens as root, so Flutter warns about that
- not ideal for long-term dev workflow, but enough for setup/testing

### Important environment variables used
Typical command prefix used during work:

```bash
export ANDROID_SDK_ROOT=/opt/android-sdk
export ANDROID_HOME=/opt/android-sdk
export PATH=/opt/flutter/bin:$PATH:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools
```

---

## Flutter project state
The Flutter project was fully initialized with:

```bash
cd /root/.openclaw/workspace/pocketclaw/app/mobile/flutter_app
flutter create .
```

This generated the normal Flutter scaffolding:
- android/
- ios/
- macos/
- linux/
- windows/
- web/
- test/
- project metadata

The custom PocketClaw UI code remained intact.

---

## Build and analysis status

### Analysis status
`flutter analyze` was run.

Current known result:
- no blocking Dart errors remain after fixes
- remaining issues were reduced to a small number of lint/info warnings (mostly `const` suggestions)
- these are not major blockers

### Fixes already applied
- repaired broken default test file
- changed test import from `main.dart` to `app.dart`
- removed syntax error in `settings_screen.dart`
- replaced deprecated theme usages:
  - `withOpacity` → `withValues(alpha: ...)`
  - `MaterialStateProperty` → `WidgetStateProperty`
  - `MaterialState` → `WidgetState`

### APK build status
A debug APK build was started with:

```bash
flutter build apk --debug
```

At the moment of handoff, the build process had been running through Gradle.
The exact final artifact status should be rechecked by the next agent.

Recommended immediate verification:

```bash
cd /root/.openclaw/workspace/pocketclaw/app/mobile/flutter_app
flutter build apk --debug
ls -la build/app/outputs/flutter-apk
```

---

## Device / emulator status
Checked already:
- no Android device connected via `adb`
- no Android emulator available
- `flutter devices` only showed Linux desktop

Meaning:
- app cannot yet be run on Android until a device or emulator is available
- build verification is still useful even without device access

---

## Recent implementation (since original handoff draft)

**Runtime deployment** is implemented end-to-end in the Flutter shell (still mock-backed):

- Model: `RuntimeDeploymentKind` + `RuntimeDeploymentModel` with stable persisted labels.
- Setup: user picks deployment first, then provider; `completeSetup` saves both.
- Settings: dropdown changes deployment via `MockRuntimeService.setDeployment` (persists + diagnostics events).
- `app.dart` hydrates `runtimeDeploymentLabel` and passes `deployment` into `MockRuntimeService` on first main-shell build.

**Pushed to `origin/main`** (includes commit adding this wiring and `app/mobile/flutter_app/docs/RUNTIME_DEPLOYMENT.md`).

### OpenClaw Gateway — HTTP chat + WebSocket handshake (2026-03)

- **Chat:** `UnifiedChatService` routes to **`OpenClawGatewayChatService`** when gateway is enabled in prefs + token present; else **`OpenAiChatService`**. Both support **SSE streaming** for completions.
- **Prefs / secure storage:** `AppPrefs` keys `pc_use_openclaw_gateway`, `pc_gateway_base_url`; **`GatewayTokenStore`** (`pc_openclaw_gateway_token`); **`DeviceIdentityStore`** for Ed25519 device keys used in WS `connect`.
- **WebSocket:** `lib/services/openclaw_gateway_ws_client.dart` — `OpenClawGatewayWsClient.handshakeOnce` (challenge + 750 ms fallback, `hello-ok`).
- **Utilities:** `openclaw_gateway_util.dart` (URL normalize, `http`→`ws`), `openclaw_device_auth_payload.dart` (v3 signing string), `openclaw_device_identity.dart` (Ed25519 via `package:cryptography`).
- **Docs:** `app/mobile/flutter_app/docs/GATEWAY_HTTP.md`, updated **`docs/README.md`**, **`docs/planning/NEXT_STEPS.md`**, **`docs/development/MANUAL_TEST_PROCESS.md`**.

---

## Recommended next steps for the next agent

### First priority
Validate the Flutter project on a machine with Flutter in `PATH`.

1. `cd app/mobile/flutter_app`
2. `flutter analyze`
3. `flutter test`
4. Optional: `flutter build apk` (or platform of choice)

### Second priority
**Runtime:** add a second **`RuntimeClient`** implementation (or narrow bridge) for real gateway/Android IPC; keep **`MockRuntimeService`** until then.

**Gateway (optional follow-ups):** persistent WebSocket session after `hello-ok` (RPC, events, reconnect); store **`deviceToken`** from `hello-ok` for retry flows like the upstream Control UI.

### Third priority
Android background execution and real service wiring (per [`docs/android/`](../android/): `ANDROID_SERVICE_MODEL.md`, `ANDROID_IMPLEMENTATION_SEQUENCE.md`, etc.).

---

## Important caution points
- Do not overwrite the product docs casually; a lot of structure has already been built.
- Keep PocketClaw aligned with Android-first realism.
- Do not assume background daemon behavior will “just work” on Android.
- Keep UI direction dark / black-red / OpenClaw-adjacent unless explicitly changed.
- Use Cursor CLI only when explicitly requested by the user; that preference was stated.

---

## Short handoff summary
PocketClaw is no longer just planning.
It now has:
- substantial product/architecture documentation
- an initialized Flutter project
- a first branded UI shell with **runtime deployment** (phone-first default) and **provider** choices wired through prefs and the mock runtime
- **OpenClaw Gateway integration:** HTTP chat (`/v1/chat/completions` + SSE), optional **WebSocket `hello-ok` test**, gateway settings UI
- docs: `app/mobile/flutter_app/docs/RUNTIME_DEPLOYMENT.md`, **`app/mobile/flutter_app/docs/GATEWAY_HTTP.md`**
- a partially cleaned analysis/build path (re-verify with local Flutter)
- installed Flutter/Android tooling on some hosts; **Windows dev environments may need Flutter on PATH** for CLI runs

Immediate task for next agent:
**Run `flutter analyze` / `flutter test` (and optional APK build). Next product step: real `RuntimeClient` / Android runtime, or persistent gateway WebSocket session — see [`NEXT_STEPS.md`](../planning/NEXT_STEPS.md).**
