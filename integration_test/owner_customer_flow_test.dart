import 'package:barber_shop_app/core/constants/app_routes.dart';
import 'package:barber_shop_app/core/session/app_session_status.dart';
import 'package:barber_shop_app/features/bookings/data/booking_repository.dart';
import 'package:barber_shop_app/features/customers/data/models/customer.dart';
import 'package:barber_shop_app/features/customers/logic/create_booking_controller.dart';
import 'package:barber_shop_app/features/bookings/data/models/booking.dart';
import 'package:barber_shop_app/features/customers/logic/customer_providers.dart';
import 'package:barber_shop_app/features/customers/presentation/providers/customer_details_providers.dart';
import 'package:barber_shop_app/features/customers/presentation/screens/create_booking_screen.dart';
import 'package:barber_shop_app/features/customers/presentation/screens/customer_details_screen.dart';
import 'package:barber_shop_app/features/customers/presentation/screens/customers_screen.dart';
import 'package:barber_shop_app/features/employees/data/models/employee.dart';
import 'package:barber_shop_app/features/sales/data/models/sale.dart';
import 'package:barber_shop_app/features/salon/data/models/salon.dart';
import 'package:barber_shop_app/features/services/data/models/service.dart';
import 'package:barber_shop_app/features/users/data/models/app_user.dart';
import 'package:barber_shop_app/providers/onboarding_providers.dart';
import 'package:barber_shop_app/providers/salon_streams_provider.dart';
import 'package:barber_shop_app/providers/session_provider.dart';
import 'package:barber_shop_app/router/router_guards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class _MockCreateBookingController extends Mock
    implements CreateBookingController {}
class _FakeCreateBookingInput extends Fake implements CreateBookingInput {}

AppUser _user({required String role}) => AppUser(
  uid: 'u-1',
  name: role,
  email: '$role@example.com',
  role: role,
  salonId: 'salon-1',
  employeeId: role == 'barber' ? 'emp-1' : null,
);

