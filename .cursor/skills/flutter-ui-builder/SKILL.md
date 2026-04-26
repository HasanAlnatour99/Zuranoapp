---
name: flutter-ui-builder
description: Builds clean, reusable Flutter UI for this app using feature-based architecture, shared widgets, Riverpod-friendly boundaries, and consistent design tokens. Use when creating or refining Flutter screens, forms, widgets, layouts, navigation flows, or presentation-layer code.
---

# Flutter UI Builder

## Purpose

Use this skill when the task is primarily about Flutter UI implementation or presentation-layer structure.

## Default approach

1. Keep each UI change inside the correct feature under `lib/features/`.
2. Separate presentation from logic and data; widgets should not contain business rules.
3. Reuse shared widgets such as `AppTextField` and `AppButton` before creating new ones.
4. Avoid hardcoded colors, spacing, sizing, and styling values; prefer existing theme or constants patterns already used in the project.
5. Use Riverpod-driven state, not `setState`, for business logic.
6. Keep widgets small, readable, and composable.
7. Use `const` where possible to reduce rebuild cost.

## UI rules

- Build clean, simple screens suitable for a production barber shop app.
- Follow existing project structure and naming; do not invent new patterns unless the codebase clearly needs one.
- Prefer reusable sections and widgets over large one-off screens.
- Keep validation and submission flows out of the widget tree when they represent business logic.
- Add comments only when a block would otherwise be hard to understand.

## Routing and screen flow

- Use `go_router` only.
- Respect the app route structure:
  - `/`
  - `/login`
  - `/register`
  - `/create-salon`
  - `/dashboard`
- If a screen depends on auth state or `salonId`, make sure the UI fits the redirect logic already used by the app.

## Output expectations

When implementing UI:

- Prefer production-ready code over placeholder scaffolding.
- Match existing styling and spacing patterns.
- Make every form testable and easy to wire to providers.
- Keep loading, empty, and error states explicit when relevant.

## Example requests

- "Build the owner dashboard UI using existing shared widgets."
- "Create a reusable employee form screen for Flutter."
- "Refactor this screen to follow the app's feature architecture."
- "Add a clean registration form without hardcoded styling values."
