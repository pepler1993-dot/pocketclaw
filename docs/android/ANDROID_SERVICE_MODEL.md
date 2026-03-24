# Android Service Model

## Purpose

This document narrows the architecture question further:

**What Android service/process model should PocketClaw use for the MVP?**

## Main requirement
PocketClaw needs a model that allows:
- runtime control from the app
- reliable status reporting
- restart/recovery handling
- enough continuity to feel usable
- behavior that fits Android realities

## Candidate models

## Model A — App-only foreground runtime
The runtime only exists while the app is open and active.

### Pros
- simplest lifecycle
- lowest background complexity
- easier to reason about
- lower risk for first prototype

### Cons
- weak assistant continuity
- less impressive product feel
- no serious persistence story

### Verdict
Useful for earliest technical experiment, but probably too weak as MVP product model.

---

## Model B — Foreground service managed runtime
PocketClaw uses an Android foreground service to manage runtime behavior when active runtime continuity matters.

### Pros
- far more realistic than pretending invisible daemon behavior
- better fit for Android rules
- gives users visible runtime state
- creates a workable compromise between continuity and platform compliance

### Cons
- more Android-native implementation work
- notification/service UX must be designed carefully
- some users may dislike persistent service notification behavior

### Verdict
**Most realistic MVP candidate.**

---

## Model C — Aggressive background persistence attempt
PocketClaw tries to stay alive in the background without embracing foreground-service semantics properly.

### Pros
- sounds attractive in theory

### Cons
- fragile
- device/vendor dependent
- likely to feel broken
- bad trust experience when runtime disappears unpredictably

### Verdict
Do not build around this assumption.

---

## Recommended service model
Use **Model B: Foreground service managed runtime** as the MVP direction.

## Why
Because it is the most honest compromise between:
- product usefulness
- Android compliance
- runtime continuity
- user trust

## Product-facing interpretation
PocketClaw should treat runtime activity as something visible and manageable.

That means:
- user can see whether the assistant is active
- user can start/stop it intentionally
- user can understand when Android constraints matter

## Control surface needed
The app should support:
- start assistant runtime
- stop assistant runtime
- restart assistant runtime
- show current status
- show last error
- open diagnostics

## State transitions
Suggested lifecycle:
- configured but stopped
- starting
- running
- degraded
- stopping
- stopped
- failed

## Recovery model
If runtime dies unexpectedly:
- state updates in app
- user sees plain-language explanation
- restart action is obvious
- diagnostics are easy to reach

## Next technical question
After choosing this model, the next detailed question becomes:

**How does the foreground service communicate with the embedded/managed OpenClaw runtime?**

That should likely be resolved in the runtime communication spike.