---
name: riverpod-state-management
description: Structures Flutter state management with Riverpod using clear feature boundaries, provider-driven business logic, and testable async flows. Use when creating providers, wiring auth or user state, managing loading or error states, refactoring widget state, or organizing app logic around Riverpod.
---

# Riverpod State Management

## Purpose

Use this skill when the task is primarily about Riverpod architecture, provider design, or moving state and business logic out of widgets.

## Core rules

- Use Riverpod only for app state management.
- Do not use `setState` for business logic.
- Keep features isolated under `lib/features/`.
- Separate presentation, logic, and data clearly.
- Widgets should consume providers, not implement business rules directly.

## Required provider coverage

Make sure the app exposes providers for:

- auth state
- loading state
- current user

Add other providers only when a feature has a clear responsibility and lifecycle.

## Provider design guidelines

1. Put provider logic close to the relevant feature instead of creating a global dumping ground.
2. Keep providers focused on one responsibility.
3. Let repositories and services handle data access; providers should coordinate app logic and state transitions.
4. Model loading, success, and failure states explicitly.
5. Prefer readable state flows over clever abstractions.
6. Avoid providers that leak Firebase or UI concerns across layers.

## UI integration rules

- Widgets should `watch` the minimum state they need.
- Keep expensive logic out of `build()`.
- Derive UI state from providers instead of storing duplicate local state.
- Use provider-driven validation, submission, and side-effect coordination when the flow affects business logic.
- Keep loading, empty, and error states visible in the UI when relevant.

## App-specific expectations

- Respect auth and `salonId` requirements across protected flows.
- Use provider state to support routing and redirect decisions with `go_router`.
- Validate role-based actions before allowing feature operations.
- Keep implementations ready for future features like payroll, attendance, commissions, and analytics.

## Refactoring checklist

When moving code to Riverpod:

1. Identify widget state that is actually business state.
2. Move async logic, validation, and side effects into providers or supporting services.
3. Keep presentation widgets focused on rendering and user interaction.
4. Remove duplicated state between widgets and providers.
5. Verify the resulting flow is testable and easy to reason about.

## Example requests

- "Create Riverpod providers for auth state and current user."
- "Refactor this Flutter screen to remove business logic from the widget."
- "Model loading and error states for salon creation with Riverpod."
- "Add provider-driven redirect logic for authenticated users without a salon."
