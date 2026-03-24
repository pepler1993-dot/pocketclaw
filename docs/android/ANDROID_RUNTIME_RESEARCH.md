# Android Runtime Research

## Purpose

This document explores the hardest technical question in PocketClaw:

**How can OpenClaw realistically run on Android in a way that feels like a real product?**

This is not a marketing document. It is a practical research note meant to identify viable directions, likely blockers, and the most realistic first path.

## Core problem

OpenClaw was not originally designed as a mobile-first app runtime.

PocketClaw needs to translate a system that normally expects a more flexible host environment into something that can work inside Android's constraints:

- app sandboxing
- foreground/background limits
- battery management restrictions
- file access limitations
- process lifecycle interruptions
- permission friction

## Main architectural options

## Option A — Embedded local runtime inside the Android app
The app bundles and manages a local runtime directly on-device.

### Advantages
- strongest local-first story
- best privacy narrative
- direct control from app UI
- no separate server required

### Risks
- OpenClaw runtime assumptions may not map cleanly to Android
- long-running background behavior may be unreliable
- updates and process management become more complex
- debugging mobile lifecycle issues will be painful

### Assessment
This is the most compelling product path, but also the hardest implementation path.

## Option B — Managed local companion runtime on Android
The mobile app acts as the main UX shell while a managed local service/process handles runtime behavior.

### Advantages
- cleaner separation between UI and runtime
- may fit Android architecture better than forcing everything into the app shell
- better chance of structured lifecycle control

### Risks
- still subject to Android background/service limitations
- native Android integration work becomes mandatory
- service reliability under battery optimization may still be messy

### Assessment
This is probably the most realistic Android-first direction.

## Option C — Mobile app as control surface, runtime elsewhere
The app provides great mobile UX but the actual OpenClaw runtime lives on another local or remote machine.

### Advantages
- much easier technically
- avoids many Android runtime constraints
- can ship faster

### Risks
- weakens the core local-on-phone product vision
- less differentiated
- feels more like a companion app than the intended product

### Assessment
Useful fallback strategy, but not the main vision.

## Most realistic recommendation

For the **first serious Android PoC**, the best path is likely:

**UI shell in Flutter + Android-native service/process layer for runtime management.**

That means:
- Flutter handles onboarding, settings, chat, logs, and controls
- Android-native code handles runtime/service/process lifecycle where needed
- the first goal is not perfect background autonomy, but reliable local operation under realistic app conditions

## Key technical questions

## 1. Can OpenClaw runtime actually execute on Android?
Questions:
- what Node/runtime assumptions does OpenClaw require?
- can required binaries and dependencies run inside Android app context?
- what parts would need adaptation or replacement?

Research tasks:
- inspect OpenClaw runtime dependencies
- identify OS-level assumptions
- identify filesystem assumptions
- identify networking assumptions

## 2. How should runtime lifecycle work?
Questions:
- should PocketClaw start the runtime only when the app is active?
- can a foreground service keep it alive for longer sessions?
- what happens after process death or app restart?

Likely reality:
- persistent daemon-like behavior may be limited
- foreground-service-based runtime management may be the practical compromise

## 3. How should app and runtime communicate?
Possible approaches:
- local loopback HTTP/WebSocket
- local Unix-domain/socket equivalent if practical
- direct native bridge integration

Most likely first choice:
- local loopback communication if Android allows it cleanly in-app/service architecture

## 4. Where do config and workspace live?
Needs:
- local app-private storage
- clear config directory
- clear workspace directory
- secure secrets storage for provider keys

Likely split:
- app-private files for config/workspace
- Android secure storage / keystore-backed solution for secrets

## 5. What tool surface is safe on mobile?
OpenClaw on mobile should probably not expose every tool by default.

Likely mobile-safe starting point:
- chat/session tools
- model/provider configuration
- selected device-aware integrations later

Likely dangerous/noisy by default:
- unrestricted runtime shell access
- broad filesystem operations outside app scope
- desktop-like automation assumptions

PocketClaw likely needs a **mobile-safe tool profile**.

## Android-specific realities

## Background execution
Android aggressively limits background activity, especially on consumer devices with vendor battery management.

Implications:
- never assume perfect long-running persistence
- design for restart/recovery
- foreground-service approaches are more realistic than hidden daemon assumptions
- the product must explain runtime state clearly to users

## Battery optimization
Users may need to disable battery optimization for reliable longer runtime sessions.

This has UX implications:
- explain why the permission matters
- do not require it too early if avoidable
- only ask when the user actually needs persistent behavior

## App restarts and process death
PocketClaw should assume that Android may kill processes.

Design implication:
- state restoration matters a lot
- config generation must be deterministic
- logs and status must help users recover

## Security implications
PocketClaw should be honest and conservative.

Recommendations:
- app-private storage by default
- keystore-backed secret storage
- explicit provider key validation
- local-only mode as safe default
- advanced/external networking hidden behind explicit user choice

## Recommended first experiments

### Experiment 1 — Dependency audit
Map what OpenClaw actually needs at runtime on Android.

### Experiment 2 — Process control spike
Try starting/stopping a minimal runtime-like process from Android and expose status back to UI.

### Experiment 3 — Local communication spike
Validate loopback communication between app shell and managed local service/process.

### Experiment 4 — Persistence spike
Verify config/state/log persistence across app restarts and process death.

### Experiment 5 — Battery/background behavior test
Measure realistic behavior when app goes background on Android.

## Working hypothesis

The first viable PocketClaw product will probably look like this:

- Android app built in Flutter
- native Android service/process control layer
- local config/workspace in app-private storage
- secure provider key storage
- limited mobile-safe feature set first
- restartable runtime, not magical always-on daemon assumptions

## Brutal truth

The hardest part is not building chat UI.
The hardest part is making runtime behavior on Android reliable enough that normal people do not think the app is broken.

That is where the project lives or dies.

## Recommendation

Proceed with an **Android runtime feasibility spike** before any major implementation push.

PocketClaw should prove runtime control, local config persistence, and in-app chat before investing heavily in broader feature work.