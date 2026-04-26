# Phase 7: Notifications and FCM deployment

## Firebase console

1. Enable **Cloud Messaging** for the Firebase project.
2. **iOS:** Upload an **APNs authentication key** (.p8) in Project settings → Cloud Messaging → Apple app configuration.
3. **Android:** Default FCM setup uses the existing `google-services.json`; no extra server key is required for client SDK v21+.

## iOS (`ios/`)

1. `GoogleService-Info.plist` is already linked via FlutterFire.
2. **Push capability:** In Xcode, open the Runner target → **Signing & Capabilities** → add **Push Notifications**.
3. **Background modes:** `Info.plist` includes `UIBackgroundModes` → `remote-notification`.
4. Rebuild after capability changes.

## Android (`android/`)

1. `google-services.json` is present under `android/app/`.
2. `AndroidManifest.xml` includes `POST_NOTIFICATIONS` for Android 13+.
3. Default notification icon uses `@mipmap/ic_launcher` for local notifications in foreground.

## Cloud Functions

1. Runtime: **Node 22** (`functions/package.json` `engines.node`).
2. Build and deploy:
   ```bash
   cd functions && npm run build
   firebase deploy --only functions
   ```
3. New exports: `registerDeviceToken`, `unregisterDeviceToken`, `updateNotificationPreferences`, `onBookingUpdatedNotification`, `onViolationCreatedNotification`, `onPayrollCreatedNotification`, `sendUpcomingBookingReminders`.

## Firestore

1. Deploy rules and indexes:
   ```bash
   firebase deploy --only firestore:rules,firestore:indexes
   ```
2. New or relevant indexes:
   - `bookings`: `status` ASC, `startAt` ASC (reminder queries per salon).
   - `users`: `salonId` ASC, `role` ASC (owner/admin resolution).

## Flutter app

1. Dependencies: `firebase_messaging`, `flutter_local_notifications`, `package_info_plus`, `uuid`.
2. After deploy, sign in on a device; the app registers the FCM token via `registerDeviceToken` and merges default `notificationPrefs` on the user document when missing.

## Verification checklist

- [ ] Create a **pending** booking → barber receives **new_booking_assigned** (push + in-app if prefs allow).
- [ ] Confirm booking (client status update) → customer receives **booking_confirmed**.
- [ ] Cancel / reschedule → **booking_cancelled** / **booking_rescheduled** to customer and barber.
- [ ] Mark **no-show** → owners/admins receive **no_show_recorded**.
- [ ] Create **violation** (e.g. late arrival flow) → barber + admins receive **violation_created**.
- [ ] Generate **payroll** → barber **payroll_ready**, admins **payroll_generated**.
- [ ] Wait for **sendUpcomingBookingReminders** (15 min) or run in emulator → **booking_reminder** once per user per booking (deduped).
- [ ] Open **Notifications** screen; mark as read; open **Notification settings** and toggle prefs.

## Tests

- Functions (no emulator): `npm --prefix functions test` (includes reminder copy unit tests).
- Rules (emulator): `npm --prefix functions run test:emulators` (includes `firestore.notifications.test.ts` when `FIRESTORE_EMULATOR_HOST` is set).
- Flutter: `flutter test test/features/notification_router_test.dart`.
