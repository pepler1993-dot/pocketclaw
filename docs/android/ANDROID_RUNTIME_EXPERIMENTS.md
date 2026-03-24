# Android Runtime Experiments

## Goal
Turn Android runtime uncertainty into concrete engineering answers.

## Experiment 1 — OpenClaw dependency audit
### Question
What does OpenClaw require that may conflict with Android?

### Check
- Node/runtime assumptions
- child process assumptions
- filesystem assumptions
- network binding assumptions
- plugin/tool assumptions

### Output
Short dependency/risk report.

---

## Experiment 2 — Runtime lifecycle control
### Question
Can the app reliably start, stop, and inspect a managed local runtime/service?

### Check
- start action
- stop action
- restart action
- status reporting
- failure reporting

### Output
Runtime controller prototype notes.

---

## Experiment 3 — App-to-runtime communication
### Question
Can Flutter UI communicate cleanly with the local runtime on Android?

### Check
- loopback HTTP/WebSocket viability
- reconnect behavior
- latency and reliability

### Output
Recommended communication mechanism.

---

## Experiment 4 — Persistence and recovery
### Question
What survives app restart, process death, and state restoration?

### Check
- config persistence
- workspace persistence
- secret persistence
- log persistence
- reconnect behavior after restart

### Output
Persistence/recovery behavior summary.

---

## Experiment 5 — Background and battery behavior
### Question
How fragile is the local runtime under Android background restrictions?

### Check
- foreground only
- short background pause
- long background pause
- battery optimization enabled/disabled
- vendor-specific kill behavior (if test hardware allows)

### Output
Background behavior report.

---

## Experiment 6 — Mobile-safe tool profile
### Question
What subset of OpenClaw should be exposed safely in a phone-first product?

### Check
- essential chat/runtime features
- dangerous by-default capabilities
- permission-gated capabilities
- future mobile-native tool opportunities

### Output
First mobile-safe tool profile draft.