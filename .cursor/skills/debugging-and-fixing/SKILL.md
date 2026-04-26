---
name: debugging-and-fixing
description: Debugs and fixes Flutter app issues by reproducing the problem, isolating the failing layer, identifying the root cause, and verifying the repair. Use when investigating errors, broken UI flows, Riverpod state bugs, Firebase issues, routing problems, failing builds, or unexpected app behavior.
---

# Debugging And Fixing

## Purpose

Use this skill when the task is to diagnose a bug, explain the cause, and implement a safe fix.

## Default workflow

1. Reproduce the problem or gather the exact failure signal.
2. Identify which layer is responsible:
   - presentation
   - provider or service logic
   - repository or model
   - Firebase Auth or Firestore
   - routing or redirect logic
3. Trace the data flow and find the root cause.
4. Fix the cause, not just the symptom.
5. Verify the result with the smallest reliable check available.

## Debugging rules

- Do not guess when evidence can be gathered.
- Do not patch around unclear behavior with random null checks or hardcoded values.
- Prefer existing project structure and patterns over new abstractions.
- Keep fixes scoped to the bug unless a small adjacent cleanup clearly reduces risk.
- Preserve clean separation between presentation, logic, and data.

## App-specific checks

When debugging this app, always consider:

- whether the user is authenticated with Firebase Auth
- whether a required `salonId` is missing
- whether the current role is allowed to perform the action
- whether Firestore paths match the required structure:
  - `users/{uid}`
  - `salons/{salonId}`
  - `salons/{salonId}/employees/{employeeId}`
- whether a provider is holding stale, duplicated, or misplaced state
- whether `go_router` redirects are blocking the expected flow

## Fixing guidelines

- Keep business logic out of widgets.
- Use Riverpod for state-related fixes instead of `setState`.
- Put Firebase access in repositories or services, not presentation code.
- Validate inputs before writes or protected actions.
- Use batch writes when fixing salon creation or first-employee setup flows.
- Add or update a focused test only when it materially reduces regression risk.

## Verification checklist

After making a fix:

1. Confirm the original bug path now works.
2. Check nearby edge cases that share the same logic.
3. Run lints on edited files.
4. Run the most relevant test or targeted verification step available.
5. Make sure the fix did not break auth, salon membership, or role-based flows.

## Output expectations

When using this skill, the final result should clearly cover:

- the observed problem
- the root cause
- the fix that was applied
- how the fix was verified

## Example requests

- "Debug why registration succeeds but the user never reaches the dashboard."
- "Fix this Riverpod loading state bug."
- "Investigate why salon creation fails in Firestore."
- "Find the cause of this `go_router` redirect loop."
