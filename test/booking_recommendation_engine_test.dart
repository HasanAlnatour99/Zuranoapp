import 'package:barber_shop_app/core/booking/availability_schedule.dart';
import 'package:barber_shop_app/core/constants/user_roles.dart';
import 'package:barber_shop_app/features/bookings/data/models/barber_metrics.dart';
import 'package:barber_shop_app/features/bookings/logic/booking_recommendation_engine.dart';
import 'package:barber_shop_app/features/bookings/logic/booking_recommendation_models.dart';
import 'package:barber_shop_app/features/employees/data/models/employee.dart';
import 'package:barber_shop_app/features/salon/data/models/salon.dart';
import 'package:barber_shop_app/features/services/data/models/service.dart';
import 'package:flutter_test/flutter_test.dart';

WeeklyAvailability _openWeek() {
  return WeeklyAvailability({
    for (var i = 1; i <= 7; i++) i: DaySchedule.defaultWindow(),
  });
}

Salon _salon() {
  return Salon(
    id: 's1',
    salonId: 's1',
    name: 'T',
    phone: '1',
    address: 'a',
    ownerUid: 'o',
    ownerName: 'on',
    ownerEmail: 'e@e.com',
    weeklyAvailability: _openWeek(),
  );
}

Employee _barber(String id, String name) {
  return Employee(
    id: id,
    salonId: 's1',
    name: name,
    email: '$id@t.com',
    role: UserRoles.barber,
  );
}

SalonService _service() {
  return SalonService(
    id: 'svc1',
    salonId: 's1',
    name: 'Cut',
    durationMinutes: 30,
    price: 20,
  );
}

BarberMetrics _metrics({
  required String id,
  double completion = 0.5,
  double cancel = 0.1,
  double noShow = 0.05,
  int workloadMin = 60,
  Map<String, int> serviceCounts = const {'svc1': 2},
}) {
  return BarberMetrics(
    employeeId: id,
    salonId: 's1',
    completionRate: completion,
    cancellationRate: cancel,
    noShowRate: noShow,
    activeBookingMinutesInWindow: workloadMin,
    serviceCompletedCounts: serviceCounts,
  );
}

void main() {
  final salon = _salon();
  final service = _service();
  final day = DateTime(2030, 6, 10);

  test('returns null when no barbers', () {
    final r = BookingRecommendationEngine.compute(
      salon: salon,
      service: service,
      selectedLocalDay: day,
      barbers: const [],
      dayBusyBookings: const [],
      metricsByEmployeeId: const {},
    );
    expect(r, isNull);
  });

  test('service history gate restricts eligible barbers', () {
    final b1 = _barber('b1', 'Ann');
    final b2 = _barber('b2', 'Zed');
    final r = BookingRecommendationEngine.compute(
      salon: salon,
      service: service,
      selectedLocalDay: day,
      barbers: [b1, b2],
      dayBusyBookings: const [],
      metricsByEmployeeId: {
        'b1': _metrics(id: 'b1'),
        'b2': _metrics(id: 'b2', serviceCounts: const {}),
      },
    );
    expect(r, isNotNull);
    expect(r!.bestOverall.employeeId, 'b1');
    expect(r.fastestAvailable.employeeId, 'b1');
    expect(r.alternatives, isEmpty);
  });

  test('fallback when no service history uses all barbers', () {
    final b1 = _barber('b1', 'Ann');
    final b2 = _barber('b2', 'Zed');
    final r = BookingRecommendationEngine.compute(
      salon: salon,
      service: service,
      selectedLocalDay: day,
      barbers: [b1, b2],
      dayBusyBookings: const [],
      metricsByEmployeeId: {
        'b1': _metrics(id: 'b1', serviceCounts: const {}),
        'b2': _metrics(id: 'b2', serviceCounts: const {}),
      },
    );
    expect(r, isNotNull);
    expect(r!.alternatives.length, 1);
  });

  test('higher completion wins when weighted', () {
    final b1 = _barber('b1', 'Ann');
    final b2 = _barber('b2', 'Zed');
    final w = RecommendationWeights(
      serviceMatch: 0,
      availability: 0,
      completionRate: 1,
      lowCancellation: 0,
      lowNoShow: 0,
      workloadBalance: 0,
      preferredBarber: 0,
    );
    final r = BookingRecommendationEngine.compute(
      salon: salon,
      service: service,
      selectedLocalDay: day,
      barbers: [b1, b2],
      dayBusyBookings: const [],
      metricsByEmployeeId: {
        'b1': _metrics(id: 'b1', completion: 0.95),
        'b2': _metrics(id: 'b2', completion: 0.1),
      },
      weights: w,
    );
    expect(r!.bestOverall.employeeId, 'b1');
 });

  test('preferred barber surfaced when has slot', () {
    final b1 = _barber('b1', 'Ann');
    final b2 = _barber('b2', 'Zed');
    final r = BookingRecommendationEngine.compute(
      salon: salon,
      service: service,
      selectedLocalDay: day,
      barbers: [b1, b2],
      dayBusyBookings: const [],
      metricsByEmployeeId: {
        'b1': _metrics(id: 'b1'),
        'b2': _metrics(id: 'b2'),
      },
      preferredBarberId: 'b2',
    );
    expect(r!.preferredBarber, isNotNull);
    expect(r.preferredBarber!.employeeId, 'b2');
  });

  test('preferred barber null when no slot', () {
    final b1 = _barber('b1', 'Ann');
    final b2Off = WeeklyAvailability({
      day.weekday: const DaySchedule(
        isDayOff: true,
        openMinute: 0,
        closeMinute: 0,
        breaks: [],
      ),
    });
    final b2 = Employee(
      id: 'b2',
      salonId: 's1',
      name: 'Zed',
      email: 'b2@t.com',
      role: UserRoles.barber,
      weeklyAvailability: b2Off,
    );
    final r = BookingRecommendationEngine.compute(
      salon: salon,
      service: service,
      selectedLocalDay: day,
      barbers: [b1, b2],
      dayBusyBookings: const [],
      metricsByEmployeeId: {
        'b1': _metrics(id: 'b1'),
        'b2': _metrics(id: 'b2'),
      },
      preferredBarberId: 'b2',
    );
    expect(r!.preferredBarber, isNull);
    expect(r.bestOverall.employeeId, 'b1');
  });

  test('fastest is earliest slot among candidates', () {
    final off = WeeklyAvailability({
      day.weekday: const DaySchedule(
        isDayOff: true,
        openMinute: 0,
        closeMinute: 0,
        breaks: [],
      ),
    });
    final b1 = Employee(
      id: 'b1',
      salonId: 's1',
      name: 'Ann',
      email: 'b1@t.com',
      role: UserRoles.barber,
      weeklyAvailability: off,
    );
    final b2 = _barber('b2', 'Zed');
    final r = BookingRecommendationEngine.compute(
      salon: salon,
      service: service,
      selectedLocalDay: day,
      barbers: [b1, b2],
      dayBusyBookings: const [],
      metricsByEmployeeId: {
        'b1': _metrics(id: 'b1'),
        'b2': _metrics(id: 'b2'),
      },
      weights: RecommendationWeights(
        serviceMatch: 0,
        availability: 0,
        completionRate: 1,
        lowCancellation: 0,
        lowNoShow: 0,
        workloadBalance: 0,
        preferredBarber: 0,
      ),
    );
    expect(r!.fastestAvailable.employeeId, 'b2');
    expect(r.bestOverall.employeeId, 'b2');
  });
}
