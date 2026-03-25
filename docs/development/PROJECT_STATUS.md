# PocketClaw Project Status — 2026-03-24

> **Note:** Repository documentation was reorganized into `docs/` (by topic). This file is a historical snapshot; the canonical doc index is [`docs/README.md`](../README.md).

## Summary
PocketClaw has moved from a rough product idea into a structured early-stage product and engineering repository.

The project now has:
- a clearer product vision
- a realistic Android-first strategy
- a technical feasibility direction
- an initial Flutter app shell
- a generated Flutter project scaffold
- a first visual identity direction inspired by OpenClaw

This document summarizes what has been done so far.

---

## 1. Product direction established

The PocketClaw concept has been sharpened into:
- a mobile-first OpenClaw experience
- focused on making OpenClaw usable for normal users
- local-first where possible
- Android-first for realistic MVP execution
- iPhone treated honestly as a harder later-stage target

### Key product docs (now under `docs/`)
- [`docs/product/`](../product/) — vision, principles, MVP, feasibility
- [`docs/architecture/`](../architecture/) — architecture, stack decision, repo structure draft
- [`docs/planning/`](../planning/) — POC plan, roadmap, screen flow, UI preview, [`NEXT_STEPS.md`](../planning/NEXT_STEPS.md)

---

## 2. Android-first technical direction established

The project now contains a clearer technical path for Android:
- Android-first PoC scope
- Flutter as app/product shell
- native Android service/runtime integration where needed
- realistic foreground-service thinking
- runtime feasibility and dependency-risk analysis

### Key technical docs (now under `docs/`)
- [`docs/android/`](../android/) — PoC spec, runtime research/experiments/recommendations, architecture draft, service model, implementation sequence, runtime spike plan
- [`docs/dependencies/`](../dependencies/) — audit and matrix

---

## 3. Product UX and visual direction improved

The app has been moved away from a generic placeholder feeling.

Current visual/product direction:
- dark-first
- black / charcoal surfaces
- red accent color
- OpenClaw-inspired identity
- clean, sharp, operational tool feel

### UX / meta docs (now under `docs/`)
- [`docs/planning/UI_PREVIEW.md`](../planning/UI_PREVIEW.md)
- [`docs/meta/`](../meta/) — ideas, idea template, GitHub issue drafts

---

## 4. GitHub project setup progressed

The PocketClaw GitHub repository was created and connected.

Repository currently contains:
- core project docs
- roadmap material
- implementation planning docs
- app scaffold
- generated Flutter project structure

A growing set of GitHub issues has also been created to turn planning into work items.

---

## 5. First app shell created

An initial Flutter-first product shell has been created under:
- `app/mobile/flutter_app`

### App shell includes
- `lib/main.dart`
- `lib/app.dart`
- onboarding flow
- provider setup screen (runtime **deployment** target + model/API provider)
- main shell navigation
- chat screen
- runtime screen
- diagnostics screen
- settings screen
- product widgets
- dark theme setup
- simple app flow controller

### Screens added / improved
- `onboarding_screen.dart`
- `provider_setup_screen.dart`
- `chat_screen.dart`
- `runtime_screen.dart`
- `diagnostics_screen.dart`
- `settings_screen.dart`
- `theme/app_theme.dart`
- `widgets/product_widgets.dart`
- `flow/app_flow_controller.dart`

---

## 6. Flutter environment installed on host

Flutter setup work has already been done on the host environment.

### Installed and configured
- Flutter SDK
- Dart
- Java 17
- Android SDK
- Android platform tools
- Android platform 35
- Android build tools 35.0.0
- Android SDK licenses accepted

### Outcome
The environment is now much closer to being able to run the PocketClaw Flutter app.

Important caveat:
- Flutter currently runs as root in this environment, which is not ideal for normal development
- Android device/emulator connection still needs to be validated

---

## 7. Flutter project fully initialized

The Flutter project inside `app/mobile/flutter_app` has now been properly initialized with:

```bash
flutter create .
```

### Result
The project now contains real Flutter platform scaffolding for:
- Android
- iOS
- macOS
- Linux
- web
- Windows

For PocketClaw, the most relevant immediate result is:
- Android project structure now exists
- the custom PocketClaw UI shell remains intact
- the app is now a real Flutter project instead of just partial UI files

---

## 8. Current project state

### Strong areas
- product direction is much clearer
- technical risks are being handled honestly
- repository structure is serious
- app shell now has visible product identity
- Flutter project is real and initialized

### Main unresolved technical area
- Android runtime lifecycle and real runtime communication

### Main unresolved practical area
- first real run on device or emulator

---

## 8a. Update 2026-03-25 — OpenClaw Gateway (HTTP + WebSocket)

The Flutter app now integrates the **OpenClaw Gateway** at the HTTP layer and can prove **WebSocket control-plane** connectivity:

- **Unified chat routing** (`UnifiedChatService`): optional **gateway base URL + operator token** (secure storage). When enabled, chat uses the gateway’s OpenAI-compatible **`/v1/chat/completions`** (and SSE streaming) with priority over direct `api.openai.com`.
- **Settings → OpenClaw Gateway:** toggle, URL, token, **Save**, **Test connection** (`GET /v1/models`), **Test WebSocket** (`connect` → `hello-ok`, protocol 3, Ed25519 device identity persisted on device).
- **Android:** cleartext HTTP allowed for LAN gateways (`usesCleartextTraffic`); production should prefer TLS or VPN where possible.
- **Documentation:** [`app/mobile/flutter_app/docs/GATEWAY_HTTP.md`](../../app/mobile/flutter_app/docs/GATEWAY_HTTP.md); repo index and [`NEXT_STEPS.md`](../planning/NEXT_STEPS.md) updated.

Runtime/diagnostics **UI remains mock-backed**; next large step is still real on-device or remote runtime control (see `docs/android/`).

---

## 9. Recommended next order

See the living document **[`docs/planning/NEXT_STEPS.md`](../planning/NEXT_STEPS.md)** (replaces older `NEXT_STEPS_PRIORITY` / `NEXT_IMPLEMENTATION_STEP` files).

---

## Bottom line
PocketClaw is no longer just a project idea.
It now has enough structure, implementation direction, and app groundwork to be treated as a real early-stage product effort.