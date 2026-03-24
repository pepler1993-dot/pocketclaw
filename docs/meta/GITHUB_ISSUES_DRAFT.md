# GitHub Issues Draft

These are the first recommended issues for the PocketClaw project.

---

## 1. Define Android-first feasibility constraints
**Type:** research

### Goal
Document what is technically realistic for running OpenClaw on Android.

### Deliverables
- runtime assumptions
- background execution constraints
- storage model assumptions
- security considerations
- unknowns and blockers

---

## 2. Evaluate iPhone feasibility honestly
**Type:** research

### Goal
Document what is and is not realistic on iPhone.

### Deliverables
- sandbox limitations
- background execution constraints
- likely reduced-scope options
- recommendation for MVP scope

---

## 3. Choose mobile app stack
**Type:** architecture

### Goal
Decide whether the project should use Flutter, React Native, or native apps.

### Deliverables
- tradeoff summary
- recommendation
- reasoning tied to runtime/control requirements

---

## 4. Define local runtime packaging strategy
**Type:** architecture

### Goal
Figure out how PocketClaw should bundle or manage a local runtime on Android.

### Deliverables
- candidate approaches
- risks
- recommended path for PoC

---

## 5. Design onboarding flow for non-technical users
**Type:** product

### Goal
Define a first-time setup flow that avoids config-file editing.

### Deliverables
- step list
- screen flow
- key decisions/questions shown to user
- safe default settings

---

## 6. Draft basic Android MVP screens
**Type:** design

### Goal
Define the minimum screens needed for an Android-first MVP.

### Deliverables
- onboarding
- chat
- runtime status
- settings
- logs/diagnostics

---

## 7. Define provider configuration UX
**Type:** product

### Goal
Figure out how users add and manage model providers cleanly.

### Deliverables
- provider list
- API key flow
- validation flow
- error handling UX

---

## 8. Build first runtime controller prototype
**Type:** engineering

### Goal
Prototype starting/stopping the PocketClaw runtime from an Android shell app.

### Deliverables
- start button
- stop button
- status indicator
- persistence across restarts if feasible

---

## 9. Build first local chat prototype
**Type:** engineering

### Goal
Allow sending and receiving assistant messages inside the Android app.

### Deliverables
- chat screen
- message send
- response receive
- failure states

---

## 10. Write PocketClaw product FAQ
**Type:** docs

### Goal
Answer the obvious questions early.

### Deliverables
- what PocketClaw is
- Android vs iPhone reality
- local vs cloud model use
- privacy expectations
- early limitations
