# Repository Structure Draft

## Suggested near-term structure

```text
pocketclaw/
  README.md
  CONTRIBUTING.md
  docs/
    README.md
    product/
    architecture/
    android/
    planning/
    dependencies/
    meta/
    development/
  app/
    mobile/
      flutter_app/
  runtime/
    android/
      notes/
      experiments/
  assets/
    mockups/
    diagrams/
```

## Purpose of folders

### docs/product / docs/architecture / docs/android / …
See [`docs/README.md`](../README.md). Topic folders replace an older idea of `docs/research`, `docs/ux`, etc.

### app/mobile/flutter_app
Main Flutter application.

### runtime/android
Android-specific runtime control experiments, service/process integration notes, native bridge work.

### assets/mockups
Wireframes and screen mockups.

### assets/diagrams
Architecture diagrams, flowcharts, state diagrams.

## Principle
Keep product docs and implementation close, but not mixed into chaos.

## Next practical step
`docs/` and `app/` exist; add `runtime/` and `assets/` when native/runtime and design assets land.