import 'package:barber_shop_app/core/constants/booking_statuses.dart';
import 'package:barber_shop_app/features/bookings/data/models/booking.dart';
import 'package:barber_shop_app/features/owner/logic/owner_booking_kpis.dart';
import 'package:flutter_test/flutter_test.dart';

Booking _b({
  required String id,
  required String status,
  required DateTime startAt,
  required DateTime endAt,
  int reportYear = 2026,
  int reportMonth = 4,
  String barberId = 'e1',
  String? barberName,
  DateTime? cancelledAt,
  DateTime? updatedAt,
}) {
  return Booking(
    id: id,
    salonId: 's1',
    barberId: barberId,
    customerId: 'c1',
    startAt: startAt,
    endAt: endAt,
    status: status,
    barberName: barberName ?? 'Barber $barberId',
    reportYear: reportYear,
    reportMonth: reportMonth,
    cancelledAt: cancelledAt,
    updatedAt: updatedAt,
  );
}

void main() {
  final now = DateTime(2026, 4, 18, 15);

  test('completed today uses endAt local day', () {
    final bookings = [
      _b(
        id: '1',
        status: BookingStatuses.completed,
        startAt: DateTime(2026, 4, 17, 10),
        endAt: DateTime(2026, 4, 18, 11),
      ),
      _b(
        id: '2',
        status: BookingStatuses.completed,
        startAt: DateTime(2026, 4, 18, 9),
        endAt: DateTime(2026, 4, 19, 10),
      ),
    ];
    final k = OwnerBookingKpis.compute(bookings, now);
    expect(k.completedToday, 1);
  });

  test('cancelled today uses cancelledAt', () {
    final bookings = [
      _b(
        id: '1',
        status: BookingStatuses.cancelled,
        startAt: DateTime(2026, 4, 10),
        endAt: DateTime(2026, 4, 10, 1),
        cancelledAt: DateTime(2026, 4, 18, 8),
      ),
      _b(
        id: '2',
        status: BookingStatuses.cancelled,
        startAt: DateTime(2026, 4, 10),
        endAt: DateTime(2026, 4, 10, 1),
        cancelledAt: DateTime(2026, 4, 17, 8),
      ),
    ];
    final k = OwnerBookingKpis.compute(bookings, now);
    expect(k.cancelledToday, 1);
  });

  test('rescheduled today uses updatedAt', () {
    final bookings = [
      _b(
        id: '1',
        status: BookingStatuses.rescheduled,
        startAt: DateTime(2026, 4, 10),
        endAt: DateTime(2026, 4, 10, 1),
        updatedAt: DateTime(2026, 4, 18, 20),
      ),
    ];
    final k = OwnerBookingKpis.compute(bookings, now);
    expect(k.rescheduledToday, 1);
  });

  test('month rates use terminal outcomes only', () {
    final bookings = [
      _b(
        id: '1',
        status: BookingStatuses.completed,
        startAt: DateTime(2026, 4, 5),
        endAt: DateTime(2026, 4, 5, 1),
        barberId: 'a',
        barberName: 'Zed',
      ),
      _b(
        id: '2',
        status: BookingStatuses.completed,
        startAt: DateTime(2026, 4, 6),
        endAt: DateTime(2026, 4, 6, 1),
        barberId: 'b',
        barberName: 'Amy',
      ),
      _b(
        id: '3',
        status: BookingStatuses.cancelled,
        startAt: DateTime(2026, 4, 7),
        endAt: DateTime(2026, 4, 7, 1),
      ),
      _b(
        id: '4',
        status: BookingStatuses.noShow,
        startAt: DateTime(2026, 4, 8),
        endAt: DateTime(2026, 4, 8, 1),
      ),
      _b(
        id: '5',
        status: BookingStatuses.pending,
        startAt: DateTime(2026, 4, 9),
        endAt: DateTime(2026, 4, 9, 1),
      ),
    ];
    final k = OwnerBookingKpis.compute(bookings, now);
    expect(k.completionRateMonth, closeTo(2 / 4, 1e-9));
    expect(k.cancellationRateMonth, closeTo(1 / 4, 1e-9));
    expect(k.topBarberCompletionsName, 'Amy');
  });

  test('null rates when no terminal outcomes in month', () {
    final bookings = [
      _b(
        id: '1',
        status: BookingStatuses.pending,
        startAt: DateTime(2026, 4, 9),
        endAt: DateTime(2026, 4, 9, 1),
      ),
    ];
    final k = OwnerBookingKpis.compute(bookings, now);
    expect(k.completionRateMonth, isNull);
    expect(k.cancellationRateMonth, isNull);
  });
}
