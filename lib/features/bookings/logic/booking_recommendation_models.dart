import 'package:flutter/foundation.dart';

/// Riverpod family key for [bookingRecommendationProvider].
@immutable
class BookingRecommendationRequest {
  const BookingRecommendationRequest({
    required this.salonId,
    required this.serviceId,
    required this.selectedLocalDay,
    this.preferredBarberId,
  });

  final String salonId;
  final String serviceId;
  final DateTime selectedLocalDay;
  final String? preferredBarberId;

  @override
  bool operator ==(Object other) {
    return other is BookingRecommendationRequest &&
        salonId == other.salonId &&
        serviceId == other.serviceId &&
        other.selectedLocalDay.year == selectedLocalDay.year &&
        other.selectedLocalDay.month == selectedLocalDay.month &&
        other.selectedLocalDay.day == selectedLocalDay.day &&
        other.preferredBarberId == preferredBarberId;
  }

  @override
  int get hashCode => Object.hash(
    salonId,
    serviceId,
    Object.hash(
      selectedLocalDay.year,
      selectedLocalDay.month,
      selectedLocalDay.day,
    ),
    preferredBarberId,
  );
}

/// Configurable weights for [BookingRecommendationEngine] (keep sum ~1 for interpretability).
@immutable
class RecommendationWeights {
  const RecommendationWeights({
    this.serviceMatch = 0.22,
    this.availability = 0.18,
    this.completionRate = 0.18,
    this.lowCancellation = 0.12,
    this.lowNoShow = 0.12,
    this.workloadBalance = 0.1,
    this.preferredBarber = 0.08,
  });

  final double serviceMatch;
  final double availability;
  final double completionRate;
  final double lowCancellation;
  final double lowNoShow;
  final double workloadBalance;
  final double preferredBarber;

  RecommendationWeights copyWith({
    double? serviceMatch,
    double? availability,
    double? completionRate,
    double? lowCancellation,
    double? lowNoShow,
    double? workloadBalance,
    double? preferredBarber,
  }) {
    return RecommendationWeights(
      serviceMatch: serviceMatch ?? this.serviceMatch,
      availability: availability ?? this.availability,
      completionRate: completionRate ?? this.completionRate,
      lowCancellation: lowCancellation ?? this.lowCancellation,
      lowNoShow: lowNoShow ?? this.lowNoShow,
      workloadBalance: workloadBalance ?? this.workloadBalance,
      preferredBarber: preferredBarber ?? this.preferredBarber,
    );
  }
}

/// L10n keys: `recommendationReason_*`
enum RecommendationReason {
  experiencedWithService,
  noServiceHistoryFallback,
  strongTrackRecord,
  soonestTime,
  preferredBarber,
  balancedSchedule,
  moreAvailabilityToday,
}

@immutable
class BookingRecommendation {
  const BookingRecommendation({
    required this.employeeId,
    required this.barberName,
    required this.slotStartUtc,
    required this.score,
    required this.reasons,
  });

  final String employeeId;
  final String barberName;
  final DateTime slotStartUtc;
  final double score;
  final List<RecommendationReason> reasons;
}

@immutable
class RecommendationResult {
  const RecommendationResult({
    required this.bestOverall,
    required this.fastestAvailable,
    this.preferredBarber,
    required this.alternatives,
  });

  final BookingRecommendation bestOverall;
  final BookingRecommendation fastestAvailable;
  final BookingRecommendation? preferredBarber;
  final List<BookingRecommendation> alternatives;
}
