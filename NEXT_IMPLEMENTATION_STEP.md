# Next Implementation Step

## Recommended next move
Do not jump into building the full app shell yet.

Start with a **runtime feasibility spike** focused on Android.

## Immediate objective
Answer this:

**Can PocketClaw reliably control and communicate with a local OpenClaw runtime on Android?**

## What to do first

1. Audit OpenClaw runtime assumptions
2. Decide how runtime control would work on Android
3. Test local communication between app shell and runtime/service
4. Test persistence and restart behavior
5. Capture blockers early

## Why this first
Because if runtime control is ugly or unstable, the rest of the product is cosmetic.

## Suggested output from next round of work
- a runtime feasibility report
- a recommended Android runtime architecture
- a first technical decision on service/process model
- a list of blockers that affect MVP scope

## Product reminder
PocketClaw wins if it feels simple.
But simplicity here depends on solving hard runtime problems underneath.