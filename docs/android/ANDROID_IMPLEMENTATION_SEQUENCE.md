# Android Implementation Sequence (Flutter-First)

This sequence defines the first practical path from repository setup to an
Android Proof of Concept (PoC) using Flutter as the mobile UI layer.

## 1) Repository and Tooling Setup

1. Confirm Flutter and Android SDK versions used by the team.
2. Keep mobile code under `app/mobile/flutter_app`.
3. Add CI checks for Dart formatting, static analysis, and tests.

## 2) Minimal Flutter App Shell

1. Create app entrypoint and root shell navigation.
2. Establish placeholder screens for:
   - Chat
   - Runtime control/status
   - Diagnostics
   - Settings
3. Centralize theme to avoid styling drift.

## 3) Android Host Integration

1. Add Android host project files (`android/`) and Gradle config.
2. Configure package/application ID strategy for debug/release variants.
3. Validate first local build and app launch on an emulator/device.

## 4) Runtime and Service Contract PoC

1. Define basic contract between Flutter UI and runtime layer.
2. Implement one vertical slice:
   - Trigger runtime action
   - Observe status update
   - Surface logs/errors in diagnostics view
3. Keep interfaces simple and mockable.

## 5) Persistence and Settings Basics

1. Add lightweight local persistence for essential app settings.
2. Expose editable values in the settings screen.
3. Ensure defaults are safe and recoverable.

## 6) Observability and Developer Feedback

1. Add structured logs for runtime events and failures.
2. Include a simple diagnostics panel for current build/runtime state.
3. Add crash/error capture strategy suitable for Android testing phase.

## 7) PoC Exit Criteria

The first PoC is complete when:

- App launches on Android emulator and at least one physical device.
- Navigation between all four screens works.
- One runtime interaction flow is functional end-to-end.
- Diagnostics screen shows actionable state/log output.
- Basic settings persistence works across app restarts.

## 8) Immediate Post-PoC Follow-ups

1. Replace placeholder UI with product-level UX flows.
2. Harden runtime error handling and reconnection behavior.
3. Add test coverage for core navigation and runtime integration paths.
