# PocketClaw Architecture Draft

## High-level layers

### 1. UI Layer
Mobile application interface for setup, chat, controls, and status.

Responsibilities:
- onboarding
- settings
- chat interface
- logs and diagnostics
- permissions flow
- provider configuration

### 2. Runtime Layer
Responsible for starting, stopping, monitoring, and configuring the local OpenClaw runtime.

Responsibilities:
- runtime lifecycle
- config generation
- local storage paths
- state management
- crash recovery

### 3. Assistant Layer
Handles interaction with the assistant session.

Responsibilities:
- session management
- message routing
- context display
- response streaming

### 4. Provider Layer
Abstraction around model providers and credentials.

Responsibilities:
- OpenRouter / OpenAI / Anthropic / local providers
- API key validation
- provider health checks
- model selection UI

### 5. Tool Layer
Maps OpenClaw tool capabilities to what is safe and practical on mobile.

Responsibilities:
- permission-aware tool exposure
- mobile-safe tool wrappers
- platform-specific capability checks

### 6. Voice Layer
Handles microphone input and spoken output.

Responsibilities:
- speech-to-text
- text-to-speech
- voice session controls
- audio permissions

## Suggested app sections
- Chat
- Voice
- Automations
- Connections
- Models
- Tools
- Settings
- Status / Logs

## Android-first implementation thought
The cleanest early path is likely:
- mobile app shell
- embedded/managed runtime process
- local config + workspace storage
- direct UI controls over runtime state

## iPhone caution
For iOS, architecture may need a constrained mode rather than a full parity runtime.
This should be treated as a product strategy decision, not assumed away.