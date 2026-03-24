# Screen Flow

## Goal
Describe the first practical user flow for PocketClaw.

The purpose of this document is not visual polish.
It is to define how a normal user moves through the app without needing technical knowledge.

## Product assumption
PocketClaw should feel like a usable assistant app, not a mobile admin panel.

---

## Primary MVP flow

### 1. Launch screen
User opens PocketClaw.

Possible states:
- first launch
- returning user
- runtime unavailable
- setup incomplete

### 2. Welcome / onboarding
First-time user sees:
- what PocketClaw is
- what “local runtime” means in plain language
- what they need to set up first

Primary actions:
- Get started
- Learn more

---

## Onboarding path

### Step 1 — Choose provider
User selects a model/provider setup.

Examples:
- OpenRouter
- OpenAI
- Anthropic
- local provider later

Goal:
Avoid raw config thinking.

### Step 2 — Add key / connect provider
User enters API key in a guided flow.

Requirements:
- clear validation state
- understandable failure messages
- secure storage explanation

### Step 3 — Runtime mode explanation
Explain in normal language:
- local-only mode
- what happens on-device
- what may need background permissions later

### Step 4 — Finish setup
PocketClaw stores config and prepares runtime.

User sees:
- success state
- “Start assistant” button

---

## Runtime control flow

### Runtime screen
This is the operational home for system state.

Sections:
- current status
- start/stop/restart controls
- last error
- quick health check

Possible states:
- stopped
- starting
- running
- degraded
- failed

Goal:
User should always understand whether PocketClaw is alive or not.

---

## Chat flow

### Chat screen
Once runtime is available, user enters the chat view.

Elements:
- message list
- input field
- send button
- loading state
- error/retry state

Future addition:
- voice button

Goal:
The assistant experience should feel simple and immediate.

---

## Settings flow

### Settings screen
Simple by default.

Sections:
- provider settings
- runtime preferences
- local storage/reset options
- advanced settings (collapsed)

Goal:
Basic users are not overwhelmed.
Power users can still go deeper.

---

## Logs / diagnostics flow

### Diagnostics screen
This is not for raw developer dumping.
It is for understandable troubleshooting.

Sections:
- runtime status
- recent errors
- connection/provider check
- detailed logs expandable

Goal:
A user can tell whether the problem is:
- provider setup
- runtime startup
- connectivity
- permissions

---

## Recovery flow

If PocketClaw fails:
1. user sees clear state
2. user gets a plain-language message
3. user gets obvious actions
   - retry
   - restart runtime
   - review provider setup
   - open diagnostics

This matters a lot.
A local runtime product without good recovery UX will feel broken even when it is technically recoverable.

---

## Returning user flow

Returning user should ideally land in one of two places:
- **Chat**, if runtime is healthy
- **Runtime status**, if runtime is not healthy

That keeps the product feeling practical instead of confusing.

---

## Suggested MVP navigation
- Chat
- Runtime
- Settings
- Diagnostics

Optional later:
- Voice
- Connections
- Automations
- Tools

---

## UX principle behind the flow
The user should never need to ask:
- “Where do I start?”
- “Is it running?”
- “Why does nothing happen?”
- “Where do I fix this?”

If those questions still happen often, the flow is not good enough yet.