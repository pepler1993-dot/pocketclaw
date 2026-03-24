# Android Runtime Recommendation

## Current recommendation
Do **not** assume PocketClaw can ship by just packaging existing OpenClaw behavior unchanged.

## Recommended direction
Build PocketClaw around this working assumption:

- Flutter app for UX/product shell
- Android-native runtime/service management where needed
- mobile-safe default tool surface
- app-private storage for config/workspace
- secure in-app secrets handling
- restart/recovery treated as a normal part of runtime behavior

## Recommendation for MVP scope
The MVP should prove:
- provider setup
- runtime start/stop
- runtime status
- text chat
- logs/diagnostics
- state persistence

The MVP should not try to prove:
- every tool
- every channel
- perfect background permanence
- iPhone parity

## Product truth
If PocketClaw can make runtime control and recovery feel understandable, the rest of the product can grow.
If it cannot, no amount of polished UI will save it.

## Immediate engineering next step
Create a technical spike focused on:
1. runtime packaging assumptions
2. Android lifecycle/process control
3. app-to-runtime communication
4. persistence and restart behavior

That is the shortest path to real certainty.