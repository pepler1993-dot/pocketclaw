# Runtime Spike Plan

## Purpose

This plan turns the Android runtime question into a sequence of concrete spikes.

The goal is not to overbuild.
The goal is to remove the biggest uncertainties in the smallest useful order.

## Main question

**Can PocketClaw reliably control a local OpenClaw runtime on Android in a way that can become a real product?**

## Spike strategy

Each spike should answer one technical question clearly enough to support a product decision.

---

## Spike 1 — Runtime assumption audit

### Goal
Identify the exact runtime assumptions that may fail on Android.

### Questions
- What does OpenClaw need from Node?
- What child process assumptions exist?
- What filesystem assumptions exist?
- What networking assumptions exist?

### Output
- dependency summary
- blocker list
- first go/no-go notes

### Why first
Because there is no point designing clever app architecture on top of fantasy assumptions.

---

## Spike 2 — Android lifecycle control prototype

### Goal
Prove that PocketClaw can start, stop, restart, and inspect a managed runtime/service from Android.

### Questions
- Can the runtime be controlled predictably?
- What state survives app restart?
- What state survives process death?
- Does the runtime need a foreground service model?

### Output
- lifecycle prototype notes
- control-state model draft
- runtime state diagram

### Success condition
We can start/stop/restart and report state clearly.

---

## Spike 3 — App-to-runtime communication spike

### Goal
Validate a clean communication path between UI and runtime.

### Candidate paths
- loopback HTTP
- loopback WebSocket
- native bridge

### Questions
- Which path is simplest and stable enough?
- How does reconnect behavior work?
- What happens after runtime restart?

### Output
- communication recommendation
- reconnect assumptions
- failure handling notes

---

## Spike 4 — Config, secrets, and workspace persistence

### Goal
Define how PocketClaw stores what it needs without becoming messy or insecure.

### Questions
- Where does config live?
- Where does workspace data live?
- Where do secrets live?
- How do reset and migration flows work?

### Output
- storage model draft
- secret handling recommendation
- reset/recovery notes

---

## Spike 5 — Background and battery behavior

### Goal
Find out how fragile the runtime becomes once Android behaves like Android.

### Questions
- What happens when app goes background?
- What happens under battery optimization?
- What can realistically be promised to users?
- Does the product need explicit “active session” semantics?

### Output
- background behavior report
- user-facing constraints list
- product copy implications

---

## Spike 6 — Mobile-safe tool profile

### Goal
Define what OpenClaw features should be available in PocketClaw by default.

### Questions
- Which tools are safe and sensible on mobile?
- Which tools should be advanced-only?
- Which tools should be excluded from MVP?

### Output
- mobile-safe default tool profile
- advanced-mode candidates
- MVP exclusions

---

## Decision gates

### Gate A — Runtime viability
After spikes 1 and 2:
- can Android realistically host the runtime model we want?
- if not, do we pivot to a companion architecture?

### Gate B — Communication and persistence viability
After spikes 3 and 4:
- can the runtime be made usable and recoverable enough for a product?

### Gate C — Product honesty gate
After spikes 5 and 6:
- what can PocketClaw promise honestly in MVP?
- what must be delayed?

---

## Recommended order of execution
1. runtime assumption audit
2. lifecycle control prototype
3. app-to-runtime communication
4. config/secrets/workspace persistence
5. background/battery behavior
6. mobile-safe tool profile

## Expected result of this phase
At the end of the spike phase, the team should have:
- a realistic Android runtime architecture direction
- a shortlist of hard blockers
- an honest MVP boundary
- enough certainty to begin implementation without pretending away platform limits

## Anti-goals
This phase should not become:
- a full app build
- a design-system exercise
- an iPhone parity effort
- endless architecture speculation without experiments

## Final note
PocketClaw succeeds if the ugly technical parts are confronted early.
This spike plan exists to force that honesty.