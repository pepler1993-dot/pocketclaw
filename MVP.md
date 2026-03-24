# MVP Definition

## MVP Goal
Build the smallest useful version of PocketClaw that proves the product is viable.

## Recommended MVP scope

### Platform
- Android only

### Core capabilities
- install/run local PocketClaw runtime on device
- text chat with assistant
- onboarding flow for first setup
- API key/provider configuration
- start/stop runtime controls
- status screen
- simple settings screen
- basic logs/debug screen

### Nice to have, not day one
- speech input
- spoken replies
- Telegram/Discord channel setup
- multi-profile support
- advanced tool configuration
- iPhone version

## User story for MVP
A user installs PocketClaw on Android, completes a guided setup, adds a model provider key, starts the local runtime, and successfully chats with their assistant from inside the app.

## Success criteria
- setup can be completed without terminal access
- runtime can be started and stopped from UI
- user can send and receive messages reliably
- state survives app restarts
- app explains failures clearly

## Explicit non-goals for MVP
- full cross-platform parity
- every OpenClaw feature exposed at launch
- deep enterprise capabilities
- highly polished voice stack
- advanced automation marketplace

## Why this MVP
Because it proves the hardest and most important thing first:
**can OpenClaw be turned into a simple, usable mobile product?**