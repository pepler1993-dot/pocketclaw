# Repository Structure Draft

## Suggested near-term structure

```text
pocketclaw/
  README.md
  VISION.md
  PRODUCT_PRINCIPLES.md
  TECH_FEASIBILITY.md
  MVP.md
  ARCHITECTURE.md
  POC_PLAN.md
  ANDROID_POC_SPEC.md
  STACK_DECISION.md
  REPO_STRUCTURE_DRAFT.md
  GITHUB_ISSUES_DRAFT.md
  docs/
    research/
    ux/
    decisions/
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

### docs/research
Feasibility notes, experiments, platform findings.

### docs/ux
Onboarding drafts, screen flows, copy notes, UI sketches.

### docs/decisions
Small ADR-style documents for important decisions.

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
Create the `docs/`, `app/`, `runtime/`, and `assets/` folder skeleton once the first Android PoC task starts.