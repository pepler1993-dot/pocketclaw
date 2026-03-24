# PocketClaw Technical PoC Plan

## Purpose

This document defines the first serious technical proof of concept for PocketClaw.

The goal is not to build the whole product at once.
The goal is to prove the hardest assumptions early and cheaply.

## Main question

**Can OpenClaw be turned into a usable Android-first mobile product with a local runtime and a simple interface?**

## PoC scope

The PoC should prove these things:

1. A mobile app can manage a local OpenClaw runtime or runtime-like service
2. A user can complete setup without touching raw config files
3. A user can send messages and receive replies from inside the app
4. Runtime state and basic configuration survive app restarts
5. Errors can be surfaced in a way normal users can understand

## PoC platform

- **Primary target:** Android
- **Not in first PoC:** full iPhone parity

## PoC features

### Must have
- launch local runtime from app
- stop local runtime from app
- onboarding flow
- provider/API key input
- simple chat UI
- runtime status screen
- basic logs screen
- persistent local config/state

### Should have
- simple model selection
- health check button
- reset/restart controls
- safe defaults for local-only mode

### Not needed yet
- voice assistant
- marketplace/features catalog
- every OpenClaw tool
- every channel integration
- polished design system
- iOS support

## Proposed implementation order

### Step 1 — Feasibility spike
- verify what parts of OpenClaw can run on Android
- identify runtime packaging approach
- list blockers and unknowns

### Step 2 — Runtime controller prototype
- minimal Android shell app
- start/stop runtime
- show status
- persist config path and workspace path

### Step 3 — Basic assistant UI
- text chat screen
- send/receive messages
- connection state indicator
- simple error display

### Step 4 — Onboarding
- welcome flow
- provider selection
- API key entry
- local mode explanation
- permission requests

### Step 5 — Stability pass
- app restart behavior
- runtime restart behavior
- config persistence
- logs and diagnostics

## Success criteria

The PoC succeeds if a tester can:
- install the Android app
- complete setup in-app
- start the assistant runtime
- send a message and receive a reply
- inspect status/logs without technical knowledge

## Failure criteria

The PoC fails if:
- runtime control only works through manual shell steps
- setup depends on editing config files outside the app
- app cannot reliably reconnect after restart
- Android platform limits make the core architecture impractical

## Immediate next engineering tasks

1. Decide Android app stack
2. Research runtime packaging strategy
3. Define config storage model
4. Define assistant chat transport path
5. Create first Android prototype repo structure