OnboardingPrefsState _readyOnboarding() => const OnboardingPrefsState(
  languageCompleted: true,
  selectedLanguageCode: 'en',
  countryCompleted: true,
  countryCode: 'QA',
  countryName: 'Qatar',
  countryDialCode: '+974',
  selectedAuthRole: 'owner',
  customerOnboardingCompleted: true,
  preAuthSetupCompleted: true,
  customerPreauthDisplayName: null,
  customerPreauthPhone: null,
);

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeCreateBookingInput());
  });

  testWidgets('owner login and onboarding redirects resolve correctly', (
    tester,
  ) async {
    final out = resolveRedirect(
      location: AppRoutes.splash,
      sessionState: const AppSessionState(status: AppSessionStatus.unauthenticated),
      onboarding: _readyOnboarding(),
    );
    expect(out, AppRoutes.ownerLogin);

    final ownerIn = resolveRedirect(
      location: AppRoutes.ownerLogin,
      sessionState: AppSessionState(
        status: AppSessionStatus.ready,
        user: _user(role: 'owner'),
      ),
      onboarding: _readyOnboarding(),
    );
    expect(ownerIn, AppRoutes.ownerOverview);
  });

  testWidgets('open Customers tab and add customer via FAB', (tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.customers,
      routes: [
        GoRoute(
          path: AppRoutes.customers,
          builder: (_, _) => const CustomersScreen(),
        ),
        GoRoute(
          path: AppRoutes.customerNew,
          builder: (_, _) => const Scaffold(body: Text('add-customer-screen')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionUserProvider.overrideWith(
            (ref) => Stream.value(_user(role: 'owner')),
          ),
          customersListProvider.overrideWith(
            (ref, tag) => Stream.value(const <Customer>[]),
          ),
          customerSearchProvider.overrideWith(
            (ref, query) => Future.value(const <Customer>[]),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add customer'));
    await tester.pumpAndSettle();

    expect(find.text('add-customer-screen'), findsOneWidget);
  });

  testWidgets('create booking from customer details CTA routes', (tester) async {
    final router = GoRouter(
      initialLocation: '/details',
      routes: [
        GoRoute(
          path: '/details',
          builder: (_, _) => const CustomerDetailsScreen(customerId: 'c-1'),
        ),
        GoRoute(
          path: AppRoutes.bookingsNew,
          builder: (_, _) => const Scaffold(body: Text('create-booking-screen')),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionUserProvider.overrideWith(
            (ref) => Stream.value(_user(role: 'owner')),
          ),
          customerDetailsProvider.overrideWith(
            (ref, args) => Stream.value(
              const Customer(
                id: 'c-1',
                salonId: 'salon-1',
                fullName: 'Ali',
                phone: '5550000',
                isActive: true,
                createdBy: 'u-1',
              ),
            ),
          ),
          customerDetailSalesProvider.overrideWith(
            (ref, id) => Stream.value(const <Sale>[]),
          ),
          customerDetailUpcomingBookingsProvider.overrideWith(
            (ref, id) => Stream.value(const <Booking>[]),
          ),
          sessionSalonStreamProvider.overrideWith(
            (ref) => Stream.value(
              Salon(
                id: 'salon-1',
                salonId: 'salon-1',
                name: 'Test',
                phone: '+1',
                address: 'a',
                ownerUid: 'u-1',
                ownerName: 'Owner',
                ownerEmail: 'o@e.com',
                currencyCode: 'SAR',
              ),
            ),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Book appointment').first);
    await tester.pumpAndSettle();
    expect(find.text('create-booking-screen'), findsOneWidget);
  });

  testWidgets('overlapping booking is blocked by availability check', (
    tester,
  ) async {
    final firestore = FakeFirebaseFirestore();
    final repo = BookingRepository(firestore: firestore);
    await firestore.collection('salons/salon-1/bookings').doc('b1').set({
      'barberId': 'emp-1',
      'status': 'confirmed',
      'startAt': Timestamp.fromDate(DateTime.utc(2026, 1, 1, 9, 0)),
      'endAt': Timestamp.fromDate(DateTime.utc(2026, 1, 1, 10, 0)),
    });

    final ok = await repo.checkBarberAvailability(
      salonId: 'salon-1',
      barberId: 'emp-1',
      startAt: DateTime.utc(2026, 1, 1, 9, 30),
      endAt: DateTime.utc(2026, 1, 1, 10, 30),
    );
    expect(ok, isFalse);
  }, tags: ['critical']);

  testWidgets('permission denied UI behavior hides add-customer CTA for barber', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionUserProvider.overrideWith(
            (ref) => Stream.value(_user(role: 'barber')),
          ),
          customersListProvider.overrideWith(
            (ref, tag) => Stream.value(const <Customer>[]),
          ),
          customerSearchProvider.overrideWith(
            (ref, query) => Future.value(const <Customer>[]),
          ),
        ],
        child: const MaterialApp(home: CustomersScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Add customer'), findsNothing);
  }, tags: ['critical']);

  testWidgets('booking failure handling shows error snackbar', (tester) async {
    final controller = _MockCreateBookingController();
    when(
      () => controller.createBooking(any()),
    ).thenThrow(StateError('booking failed'));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          createBookingControllerProvider.overrideWithValue(controller),
          sessionUserProvider.overrideWith(
            (ref) => Stream.value(_user(role: 'owner')),
          ),
          servicesStreamProvider.overrideWith(
            (ref) => Stream.value([
              const SalonService(
                id: 'svc-1',
                salonId: 'salon-1',
                name: 'Haircut',
                serviceName: 'Haircut',
                durationMinutes: 30,
                price: 50,
              ),
            ]),
          ),
          employeesStreamProvider.overrideWith(
            (ref) => Stream.value([
              const Employee(
                id: 'emp-1',
                salonId: 'salon-1',
                name: 'Barber 1',
                email: 'b1@example.com',
                role: 'barber',
                isActive: true,
              ),
            ]),
          ),
          customerSearchProvider.overrideWith(
            (ref, q) => Future.value([
              const Customer(
                id: 'c-1',
                salonId: 'salon-1',
                fullName: 'Ali',
                phone: '5550000',
                isActive: true,
                createdBy: 'u-1',
              ),
            ]),
          ),
        ],
        child: const MaterialApp(home: CreateBookingScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Select customer
    await tester.tap(find.text('Ali'));
    await tester.pump();
    
    // Select service
    await tester.tap(find.text('Service'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Haircut').last);
    await tester.pumpAndSettle();
    
    // Select barber
    await tester.tap(find.text('Barber'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Barber 1').last);
    await tester.pumpAndSettle();
    
    // Select time
    await tester.tap(find.textContaining('Pick time'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    
    // Save
    await tester.tap(find.text('Save booking'));
    await tester.pumpAndSettle();
    expect(find.textContaining('booking failed'), findsOneWidget);
  }, tags: ['critical']);

  testWidgets('network failure handling surfaces retry-safe error', (tester) async {
    final controller = _MockCreateBookingController();
    when(
      () => controller.createBooking(any()),
    ).thenThrow(StateError('network unavailable'));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          createBookingControllerProvider.overrideWithValue(controller),
          sessionUserProvider.overrideWith(
            (ref) => Stream.value(_user(role: 'owner')),
          ),
          servicesStreamProvider.overrideWith(
            (ref) => Stream.value([
              const SalonService(
                id: 'svc-1',
                salonId: 'salon-1',
                name: 'Haircut',
                serviceName: 'Haircut',
                durationMinutes: 30,
                price: 50,
              ),
            ]),
          ),
          employeesStreamProvider.overrideWith(
            (ref) => Stream.value([
              const Employee(
                id: 'emp-1',
                salonId: 'salon-1',
                name: 'Barber 1',
                email: 'b1@example.com',
                role: 'barber',
                isActive: true,
              ),
            ]),
          ),
          customerSearchProvider.overrideWith(
            (ref, q) => Future.value([
              const Customer(
                id: 'c-1',
                salonId: 'salon-1',
                fullName: 'Ali',
                phone: '5550000',
                isActive: true,
                createdBy: 'u-1',
              ),
            ]),
          ),
        ],
        child: const MaterialApp(home: CreateBookingScreen()),
      ),
    );
    await tester.pumpAndSettle();
    
    // Select customer
    await tester.tap(find.text('Ali'));
    await tester.pump();
    
    // Select service
    await tester.tap(find.text('Service'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Haircut').last);
    await tester.pumpAndSettle();
    
    // Select barber
    await tester.tap(find.text('Barber'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Barber 1').last);
    await tester.pumpAndSettle();
    
    // Select time
    await tester.tap(find.textContaining('Pick time'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    
    // Save
    await tester.tap(find.text('Save booking'));
    await tester.pumpAndSettle();
    expect(find.textContaining('network unavailable'), findsOneWidget);
  }, tags: ['critical']);
}
