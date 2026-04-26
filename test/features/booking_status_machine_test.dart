import 'package:barber_shop_app/core/booking/invalid_booking_status_transition_exception.dart';
import 'package:barber_shop_app/core/constants/booking_status_machine.dart';
import 'package:barber_shop_app/core/constants/booking_statuses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingStatusMachine', () {
    test('normalize maps scheduled and empty to pending', () {
      expect(
        BookingStatusMachine.normalize('scheduled'),
        BookingStatuses.pending,
      );
      expect(BookingStatusMachine.normalize(''), BookingStatuses.pending);
      expect(BookingStatusMachine.normalize(null), BookingStatuses.pending);
    });

    test('allows defined transitions', () {
      expect(
        () => BookingStatusMachine.assertTransition(
          BookingStatuses.pending,
          BookingStatuses.confirmed,
        ),
        returnsNormally,
      );
      expect(
        () => BookingStatusMachine.assertTransition(
          BookingStatuses.pending,
          BookingStatuses.cancelled,
        ),
        returnsNormally,
      );
      expect(
        () => BookingStatusMachine.assertTransition(
          BookingStatuses.confirmed,
          BookingStatuses.completed,
        ),
        returnsNormally,
      );
      expect(
        () => BookingStatusMachine.assertTransition(
          BookingStatuses.confirmed,
          BookingStatuses.cancelled,
        ),
        returnsNormally,
      );
      expect(
        () => BookingStatusMachine.assertTransition(
          BookingStatuses.confirmed,
          BookingStatuses.noShow,
        ),
        returnsNormally,
      );
      expect(
        () => BookingStatusMachine.assertTransition(
          BookingStatuses.pending,
          BookingStatuses.rescheduled,
        ),
        returnsNormally,
      );
      expect(
        () => BookingStatusMachine.assertTransition(
          BookingStatuses.confirmed,
          BookingStatuses.rescheduled,
        ),
        returnsNormally,
      );
    });

    test('rejects invalid transitions', () {
      expect(
        () => BookingStatusMachine.assertTransition(
          BookingStatuses.pending,
          BookingStatuses.completed,
        ),
        throwsA(isA<InvalidBookingStatusTransitionException>()),
      );
      expect(
        () => BookingStatusMachine.assertTransition(
          BookingStatuses.pending,
          BookingStatuses.noShow,
        ),
        throwsA(isA<InvalidBookingStatusTransitionException>()),
      );
      expect(
        () => BookingStatusMachine.assertTransition(
          BookingStatuses.completed,
          BookingStatuses.pending,
        ),
        throwsA(isA<InvalidBookingStatusTransitionException>()),
      );
      expect(
        () => BookingStatusMachine.assertTransition(
          BookingStatuses.cancelled,
          BookingStatuses.rescheduled,
        ),
        throwsA(isA<InvalidBookingStatusTransitionException>()),
      );
      expect(
        () => BookingStatusMachine.assertTransition(
          BookingStatuses.rescheduled,
          BookingStatuses.pending,
        ),
        throwsA(isA<InvalidBookingStatusTransitionException>()),
      );
    });

    test('same status is a no-op', () {
      expect(
        () => BookingStatusMachine.assertTransition(
          BookingStatuses.confirmed,
          BookingStatuses.confirmed,
        ),
        returnsNormally,
      );
    });
  });
}
