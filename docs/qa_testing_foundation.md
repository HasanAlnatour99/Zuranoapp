# QA Testing Foundation (Flutter + Firebase)

This MVP QA baseline adds focused, maintainable automated coverage without changing production architecture.

## Test file tree

- `test/unit/booking_logic_test.dart`
- `test/unit/customer_repository_logic_test.dart`
- `test/unit/attendance_validation_test.dart`
- `test/unit/payroll_commission_logic_test.dart`
- `test/unit/booking_failure_logging_test.dart`
- `test/widget/owner_shell_navigation_test.dart`
- `test/widget/customers_screen_test.dart`
- `test/widget/customer_forms_and_details_test.dart`
- `test/widget/golden_customers_and_details_test.dart`
- `test/widget/localization_en_ar_test.dart`
- `integration_test/owner_customer_flow_test.dart`
- `dart_test.yaml`
- `firebase_rules_tests/package.json`
- `firebase_rules_tests/rules.test.mjs`

## Coverage map

### Unit tests
- Booking overlap logic
  - `BookingRepository.checkBarberAvailability` overlap rejection.
- Booking status transition rules
  - `BookingStatusMachine.canTransition` valid/invalid transitions.
- Soft delete customer behavior
  - `CustomerRepository.deleteCustomer` keeps document, sets `isActive=false`.
- Customer search normalization
  - `normalizeCustomerName` and `normalizeCustomerPhone`.
- Attendance validation logic
  - `AttendanceRecord.fromJson` date key normalization and approval defaults.
- Payroll / commission logic
  - `PayrollService.commissionAmountFromSales` and `PayrollService.netFromParts`.
- Booking transaction hardening
  - Creation updates linked customer timestamp.
  - Completion path is idempotent for customer counters.
- Parallel creation contention (emulator-targeted)
  - Added as a critical scenario and explicitly marked to run against emulator transaction behavior.
- Regression safety
  - `customer.totalSpent` equals sum of completed bookings.
- Timezone safety
  - Booking UTC storage is validated against local-to-UTC conversion.
- Logging safety
  - Booking failure path logs via `guardResult` + `AppLogger.error`.
- Arabic search safety
  - Arabic customer names resolve in `searchCustomers`.

### Widget tests
- Owner shell bottom navigation
  - Adaptive shell tab labels + tab switch callback behavior.
- Customers tab rendering
  - Customers title + populated customer card rendering.
- FAB visibility based on permission
  - Visible for owner, hidden for barber.
- Add Customer form validation
  - Required full name message.
- Create Booking form validation
  - Required customer/service/barber/date/time guard.
- Customer Details header actions
  - Owner sees booking action CTA.
- Loading / empty / populated states
  - Empty state explicitly covered in `CustomersScreen`.
- Loading / error / slow network simulations
  - Loading spinner/state handling.
  - Error rendering.
  - Slow future completion path.
- Golden snapshots
  - Customers screen and Customer Details screen golden tests are present and tagged.
- Localization
  - English and Arabic login copy checks.

### Integration tests (critical flow foundation)
- Owner login and routing redirect behavior
  - `resolveRedirect` for signed-out and owner-ready paths.
- Open Customers tab + add customer
  - FAB navigation flow in router harness.
- Create booking from customer details
  - Customer Details CTA to booking route.
- Block overlapping booking
  - Availability conflict check in flow-level test.
- Barber/admin permission behavior
  - Barber cannot see add-customer CTA.
- Onboarding redirects
  - Covered through redirect guard test assertions.

### Firestore security rules tests (Emulator Suite)
- Owner access to own salon.
- Admin read with limited permissions.
- Barber restricted access.
- Cross-salon denial.
- Booking/customer rule enforcement.
- Invalid booking writes fail.
- Admin without required permission is denied.
- Cross-salon write attempts are denied.
- Emulator concurrency transaction check ensures two parallel overlapping writes do not both succeed.

## Mocks / fakes added

- Dart:
  - `fake_cloud_firestore` for repository/unit overlap tests.
  - `mocktail` for controller mocking in form widget tests.
  - Mocktail fallback fake types for `CreateCustomerInput` and `CreateBookingInput`.
- Rules tests:
  - `@firebase/rules-unit-testing` with Firestore emulator contexts.

## Local commands

- Unit + widget:
  - `flutter test test/unit test/widget`
- Integration foundation file:
  - `flutter test integration_test/owner_customer_flow_test.dart`
  - If your environment treats this as device-driven integration, run it with your preferred integration target/device setup.
  - iOS device: `flutter test integration_test/owner_customer_flow_test.dart -d "<ios-device-id>"`
  - Android device: `flutter test integration_test/owner_customer_flow_test.dart -d android`
- Firestore rules:
  - `cd firebase_rules_tests`
  - `npm install`
  - `npm test`
  - Requires Java 21+ for Firebase Emulator runtime.

## Remaining manual QA gaps (MVP)

- Full device-level integration execution for `integration_test/` across Android + iOS.
- End-to-end Firebase Auth + Firestore happy path with real backend and network failures.
- Visual QA for owner quick action bottom sheet animations/micro-interactions.
- Cross-role UX regression checks on deep links and push-notification entry points.
- Real Firestore index + latency behavior under production-like data volumes.

## Test tags

- `critical`
- `localization`
- `golden`
