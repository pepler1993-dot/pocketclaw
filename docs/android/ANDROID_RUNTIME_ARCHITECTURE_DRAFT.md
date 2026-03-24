# Android Runtime Architecture Draft

## Purpose

This document describes the first realistically buildable Android runtime architecture for PocketClaw.

The goal is not theoretical perfection.
The goal is to define an architecture that respects Android reality while still preserving the PocketClaw product vision.

## Core design principle

PocketClaw should not try to pretend Android is a normal desktop or server host.

Instead, the architecture should separate:
- product/UI concerns
- Android lifecycle/service concerns
- OpenClaw runtime concerns
- config/secrets concerns
- communication concerns

That separation is what gives the project a chance to stay understandable and stable.

---

## High-level architecture

```text
PocketClaw Android App
│
├── Flutter UI Layer
│   ├── Onboarding
│   ├── Chat
│   ├── Runtime Control
│   ├── Settings
│   └── Diagnostics
│
├── Android Native Integration Layer
│   ├── Foreground service management
│   ├── Runtime process/service control
│   ├── App lifecycle hooks
│   ├── Battery/background handling
│   └── Secure storage bridge
│
├── PocketClaw Runtime Control Layer
│   ├── Start runtime
│   ├── Stop runtime
│   ├── Restart runtime
│   ├── Health checks
│   └── State reporting
│
├── OpenClaw Runtime Layer
│   ├── Config loading
│   ├── Session handling
│   ├── Provider usage
│   ├── Tool execution (mobile-safe subset)
│   └── Local gateway/communication endpoint
│
└── Storage Layer
    ├── App-private config
    ├── Workspace data
    ├── Logs
    └── Secure secret storage
```

---

## Layer-by-layer breakdown

## 1. Flutter UI Layer

### Responsibilities
- onboarding and setup
- provider/API key flows
- runtime controls
- chat interface
- diagnostics and logs
- user-facing settings

### Why Flutter here
Flutter is a good fit for:
- rapid UI iteration
- onboarding-heavy product work
- custom mobile UX
- future cross-platform flexibility

### Rule
Flutter should own product experience, not low-level runtime tricks.

---

## 2. Android Native Integration Layer

### Responsibilities
- bridge Flutter to Android runtime/service behavior
- manage foreground service behavior if required
- integrate with Android lifecycle events
- handle secure storage access
- manage device-specific runtime constraints

### Why this layer exists
Because Android runtime behavior should not be faked inside Flutter abstractions.

If runtime control becomes platform-specific, it should live in a place that actually understands Android.

### Expected implementation style
- Flutter method channels or platform integration bridge
- native Android service/controller components
- clear boundary between UI requests and runtime operations

---

## 3. PocketClaw Runtime Control Layer

### Responsibilities
This is the product-specific control logic between UI and OpenClaw.

It should expose concepts like:
- start
- stop
- restart
- status
- health
- last error
- reconnect

### Why this layer matters
This prevents the UI from directly depending on low-level runtime mechanics.

Without this layer, the product will become brittle and ugly fast.

### Desired behavior
This layer should translate low-level runtime truth into product-safe state.

Example:
- not “socket bind failed on port X”
- but “PocketClaw could not start the local assistant service” + expandable details

---

## 4. OpenClaw Runtime Layer

### Responsibilities
- actual assistant runtime behavior
- config usage
- session execution
- provider/model access
- tool execution within mobile-safe limits
- local transport endpoint

### Important constraint
This layer should be treated as something PocketClaw hosts and controls — not something the user manages manually.

### Product implication
Raw OpenClaw behavior may need adaptation or reduced scope in mobile MVP.

---

## 5. Storage Layer

### Split storage model

#### App-private config storage
For generated config, local app state, runtime preferences.

#### Workspace storage
For conversation state, logs, temporary runtime artifacts, memory/workspace data where applicable.

#### Secure secret storage
For API keys and sensitive credentials.

### Principles
- no raw config editing required for normal users
- secrets never stored casually in plain UX-facing fields
- reset and recovery paths must be explicit

---

## Communication model

## Recommended first approach
Use a **local loopback communication path** between the app shell and the managed runtime, if Android behavior proves stable enough.

Candidate options:
- local HTTP
- local WebSocket
- hybrid local control endpoint

## Why this is attractive
- keeps runtime somewhat decoupled from UI
- easier to inspect and test than deep internal coupling
- fits start/stop/status/chat concepts naturally

## Caveat
This must be validated under Android lifecycle pressure, not just assumed.

---

## Runtime lifecycle model

## Recommended product model
PocketClaw should expose runtime state explicitly.

Suggested states:
- Not configured
- Ready to start
- Starting
- Running
- Degraded
- Stopped
- Failed

## Why this matters
Users need to understand what the app is doing.
Mobile runtime products feel broken very quickly if state is hidden.

## Recommendation
Treat restart/recovery as a standard feature, not a rare error path.

---

## Background model

## Honest assumption
PocketClaw should not promise magical invisible always-on behavior too early.

## Realistic early model
- reliable while app is active
- controllable via foreground-managed runtime behavior if needed
- user-visible runtime state
- clear explanation when Android background limits affect behavior

## Product truth
If PocketClaw later supports stronger persistence, that should be earned through testing, not promised from day one.

---

## Mobile-safe tool model

## Recommendation
PocketClaw MVP should use a restricted default tool surface.

### Good first candidates
- session/chat operations
- provider management
- runtime status/health
- logs/diagnostics

### Likely deferred or heavily gated
- unrestricted shell/runtime exec patterns
- broad filesystem access
- desktop/server-style automations
- tools that assume a much more open host environment

---

## Security model

### Defaults should be conservative
- local-only by default where possible
- secure storage for secrets
- minimal exposed network behavior initially
- advanced controls hidden behind explicit user choice

### UX implication
Security should not just exist under the hood.
The app should explain key trust boundaries clearly.

---

## MVP architecture recommendation

For MVP, PocketClaw should be built as:

- **Flutter app shell**
- **Android-native runtime/service bridge**
- **controlled local runtime lifecycle**
- **secure provider storage**
- **simple chat + runtime control + diagnostics**

This is the most realistic architecture that still supports the actual product vision.

---

## Architectural anti-patterns to avoid

### 1. Pretending Flutter alone can solve runtime management
It probably cannot.

### 2. Exposing raw OpenClaw complexity directly to users
That defeats the whole product.

### 3. Promising daemon-like background behavior before testing Android limits
Bad idea.

### 4. Shipping broad tool access too early
That is how you get a confusing and fragile MVP.

---

## Recommended next technical artifact
After this draft, the next useful document is:

**[`ANDROID_SERVICE_MODEL.md`](ANDROID_SERVICE_MODEL.md)** (same folder)

That should answer:
- what exact Android service/process model PocketClaw should use
- what runs where
- how runtime control is triggered
- how lifecycle transitions are handled

That is likely the next real technical decision point.