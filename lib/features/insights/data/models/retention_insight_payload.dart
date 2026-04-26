import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/firestore/firestore_json_helpers.dart';
import '../../../../core/firestore/firestore_serializers.dart';

/// Structured fields for `type == customer_retention` insight docs (Cloud Function).
part 'retention_insight_payload.freezed.dart';
part 'retention_insight_payload.g.dart';

@freezed
abstract class RetentionInsightPayload with _$RetentionInsightPayload {
  const factory RetentionInsightPayload({
    @JsonKey(fromJson: _timeZoneFromJson) required String timeZone,
    @JsonKey(fromJson: looseIntFromJson) required int calendarYear,
    @JsonKey(fromJson: looseIntFromJson) required int calendarMonth,
    @JsonKey(fromJson: looseIntFromJson) required int repeatCustomersThisMonth,
    @JsonKey(fromJson: looseIntFromJson)
    required int firstTimeCustomersThisMonth,
    @JsonKey(fromJson: looseIntFromJson)
    required int distinctCustomersCompletedThisMonth,
    @JsonKey(fromJson: looseIntFromJson)
    required int returningCustomersThisMonth,
    @JsonKey(fromJson: looseDoubleFromJson) required double retentionRate,
    @JsonKey(fromJson: looseIntFromJson)
    required int customersWithNoVisit30Days,
    @JsonKey(fromJson: looseIntFromJson) required int noShowCountLastLocalWeek,
    @JsonKey(fromJson: looseIntFromJson)
    required int noShowCountPreviousLocalWeek,
    @JsonKey(fromJson: looseIntFromJson) required int noShowDeltaLastVsPrevious,
  }) = _RetentionInsightPayload;

  factory RetentionInsightPayload.fromJson(Map<String, dynamic> json) =>
      _$RetentionInsightPayloadFromJson(json);

  /// 0.0–1.0 (returning / distinct completed this month).
  static RetentionInsightPayload? tryParse(Object? raw) {
    if (raw is! Map) {
      return null;
    }
    return RetentionInsightPayload.fromJson(Map<String, dynamic>.from(raw));
  }
}

String _timeZoneFromJson(Object? value) =>
    FirestoreSerializers.string(value) ?? 'UTC';
