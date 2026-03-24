# PocketClaw Android Dependency Audit

## Purpose

This document looks at PocketClaw from the perspective that actually matters now:

**What assumptions does OpenClaw currently make that may become painful, fragile, or unrealistic on Android?**

The goal is not to guess everything perfectly.
The goal is to identify the likely technical fault lines early.

## Audit framing

OpenClaw today is much more comfortable on full operating systems than on mobile.
That means PocketClaw is not just a UI project. It is a runtime adaptation problem.

This audit focuses on these categories:
- runtime / Node assumptions
- process model assumptions
- filesystem assumptions
- network assumptions
- tool assumptions
- plugin/channel assumptions
- secrets/config assumptions

---

## 1. Runtime / Node assumptions

### What OpenClaw likely assumes
- a standard Node.js runtime
- unrestricted JavaScript execution environment
- predictable process lifecycle
- normal OS-level file and network access
- ability to start, monitor, and reconnect to services

### Why this matters on Android
Android apps do not behave like normal Linux boxes.
Even if some runtime pieces can run, packaging and lifecycle behavior are very different.

### Main risks
- Node runtime embedding complexity
- native dependencies that do not behave cleanly on Android
- process termination under mobile lifecycle pressure
- mismatch between OpenClaw host assumptions and Android app constraints

### Audit conclusion
**High-risk area.**
This is probably the single biggest technical dependency cluster for PocketClaw.

---

## 2. Process model assumptions

### What OpenClaw likely assumes
- long-lived processes are acceptable
- services can stay available
- subprocesses can be launched when needed
- background work is relatively normal

### Why this matters on Android
Android is aggressively hostile to daemon-like behavior unless you design around foreground services, lifecycle transitions, and battery optimization.

### Main risks
- child process handling may be unreliable or constrained
- long-lived background agent behavior may be interrupted
- app restarts and process death may become normal operating conditions
- shell-style orchestration may not translate well to mobile

### Audit conclusion
**Very high-risk area.**
PocketClaw should assume restart/recovery is normal, not exceptional.

---

## 3. Filesystem assumptions

### What OpenClaw likely assumes
- normal workspace directories
- normal config file persistence
- broad file read/write behavior inside a user-controlled environment
- log files and memory files stored in a conventional filesystem layout

### Why this matters on Android
Android app storage is sandboxed, scoped, and not equivalent to a normal user home directory.

### Main risks
- workspace layout may need adaptation
- assumptions about absolute paths may break
- some tooling may expect a richer filesystem than Android app storage offers
- import/export flows may need explicit UX rather than raw file access

### Audit conclusion
**Medium to high-risk area.**
Likely solvable, but the storage model must be designed intentionally.

---

## 4. Network assumptions

### What OpenClaw likely assumes
- local ports can be bound normally
- local WebSocket / HTTP communication is fine
- gateway services can remain reachable
- network presence can be stable enough for agent workflows

### Why this matters on Android
Local networking inside a phone app is possible, but lifecycle, permissions, background behavior, and OS restrictions matter much more.

### Main risks
- loopback communication may work, but must be validated inside Android app + service architecture
- exposed network modes should not be assumed early
- persistent gateway assumptions may conflict with mobile lifecycle behavior

### Audit conclusion
**Medium-risk area.**
Likely manageable for local in-app communication, less comfortable for persistent server behavior.

---

## 5. Tool assumptions

### What OpenClaw likely assumes
- shell/runtime tools exist
- filesystem tools are useful and available
- automation tools can interact with the host meaningfully
- tool exposure can be broad in a trusted environment

### Why this matters on Android
Many desktop/server-oriented tools either do not make sense on mobile or become dangerous/confusing fast.

### Main risks
- runtime exec/process assumptions are much less appropriate on a phone
- unrestricted filesystem tooling is ugly for a sandboxed mobile app
- host automation semantics differ massively from desktop/server semantics
- users do not expect “agent shell access” as a default mobile experience

### Audit conclusion
**High-risk area if left unchanged.**
PocketClaw probably needs a **mobile-safe default tool profile**.

---

## 6. Plugin and channel assumptions

### What OpenClaw likely assumes
- channels like Telegram/Discord can be configured similarly to server or desktop environments
- plugins can rely on a stable host runtime
- gateway behavior can be service-oriented

### Why this matters on Android
Some integrations may still work, but setup, reliability, and permissions become more fragile on mobile.

### Main risks
- long-running channel connectivity may suffer under background restrictions
- plugin assumptions may not survive mobile lifecycle changes
- UX for tokens, pairings, and channel config must be simplified heavily

### Audit conclusion
**Medium to high-risk area.**
Best treated as secondary after core local runtime and chat work.

---

## 7. Secrets and config assumptions

### What OpenClaw likely assumes
- config files can safely store settings
- users can edit config manually if needed
- API keys can be placed into config and environment safely enough on a personal machine

### Why this matters on Android
On mobile, secret handling must be more productized.
Users should never need to think in terms of raw config files.

### Main risks
- config-file-centric setup is unacceptable for PocketClaw UX
- secrets need proper secure storage
- migration/reset flows must be app-driven
- validation needs to happen inside the product, not by hoping the user edited a file correctly

### Audit conclusion
**High-priority product adaptation area.**
Probably not the hardest technical area, but absolutely critical for usability and trust.

---

## 8. Logging, memory, and persistence assumptions

### What OpenClaw likely assumes
- logs are visible in files and status commands
- memory files are available in a normal filesystem hierarchy
- diagnostics can be read through CLI and file inspection

### Why this matters on Android
Normal users will not inspect log files manually.
The product has to surface enough diagnostics in-app.

### Main risks
- debugging becomes impossible without a proper diagnostics screen
- memory/workspace structures may exist but still need UX wrapping
- recovery flows need user-readable explanations

### Audit conclusion
**Medium-risk technically, high-priority product-wise.**

---

## Overall dependency risk ranking

### Highest risk
1. runtime / Node assumptions
2. process model assumptions
3. tool model assumptions

### Medium-high risk
4. plugin/channel behavior
5. filesystem/storage model
6. secrets/config adaptation

### Medium risk
7. local networking
8. logging/persistence UX wrapping

---

## Most likely architectural consequence
PocketClaw should not assume it can simply “run normal OpenClaw on Android” without adaptation.

The more realistic hypothesis is:
- some OpenClaw runtime assumptions can be preserved
- some must be wrapped by Android-native lifecycle management
- some features/tools must be reduced or gated in the mobile product
- some channel/runtime expectations may need a staged rollout rather than day-one parity

---

## What this means for the product

PocketClaw should likely start with:
- Android-first
- reduced feature surface
- mobile-safe default tool profile
- foreground/runtime-managed architecture
- strong persistence and diagnostics layer

It should **not** start by trying to expose everything OpenClaw can do on a normal host.
That would be the fast lane to a broken, battery-hungry, confusing app.

---

## Recommended next action
Use this audit to drive a **technical dependency matrix**:
- dependency / assumption
- Android risk level
- likely mitigation
- MVP impact

That would turn this analysis into something implementation teams can actually use.