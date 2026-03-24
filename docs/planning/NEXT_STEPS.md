# Next steps

Single place for **what to do next**. Older split docs (`NEXT_STEPS_PRIORITY`, `NEXT_IMPLEMENTATION_STEP`) were merged here.

## Now (validation)

1. On a machine with Flutter on `PATH`: `cd app/mobile/flutter_app` → `flutter analyze` → `flutter test` → optional `flutter run` / `flutter build apk`.
2. Note blockers (device, emulator, Gradle) in an issue or in `docs/development/PROJECT_STATUS.md`.

## Then (product + mock depth)

1. Improve provider/runtime UX where gaps show up in real use.
2. Extend mock or introduce a **narrow runtime client interface** before wiring a real gateway.

## Parallel (Android / OpenClaw)

1. Runtime feasibility: app ↔ local service/process boundary (see `docs/android/`).
2. Spike order and architecture choices remain documented under `docs/android/` and `docs/architecture/`.

## Principle

**Run first, refine second** — a working build on a real device beats more blind UI-only iteration.
