# Runtime deployment (where OpenClaw runs)

This document describes the **runtime deployment** feature added to the PocketClaw Flutter shell: a first-class choice for **where the OpenClaw gateway is expected to run**, separate from the **model/API provider** choice.

**Product default:** *This phone* (phone-first). Other options are optional paths for LAN, cloud, or a custom gateway.

## Concepts

| Concern | Role |
|--------|------|
| **Runtime deployment** | Target for the gateway process: this device, home LAN, OpenClaw Cloud, or custom URL (see `RuntimeDeploymentModel`). |
| **Model & API** | Shell-style: **model profile** (default / fast / capable) then **API connection** (embedded gateway, OpenClaw Cloud, OpenAI-compatible, Anthropic, custom base URL). See `ProviderConfigModel`. |

These are orthogonal: you can e.g. target a LAN gateway while still using a specific API provider string in the mock layer.

## Code map

| Piece | Location |
|-------|----------|
| Enum + labels + `fromSelectionLabel` | `lib/models/runtime_deployment_model.dart` |
| Persistence (`pc_runtime_deployment`) | `lib/persistence/app_prefs.dart` — `AppPrefsSnapshot.runtimeDeploymentLabel`, `saveAfterSetup`, `saveRuntimeDeploymentLabel` |
| Onboarding flow state | `lib/flow/app_flow_controller.dart` — `selectedDeployment`, `setDeployment`, `hydrateFromPrefs`, `completeSetup` |
| Hydration + session wiring | `lib/app.dart` — passes `snap.runtimeDeploymentLabel` into the flow controller; builds `MockRuntimeService` with `deployment:` |
| First-run setup UI | `lib/screens/provider_setup_screen.dart` — section “Where OpenClaw runs”, then “Model / API provider” |
| Settings | `lib/screens/settings_screen.dart` — “Runtime location” dropdown calling `session.setDeployment` |
| Mock behavior | `lib/services/mock_runtime_service.dart` — seeds diagnostics, `modeLabel` while running/degraded, chat hints, prefs save on change |

## Persisted values

- **Key:** `pc_runtime_deployment`
- **Values:** stable display strings — `This phone`, `Home network (LAN)`, `OpenClaw Cloud`, `Custom gateway` (see `RuntimeDeploymentModel` constants).
- Unknown or missing values resolve to **This phone** in `fromSelectionLabel`.

## Mock runtime behavior

`MockRuntimeService` still does not talk to a real gateway. It uses `deployment` to:

- Log session init and “target” lines in diagnostics.
- Set `RuntimeStateModel.modeLabel` to `runtimeModeSummary` when lifecycle is `running` or `degraded`.
- Include the chosen target in mock chat replies when the user asks about runtime/status.
- Persist label changes from Settings via `AppPrefs.saveRuntimeDeploymentLabel`.

## Follow-up (not in scope here)

- Real gateway discovery, LAN URLs, or cloud auth.
- Syncing `AppFlowController.selectedDeployment` when only `MockRuntimeService` changes (Settings already persists; a full app reset/re-hydrate would read prefs again).
