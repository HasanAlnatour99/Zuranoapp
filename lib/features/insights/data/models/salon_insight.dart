import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/firestore/firestore_json_helpers.dart';
import '../../../../core/firestore/firestore_serializers.dart';
import 'retention_insight_payload.dart';

part 'salon_insight.freezed.dart';

/// Machine-readable `salons/{salonId}/insights/{id}.type` values (written by Cloud Functions).
abstract final class SalonInsightTypes {
  static const topBarberRevenue = 'top_barber_revenue';
  static const weekTotalRevenue = 'week_total_revenue';
  static const busiestDay = 'busiest_day';
  static const customerRetention = 'customer_retention';

  static final Set<String> weeklyBusinessTypes = {
    topBarberRevenue,
    weekTotalRevenue,
    busiestDay,
  };
}

/// `salons/{salonId}/insights/{insightId}` — weekly aggregates for owners.
@freezed
abstract class SalonInsight with _$SalonInsight {
  const SalonInsight._();

  const factory SalonInsight({
    @JsonKey(fromJson: looseStringFromJson) required String id,
    @JsonKey(fromJson: looseStringFromJson) required String type,
    @JsonKey(fromJson: looseStringFromJson) required String title,
    @JsonKey(fromJson: looseStringFromJson) required String message,
    @JsonKey(fromJson: _periodFromJson) required String period,
    @JsonKey(fromJson: looseDoubleFromJson) required double value,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    required DateTime? createdAt,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? weekKey,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    DateTime? weekStart,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    DateTime? weekEnd,
    @JsonKey(
      fromJson: nullableStringDynamicMapFromJson,
      toJson: nullableStringDynamicMapToJson,
    )
    Map<String, dynamic>? payload,
  }) = _SalonInsight;

  RetentionInsightPayload? get retentionPayload =>
      type == SalonInsightTypes.customerRetention
      ? RetentionInsightPayload.tryParse(payload)
      : null;

  factory SalonInsight.fromJson(String id, Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    normalized['id'] = id;
    normalized['payload'] = nullableStringDynamicMapFromJson(json['payload']);
    return SalonInsight(
      id: looseStringFromJson(normalized['id']),
      type: looseStringFromJson(normalized['type']),
      title: looseStringFromJson(normalized['title']),
      message: looseStringFromJson(normalized['message']),
      period: _periodFromJson(normalized['period']),
      value: looseDoubleFromJson(normalized['value']),
      createdAt: nullableFirestoreDateTimeFromJson(normalized['createdAt']),
      weekKey: nullableLooseStringFromJson(normalized['weekKey']),
      weekStart: nullableFirestoreDateTimeFromJson(normalized['weekStart']),
      weekEnd: nullableFirestoreDateTimeFromJson(normalized['weekEnd']),
      payload: nullableStringDynamicMapFromJson(normalized['payload']),
    );
  }

  factory SalonInsight.fromDocumentJson(String id, Map<String, dynamic> json) =>
      SalonInsight.fromJson(id, json);
}

String _periodFromJson(Object? value) =>
    FirestoreSerializers.string(value) ?? 'weekly';
