import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/firestore/firestore_json_helpers.dart';
import '../../../../core/firestore/firestore_serializers.dart';

part 'barber_metrics.freezed.dart';

/// Pre-aggregated barber KPIs under `salons/{salonId}/barberMetrics/{employeeId}`.
@freezed
abstract class BarberMetrics with _$BarberMetrics {
  const factory BarberMetrics({
    @JsonKey(fromJson: looseStringFromJson) required String employeeId,
    @JsonKey(fromJson: looseStringFromJson) required String salonId,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    DateTime? updatedAt,
    @Default(30) @JsonKey(fromJson: _windowDaysFromJson) int windowDays,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    DateTime? periodEndAt,
    @Default(0) @JsonKey(fromJson: looseIntFromJson) int completedCount,
    @Default(0) @JsonKey(fromJson: looseIntFromJson) int cancelledCount,
    @Default(0) @JsonKey(fromJson: looseIntFromJson) int noShowCount,
    @Default(0) @JsonKey(fromJson: looseDoubleFromJson) double completionRate,
    @Default(0) @JsonKey(fromJson: looseDoubleFromJson) double cancellationRate,
    @Default(0) @JsonKey(fromJson: looseDoubleFromJson) double noShowRate,
    @Default(<String, int>{})
    @JsonKey(fromJson: stringIntMapFromJson, toJson: stringIntMapToJson)
    Map<String, int> serviceCompletedCounts,
    @Default(0)
    @JsonKey(fromJson: looseIntFromJson)
    int activeBookingMinutesInWindow,
  }) = _BarberMetrics;

  factory BarberMetrics.fromDocumentJson(
    Map<String, dynamic> json, {
    required String documentId,
  }) {
    final normalized = Map<String, dynamic>.from(json);
    normalized['employeeId'] =
        FirestoreSerializers.string(json['employeeId']) ?? documentId;
    return BarberMetrics(
      employeeId: looseStringFromJson(normalized['employeeId']),
      salonId: looseStringFromJson(normalized['salonId']),
      updatedAt: nullableFirestoreDateTimeFromJson(normalized['updatedAt']),
      windowDays: _windowDaysFromJson(normalized['windowDays']),
      periodEndAt: nullableFirestoreDateTimeFromJson(normalized['periodEndAt']),
      completedCount: looseIntFromJson(normalized['completedCount']),
      cancelledCount: looseIntFromJson(normalized['cancelledCount']),
      noShowCount: looseIntFromJson(normalized['noShowCount']),
      completionRate: looseDoubleFromJson(normalized['completionRate']),
      cancellationRate: looseDoubleFromJson(normalized['cancellationRate']),
      noShowRate: looseDoubleFromJson(normalized['noShowRate']),
      serviceCompletedCounts: stringIntMapFromJson(
        normalized['serviceCompletedCounts'],
      ),
      activeBookingMinutesInWindow: looseIntFromJson(
        normalized['activeBookingMinutesInWindow'],
      ),
    );
  }
}

int _windowDaysFromJson(Object? value) =>
    FirestoreSerializers.intValue(value, fallback: 30);
