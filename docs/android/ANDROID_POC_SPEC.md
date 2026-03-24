# Android PoC Spec

## Goal
Build the first serious Android proof of concept for PocketClaw.

The purpose of this PoC is to validate whether PocketClaw can become a usable Android-first product that lets users run and manage OpenClaw locally through a clean app interface.

## Primary question
Can an Android app provide a practical local runtime experience for OpenClaw without forcing users into terminal/config workflows?

## PoC scope

### In scope
- Android-only prototype
- simple app shell
- runtime start/stop controls
- basic status view
- provider/API key setup flow
- simple chat UI
- persistent local config/state
- basic error reporting
- logs/diagnostics screen

### Out of scope
- iPhone parity
- full voice stack
- all OpenClaw tools
- advanced automation setup
- full channel setup UX
- polished production design system

## Target user outcome
A tester installs the Android app, completes setup, starts the runtime, sends a message, receives a reply, and understands what state the system is in.

## Core screens

### 1. Welcome / onboarding
- what PocketClaw is
- what local mode means
- setup entry point

### 2. Provider setup
- choose provider
- add API key
- validate key
- save securely

### 3. Runtime screen
- start runtime
- stop runtime
- restart runtime
- status indicator
- last error summary

### 4. Chat screen
- message input
- message list
- assistant responses
- loading / failed states

### 5. Settings screen
- provider settings
- workspace/config reset
- local mode defaults
- advanced section hidden by default

### 6. Logs / diagnostics
- runtime logs
- health status
- last crash / last failure message

## Technical assumptions to validate
- how OpenClaw runtime can be embedded or managed on Android
- how config and workspace storage should work on-device
- how session communication should happen between UI and runtime
- how Android background rules affect runtime persistence
- whether a reduced mobile-safe tool profile is needed

## Success criteria
- no manual terminal access required
- runtime controlled from UI
- successful provider setup in app
- successful message exchange in app
- app restart does not destroy core state
- failures are visible and understandable

## Failure criteria
- setup still depends on shell commands
- runtime control is unreliable
- configuration is too fragile for normal users
- Android restrictions make the architecture impractical

## Build order
1. choose app stack
2. define Android runtime strategy
3. implement runtime controller shell
4. implement provider setup flow
5. implement chat view
6. implement logs/diagnostics
7. test persistence and restart behavior
