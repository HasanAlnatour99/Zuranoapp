---
name: firebase-flutter-expert
description: Implements Flutter app features that depend on Firebase Auth, Firestore, Riverpod, and app-specific salon rules. Use when working on authentication, Firestore models or repositories, role checks, salon creation, user provisioning, and Firebase-backed feature flows.
---

# Firebase Flutter Expert

## Purpose

Use this skill when the task involves Firebase-backed Flutter architecture, data flow, or business rules.

## Non-negotiable rules

- Use Firebase Auth for authentication.
- Store user and salon data in Firestore.
- Follow this Firestore structure (see `.cursor/rules/` schema files for fields):
  - `users/{uid}` (all roles including `customer`; no separate `customers` collection)
  - `salons/{salonId}`
  - `salons/{salonId}/employees/{employeeId}`
  - `salons/{salonId}/services/{serviceId}`
  - `salons/{salonId}/sales/{saleId}`
  - `salons/{salonId}/bookings/{bookingId}`
  - `salons/{salonId}/attendance/{attendanceId}`
  - `salons/{salonId}/payroll/{payrollId}`
  - `salons/{salonId}/expenses/{expenseId}`
  - `salons/{salonId}/violations/{violationId}` (if used)
- Use batch writes when creating a salon and its first employee.
- Do not duplicate data unnecessarily.

## Business rules

- The owner creates the salon first.
- Staff (`owner`, `admin`, `barber`) use salon-scoped data; `customer` may omit `salonId` until booking flows link them.
- Supported roles are `owner`, `admin`, `barber`, and `customer`.
- Never allow protected actions without a valid `salonId`.
- Validate role permissions before performing actions.

## Architecture rules

1. Keep features isolated under `lib/features/`.
2. Separate presentation, logic, and data cleanly.
3. Put Firebase access in repositories or services, not directly in widgets.
4. Use Riverpod providers for auth state, loading state, and current user.
5. Use `go_router` redirect logic based on auth state and `salonId`.

## Implementation guidance

- Prefer explicit models and repositories over ad hoc map handling in UI code.
- Validate inputs before writing to Firebase.
- Prepare implementations so they can later support payroll, attendance, commissions, and analytics.
- Keep code modular, readable, and testable.
- Avoid assumptions about missing Firestore fields or flows; inspect the existing code first.

## When handling Firebase flows

1. Confirm which collection and document path should be used.
2. Check whether the action requires a valid authenticated user.
3. Check whether the action requires `salonId` and role validation.
4. Use batch writes or transactions when consistency matters.
5. Return app-friendly errors that the presentation layer can display clearly.

## Example requests

- "Implement owner registration with Firebase Auth and Firestore."
- "Create the salon setup flow with a batch write."
- "Add a repository for employees under a salon."
- "Protect dashboard access based on auth state and salon membership."
