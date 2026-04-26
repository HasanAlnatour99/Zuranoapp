# Firestore Customer Separation Migration Notes

## Overview

This change performs a hard cutover for customer business data:

- `users/{uid}` is treated as auth/session identity only.
- Customer business records now live at `customers/{customerId}`.
- Legacy salon-scoped customer records under `salons/{salonId}/customers/{customerId}` are no longer used by app repositories.

## Collection contract changes

### `users/{uid}`

- Supported identity roles are now `owner` and `employee`.
- Customer business profile fields should not be written to `users`.
- Session routing reads `users/{uid}` only.

### `customers/{customerId}`

Customer records are now represented as business entities with this contract:

- `id`
- `authUid` (nullable)
- `fullName`
- `phone`
- `email` (optional)
- `notes` (optional)
- `preferredBarberId` (optional)
- `preferredBarberName` (optional)
- `visitCount`
- `totalSpent`
- `lastVisitAt`
- `isActive`
- `searchKeywords`
- `createdAt`
- `updatedAt`
- `createdBy`

## Path migration

- Old: `salons/{salonId}/customers/{customerId}`
- New: `customers/{customerId}`

Booking customer aggregate updates are now written to `customers/{customerId}`.

## Breaking assumptions to audit

1. Any query that depended on salon subcollection customers must be updated.
2. Any auth flow expecting `users.role == customer` must be migrated to `employee` or non-user customer records.
3. Any Firestore rule allowing `users` role `customer` should be removed in future cleanup once legacy clients are fully retired.

## One-time backfill guidance

For existing environments, run a one-time migration script outside the app:

1. Read every `salons/{salonId}/customers/{customerId}` document.
2. Write each record to `customers/{customerId}` with equivalent fields.
3. Ensure `createdBy`, `createdAt`, `updatedAt`, and `searchKeywords` are preserved or regenerated.
4. Keep `authUid` nullable unless there is a verified login mapping.
5. After validation, stop writes to old paths and eventually archive old customer docs.
