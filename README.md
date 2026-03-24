# PocketClaw

**PocketClaw makes OpenClaw usable on mobile devices.**

The project aims to turn OpenClaw into a real mobile product with a clean, understandable interface so people can run and use their assistant on a phone without dealing with terminals, config files, or server admin work.

## Core idea

PocketClaw is not meant to be a developer control panel squeezed onto a phone.
It is meant to be:

- mobile-first
- local-first where possible
- privacy-aware
- simple by default
- powerful when needed

## Product goal

PocketClaw should allow users to:

- run OpenClaw locally on a mobile device where technically possible
- configure models, tools, and connections through a simple UI
- chat with their assistant by text and later by voice
- manage runtime status, logs, and settings without touching config files

## Product direction

The current direction is:

- **Android first**
- **iPhone later, with realistic expectations around platform limits**
- **MVP before feature sprawl**

## Why this matters

OpenClaw is powerful, but for most people it is still too technical.
PocketClaw exists to close that gap.

The real challenge is not just getting OpenClaw to run on a phone.
The real challenge is making it feel easy, safe, and pleasant to use.

## Documentation

All planning and engineering docs are under **`docs/`**. Start here:

- **[docs/README.md](docs/README.md)** — full index (product, architecture, Android, planning, dependencies, status)

Highlights:

- **Product:** [docs/product/](docs/product/) — vision, principles, MVP, feasibility
- **Next steps:** [docs/planning/NEXT_STEPS.md](docs/planning/NEXT_STEPS.md)
- **Agent / status:** [docs/development/AGENT_HANDOFF.md](docs/development/AGENT_HANDOFF.md), [docs/development/PROJECT_STATUS.md](docs/development/PROJECT_STATUS.md)

## Flutter app

Code: **`app/mobile/flutter_app`**

- [app/mobile/flutter_app/README.md](app/mobile/flutter_app/README.md)
- Runtime deployment (feature doc): [app/mobile/flutter_app/docs/RUNTIME_DEPLOYMENT.md](app/mobile/flutter_app/docs/RUNTIME_DEPLOYMENT.md)

## Status

Early implementation: Flutter shell with onboarding, chat, runtime/diagnostics (mock), settings, and persisted **runtime deployment** (phone-first default). Re-run `flutter analyze` / `flutter test` locally to validate.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).
