import '../../../core/booking/availability_schedule.dart';
import '../../employees/data/models/employee.dart';
import '../../salon/data/models/salon.dart';
import '../../services/data/models/service.dart';
import '../data/models/barber_metrics.dart';
import '../data/models/booking.dart';
import 'booking_recommendation_models.dart';

class _Candidate {
  _Candidate({
    required this.barber,
    required this.firstSlotUtc,
    required this.score,
    required this.reasons,
  });

  final Employee barber;
  final DateTime firstSlotUtc;
  final double score;
  final List<RecommendationReason> reasons;
}

/// Ranks barber + first available slot using [CustomerSlotPlanner] and [BarberMetrics].
abstract final class BookingRecommendationEngine {
  static RecommendationResult? compute({
    required Salon salon,
    required SalonService service,
    required DateTime selectedLocalDay,
    required List<Employee> barbers,
    required List<Booking> dayBusyBookings,
    required Map<String, BarberMetrics> metricsByEmployeeId,
    RecommendationWeights weights = const RecommendationWeights(),
    String? preferredBarberId,
    int slotStepMinutes = kCustomerSlotStepMinutes,
    int maxAlternatives = 4,
  }) {
    if (barbers.isEmpty) {
      return null;
    }

    final serviceId = service.id;
    var anyServiceHistory = false;
    for (final b in barbers) {
      final c =
          metricsByEmployeeId[b.id]?.serviceCompletedCounts[serviceId] ?? 0;
      if (c > 0) {
        anyServiceHistory = true;
        break;
      }
    }

    final eligible = anyServiceHistory
        ? barbers
              .where(
                (b) =>
                    (metricsByEmployeeId[b.id]
                            ?.serviceCompletedCounts[serviceId] ??
                        0) >
                    0,
              )
              .toList()
        : List<Employee>.from(barbers);

    if (eligible.isEmpty) {
      return null;
    }

    final loads = eligible
        .map(
          (b) => metricsByEmployeeId[b.id]?.activeBookingMinutesInWindow ?? 0,
        )
        .toList();
    final maxLoad = loads.fold<int>(1, (a, b) => a > b ? a : b);

    final raw = <_Candidate>[];
    for (final barber in eligible) {
      final slots = CustomerSlotPlanner.candidateStartsUtc(
        selectedLocalDay: selectedLocalDay,
        serviceDurationMinutes: service.durationMinutes,
        existingBookings: dayBusyBookings,
        barberId: barber.id,
        salon: salon,
        barber: barber,
        slotStepMinutes: slotStepMinutes,
      );
      if (slots.isEmpty) {
        continue;
      }
      var first = slots.first;
      for (final s in slots.skip(1)) {
        if (s.isBefore(first)) {
          first = s;
        }
      }
      raw.add(
        _Candidate(barber: barber, firstSlotUtc: first, score: 0, reasons: []),
      );
    }

    if (raw.isEmpty) {
      return null;
    }

    var minMs = raw.first.firstSlotUtc.millisecondsSinceEpoch;
    var maxMs = minMs;
    for (final c in raw) {
      final m = c.firstSlotUtc.millisecondsSinceEpoch;
      if (m < minMs) {
        minMs = m;
      }
      if (m > maxMs) {
        maxMs = m;
      }
    }
    final span = (maxMs - minMs).clamp(1, 1 << 62);

    final scored = <_Candidate>[];
    for (final c in raw) {
      final m =
          metricsByEmployeeId[c.barber.id] ??
          BarberMetrics(employeeId: c.barber.id, salonId: salon.salonId);

      final serviceMatch = anyServiceHistory ? 1.0 : 0.5;
      final t = c.firstSlotUtc.millisecondsSinceEpoch;
      final availability = 1.0 - (t - minMs) / span;
      final completion = m.completionRate.clamp(0.0, 1.0);
      final lowCancel = (1.0 - m.cancellationRate).clamp(0.0, 1.0);
      final lowNoShow = (1.0 - m.noShowRate).clamp(0.0, 1.0);
      final load = m.activeBookingMinutesInWindow;
      final workloadBalance = 1.0 - (load / maxLoad).clamp(0.0, 1.0);
      final pref = preferredBarberId != null && preferredBarberId == c.barber.id
          ? 1.0
          : 0.0;

      final score =
          weights.serviceMatch * serviceMatch +
          weights.availability * availability +
          weights.completionRate * completion +
          weights.lowCancellation * lowCancel +
          weights.lowNoShow * lowNoShow +
          weights.workloadBalance * workloadBalance +
          weights.preferredBarber * pref;

      final reasons = <RecommendationReason>[
        if (anyServiceHistory) RecommendationReason.experiencedWithService,
        if (!anyServiceHistory) RecommendationReason.noServiceHistoryFallback,
        if (completion >= 0.65) RecommendationReason.strongTrackRecord,
        if (workloadBalance >= 0.55) RecommendationReason.balancedSchedule,
        if (t == minMs) RecommendationReason.moreAvailabilityToday,
        if (pref >= 1.0) RecommendationReason.preferredBarber,
      ];

      scored.add(
        _Candidate(
          barber: c.barber,
          firstSlotUtc: c.firstSlotUtc,
          score: score,
          reasons: reasons,
        ),
      );
    }

    scored.sort((a, b) {
      final cmp = b.score.compareTo(a.score);
      if (cmp != 0) {
        return cmp;
      }
      final timeCmp = a.firstSlotUtc.compareTo(b.firstSlotUtc);
      if (timeCmp != 0) {
        return timeCmp;
      }
      return a.barber.name.compareTo(b.barber.name);
    });

    final best = scored.first;
    final fastest = [...scored]
      ..sort((a, b) {
        final timeCmp = a.firstSlotUtc.compareTo(b.firstSlotUtc);
        if (timeCmp != 0) {
          return timeCmp;
        }
        return a.barber.name.compareTo(b.barber.name);
      });
    final fastestCand = fastest.first;

    BookingRecommendation? preferredRec;
    if (preferredBarberId != null) {
      _Candidate? prefCand;
      for (final c in scored) {
        if (c.barber.id == preferredBarberId) {
          prefCand = c;
          break;
        }
      }
      if (prefCand != null) {
        final p = prefCand;
        preferredRec = BookingRecommendation(
          employeeId: p.barber.id,
          barberName: p.barber.name,
          slotStartUtc: p.firstSlotUtc,
          score: p.score,
          reasons: [
            RecommendationReason.preferredBarber,
            ...p.reasons.where(
              (r) => r != RecommendationReason.preferredBarber,
            ),
          ],
        );
      }
    }

    final bestOverall = BookingRecommendation(
      employeeId: best.barber.id,
      barberName: best.barber.name,
      slotStartUtc: best.firstSlotUtc,
      score: best.score,
      reasons: best.reasons,
    );

    final fastestReasons = <RecommendationReason>[
      RecommendationReason.soonestTime,
      ...fastestCand.reasons.where(
        (r) =>
            r != RecommendationReason.soonestTime &&
            r != RecommendationReason.moreAvailabilityToday,
      ),
    ];
    final fastestAvailable = BookingRecommendation(
      employeeId: fastestCand.barber.id,
      barberName: fastestCand.barber.name,
      slotStartUtc: fastestCand.firstSlotUtc,
      score: fastestCand.score,
      reasons: fastestReasons,
    );

    final alternatives = <BookingRecommendation>[];
    for (final c in scored.skip(1)) {
      if (alternatives.length >= maxAlternatives) {
        break;
      }
      if (c.barber.id == best.barber.id) {
        continue;
      }
      alternatives.add(
        BookingRecommendation(
          employeeId: c.barber.id,
          barberName: c.barber.name,
          slotStartUtc: c.firstSlotUtc,
          score: c.score,
          reasons: c.reasons,
        ),
      );
    }

    return RecommendationResult(
      bestOverall: bestOverall,
      fastestAvailable: fastestAvailable,
      preferredBarber: preferredRec,
      alternatives: alternatives,
    );
  }
}
