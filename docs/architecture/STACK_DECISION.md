# Stack Decision Draft

## Recommendation
Use **Flutter** for the first PocketClaw mobile application.

## Why Flutter

### 1. Best fit for fast product iteration
PocketClaw is still shaping the product surface. Flutter is strong when product, UX, and iteration speed matter more than deep platform specialization on day one.

### 2. Good mobile UI velocity
We need onboarding, settings, chat, diagnostics, and runtime controls quickly. Flutter is well suited for building these kinds of interfaces fast and consistently.

### 3. Cross-platform path without pretending parity exists
Even though Android is the real first target, Flutter keeps a future path open for iPhone without forcing us to commit to two separate native codebases too early.

### 4. Good fit for custom UI
PocketClaw will likely need a tailored interface rather than generic forms. Flutter is strong at creating a polished mobile UI.

## Why not React Native first
React Native is viable, but for this project it is a bit less attractive because:
- native/runtime integration work may still force platform-specific bridges
- product polish often takes more UI wrangling
- we do not gain enough to justify the tradeoff yet

## Why not fully native first
Native Android could make sense later if runtime integration becomes deeply platform-specific.
But right now it would slow down experimentation too early.

## Suggested stack
- **App framework:** Flutter
- **State management:** Riverpod
- **Local storage:** Hive or Drift
- **Secure secrets:** flutter_secure_storage
- **HTTP / runtime comms:** dio or native platform channel bridge as needed
- **Logging UI:** in-app structured log viewer

## Important caveat
The runtime layer may still require platform-specific native code on Android.
That does not invalidate Flutter. It just means:
- Flutter for product shell + UX
- native Android layer for runtime/process integration where necessary

## Decision framing
This is really a split decision:
- **Product/UI layer:** Flutter
- **Runtime/platform layer:** Android-native where required

## Conclusion
Use Flutter for the app shell and UX.
Use native Android integrations only where runtime management forces it.

That is the best balance of speed, flexibility, and realism.