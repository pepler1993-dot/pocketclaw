# PocketClaw UI Preview

This is a quick visual preview of how the current PocketClaw app shell is meant to feel.

It is not a pixel-perfect design file.
It is a structured preview so the team can align on product feel early.

---

## Overall visual direction

- dark-first
- black / charcoal surfaces
- red accent color
- sharp, controlled UI
- "OpenClaw-family" feel
- modern operational tool, not playful consumer fluff

Think:
- clean
- focused
- slightly aggressive
- high signal, low noise

---

# 1. Onboarding Screen

## Visual feel
A dark welcome screen with a strong headline and a simple first action.

```text
┌──────────────────────────────────────┐
│  [ Claw mark ]                       │
│                                      │
│                                      │
│  OpenClaw                            │
│  in your pocket.                     │
│                                      │
│  A focused mobile shell for runtime  │
│  controls, diagnostics, and agent    │
│  chat.                               │
│                                      │
│  ┌────────────────────────────────┐  │
│  │ ■ Dark, low-noise operational  │  │
│  │   UI                           │  │
│  │ ■ Fast access to runtime       │  │
│  │   health                       │  │
│  │ ■ Assistant-first diagnostics  │  │
│  │   workflow                     │  │
│  └────────────────────────────────┘  │
│                                      │
│      [ Set up provider ]             │
└──────────────────────────────────────┘
```

## What works well
- immediate identity
- not generic Flutter-demo energy
- strong product framing

---

# 2. Provider Setup Screen

## Visual feel
Simple and focused. No giant form madness yet.

```text
┌──────────────────────────────────────┐
│  ← Provider setup                    │
│                                      │
│  [ Claw mark ]                       │
│                                      │
│  Choose your primary provider        │
│                                      │
│  You can change this later in        │
│  settings. Keep it simple for now.   │
│                                      │
│  ┌────────────────────────────────┐  │
│  │ (•) Local Runtime              │  │
│  │     Best for low-latency local │  │
│  │     development                │  │
│  │                                │  │
│  │ ( ) OpenClaw Cloud             │  │
│  │     Managed runtime and sync   │  │
│  │                                │  │
│  │ ( ) Custom Endpoint            │  │
│  │     Use your own runtime path  │  │
│  └────────────────────────────────┘  │
│                                      │
│        [ Enter PocketClaw ]          │
└──────────────────────────────────────┘
```

## What works well
- low friction
- understandable first setup step
- feels productized, not config-driven

---

# 3. Main Shell Navigation

## Bottom navigation

```text
[ Chat ]   [ Runtime ]   [ Diagnostics ]   [ Settings ]
```

This is a good MVP nav.
No nonsense.
No fake feature sprawl.

---

# 4. Chat Screen

## Visual feel
Looks like a dark operational assistant chat, not a consumer messenger clone.

```text
┌──────────────────────────────────────┐
│  Chat                       [bolt]   │
│  Talk to PocketClaw about runtime    │
│  and diagnostics.                    │
│                                      │
│  ┌────────────────────────────────┐  │
│  │ Welcome                        │  │
│  │ Start with a quick command     │  │
│  │ like “show runtime health”.    │  │
│  └────────────────────────────────┘  │
│                                      │
│  PocketClaw                         │
│  Welcome back. Runtime is healthy   │
│  and ready for your next command.   │
│                               09:14 │
│                                      │
│                            You       │
│  Run a quick status check and       │
│  summarize anything unusual.        │
│                               09:15 │
│                                      │
│  PocketClaw                         │
│  No blockers detected. Queue depth  │
│  is normal and latency is stable.   │
│                               09:15 │
│                                      │
│ [+] [ Message PocketClaw      ] [>] │
└──────────────────────────────────────┘
```

## What works well
- already usable as a product shell
- feels like a real assistant surface
- easy place to evolve into voice later

---

# 5. Runtime Screen

## Visual feel
More like an operations control surface.

```text
┌──────────────────────────────────────┐
│  Runtime                [play icon]  │
│  Control background activity and     │
│  inspect live state.                 │
│                                      │
│  ┌────────────────────────────────┐  │
│  │ Runtime status       ● Healthy │  │
│  │ Last heartbeat 14s ago         │  │
│  │                                │  │
│  │ Mode: Active                   │  │
│  │ Workers: 2 online              │  │
│  │ Queue depth: 3 pending tasks   │  │
│  └────────────────────────────────┘  │
│                                      │
│  [ Restart ] [ Health Check ]        │
│  [ Pause Queue ]                     │
│                                      │
│  ┌────────────────────────────────┐  │
│  │ Health checks                  │  │
│  │ ✓ API connectivity             │  │
│  │ ✓ Storage access               │  │
│  │ ! Event stream delayed         │  │
│  └────────────────────────────────┘  │
└──────────────────────────────────────┘
```

## What works well
- matches the product direction
- users can understand state quickly
- strong base for later runtime integration

---

# 6. Diagnostics Screen

## Visual feel
Dense but not chaotic.

```text
┌──────────────────────────────────────┐
│  Diagnostics                         │
│  Inspect health, events, and logs.   │
│                                      │
│  ┌────────────────────────────────┐  │
│  │ Health summary                 │  │
│  │ Runtime: Healthy               │  │
│  │ Queue: Stable                  │  │
│  │ Last failure: 2h ago           │  │
│  └────────────────────────────────┘  │
│                                      │
│  ┌────────────────────────────────┐  │
│  │ Recent events                  │  │
│  │ INFO  Runtime started          │  │
│  │ WARN  Event stream delayed     │  │
│  │ INFO  Health check passed      │  │
│  └────────────────────────────────┘  │
│                                      │
│  ┌────────────────────────────────┐  │
│  │ Log preview                    │  │
│  │ [10:41] runtime heartbeat ok   │  │
│  │ [10:42] queue latency stable   │  │
│  │ [10:43] reconnect completed    │  │
│  └────────────────────────────────┘  │
└──────────────────────────────────────┘
```

## What works well
- feels useful
- not just a dump screen
- good direction for troubleshooting UX

---

# 7. Settings Screen

## Visual feel
Structured, not cluttered.

```text
┌──────────────────────────────────────┐
│  Settings                            │
│  Configure runtime, data, and        │
│  provider behavior.                  │
│                                      │
│  ┌────────────────────────────────┐  │
│  │ Account / Provider             │  │
│  │ Current provider: Local Runtime│  │
│  └────────────────────────────────┘  │
│                                      │
│  ┌────────────────────────────────┐  │
│  │ Runtime preferences            │  │
│  │ Local-only mode                │  │
│  │ Auto-restart                   │  │
│  └────────────────────────────────┘  │
│                                      │
│  ┌────────────────────────────────┐  │
│  │ Data and privacy               │  │
│  │ Reset workspace                │  │
│  │ Clear logs                     │  │
│  │ Storage details                │  │
│  └────────────────────────────────┘  │
└──────────────────────────────────────┘
```

## What works well
- good skeleton for later real settings
- doesn’t overwhelm normal users

---

# Overall assessment

## What already feels right
- visual identity is no longer generic
- app has a serious dark operational feel
- onboarding-to-main-shell flow exists
- runtime and diagnostics already fit the product idea well

## What still needs work
- stronger branding details
- more refined spacing and typography rhythm
- real provider setup fields
- actual runtime state model
- tighter chat polish
- proper settings hierarchy

## Short verdict
Current state:
**early product shell with direction**

Not production-ready.
Not polished.
But definitely no longer just a mock skeleton.
