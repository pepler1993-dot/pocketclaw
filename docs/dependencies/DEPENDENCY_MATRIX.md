# Dependency Matrix

| Area | Current Assumption | Android Risk | Likely Mitigation | MVP Impact |
|---|---|---:|---|---|
| Node runtime | Standard Node environment available | High | Android-compatible runtime packaging or managed embedding | Core blocker |
| Process lifecycle | Long-lived services/processes are normal | High | Foreground-service model + restart/recovery design | Core blocker |
| Child process usage | Subprocess orchestration available | High | Minimize or wrap with Android-native management | Core blocker |
| Filesystem layout | Normal workspace/config hierarchy | Medium-High | App-private storage model + controlled import/export UX | Significant |
| Network binding | Local ports/gateway can bind normally | Medium | Validate loopback/local comms early | Significant |
| Tool exposure | Broad runtime/fs tools are acceptable | High | Mobile-safe tool profile with reduced defaults | Significant |
| Plugin stability | Long-running plugin/channel behavior stable | Medium-High | Stage integrations later after runtime foundation | Medium |
| Secrets storage | Config/env based secret handling acceptable | Medium-High | Secure storage / keystore-backed handling | Significant |
| Logging & diagnostics | File/CLI-driven debugging is acceptable | Medium | In-app diagnostics/log view | Significant |
| Background behavior | Runtime can remain alive predictably | High | Explicit runtime state model + user-visible status + recovery | Core blocker |

## Reading this matrix

### Core blocker
If unresolved, the Android-first PocketClaw concept may need to change materially.

### Significant
Can be solved, but must be designed intentionally before broad product work.

### Medium
Important, but should follow after the most fundamental runtime questions are answered.
