import 'package:barber_shop_app/core/constants/booking_statuses.dart';
import 'package:barber_shop_app/core/constants/violation_types.dart';
import 'package:barber_shop_app/features/bookings/data/models/booking.dart';
import 'package:barber_shop_app/features/owner/logic/owner_reliability_kpis.dart';
import 'package:barber_shop_app/features/violations/data/models/violation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 4, 18, 15);

  test('no-show today uses noShowMarkedAt when set', () {
    final bookings = [
      Booking(
        id: '1',
        salonId: 's1',
        barberId: 'e1',
        customerId: 'c1',
        startAt: DateTime(2026, 4, 18, 10),
        endAt: DateTime(2026, 4, 18, 11),
        status: BookingStatuses.noShow,
        noShowMarkedAt: DateTime(2026, 4, 18, 12),
      ),
      Booking(
        id: '2',
        salonId: 's1',
        barberId: 'e1',
        customerId: 'c1',
        startAt: DateTime(2026, 4, 17, 10),
        endAt: DateTime(2026, 4, 17, 11),
        status: BookingStatuses.noShow,
        noShowMarkedAt: DateTime(2026, 4, 17, 12),
      ),
    ];
    final k = OwnerReliabilityKpis.compute(bookings, const [], now);
    expect(k.noShowCountToday, 1);
  });

  test('penalty month sums approved and applied violations only', () {
    final violations = [
      Violation(
        id: 'v1',
        salonId: 's1',
        employeeId: 'e1',
        employeeName: 'Amy',
        sourceType: ViolationSourceTypes.booking,
        violationType: ViolationTypes.barberLate,
        status: ViolationStatuses.approved,
        occurredAt: DateTime(2026, 4, 10),
        reportYear: 2026,
        reportMonth: 4,
        amount: 10,
      ),
      Violation(
        id: 'v2',
        salonId: 's1',
        employeeId: 'e1',
        employeeName: 'Amy',
        sourceType: ViolationSourceTypes.booking,
        violationType: ViolationTypes.barberNoShow,
        status: ViolationStatuses.pending,
        occurredAt: DateTime(2026, 4, 11),
        reportYear: 2026,
        reportMonth: 4,
        amount: 50,
      ),
      Violation(
        id: 'v3',
        salonId: 's1',
        employeeId: 'e2',
        employeeName: 'Zed',
        sourceType: ViolationSourceTypes.booking,
        violationType: ViolationTypes.barberLate,
        status: ViolationStatuses.applied,
        occurredAt: DateTime(2026, 4, 5),
        reportYear: 2026,
        reportMonth: 4,
        amount: 5,
      ),
    ];
    final k = OwnerReliabilityKpis.compute(const [], violations, now);
    expect(k.penaltyAmountMonth, 15);
    expect(k.topPenalizedBarberName, 'Amy');
  });
}
