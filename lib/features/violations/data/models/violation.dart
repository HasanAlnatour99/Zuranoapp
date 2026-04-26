import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/violation_types.dart';
import '../../../../core/firestore/firestore_json_helpers.dart';
import '../../../../core/firestore/firestore_serializers.dart';
import '../../../../core/firestore/report_period.dart';

/// `salons/{salonId}/violations/{violationId}`
part 'violation.freezed.dart';
part 'violation.g.dart';

@freezed
abstract class Violation with _$Violation {
  const Violation._();

  const factory Violation({
    @JsonKey(fromJson: looseStringFromJson) required String id,
    @JsonKey(fromJson: looseStringFromJson) required String salonId,
    @JsonKey(fromJson: looseStringFromJson) required String employeeId,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? employeeName,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? bookingId,
    @JsonKey(fromJson: _sourceTypeFromJson) required String sourceType,
    @JsonKey(fromJson: looseStringFromJson) required String violationType,
    @JsonKey(fromJson: _statusFromJson) required String status,
    @JsonKey(
      fromJson: firestoreDateTimeFromJson,
      toJson: firestoreDateTimeToJson,
    )
    required DateTime occurredAt,
    @Default(0) @JsonKey(fromJson: looseIntFromJson) int reportYear,
    @Default(0) @JsonKey(fromJson: looseIntFromJson) int reportMonth,
    @JsonKey(fromJson: nullableLooseIntFromJson) int? minutesLate,
    @Default(0) @JsonKey(fromJson: looseDoubleFromJson) double amount,
    @JsonKey(fromJson: nullableLooseDoubleFromJson) double? percent,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? currency,
    @JsonKey(
      fromJson: nullableStringDynamicMapFromJson,
      toJson: nullableStringDynamicMapToJson,
    )
    Map<String, dynamic>? ruleSnapshot,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? notes,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? createdByUid,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? createdByRole,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? approvedByUid,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    DateTime? approvedAt,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? payrollRunId,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    DateTime? appliedAt,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    DateTime? createdAt,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    DateTime? updatedAt,
  }) = _Violation;

  String get reportPeriodKey => ReportPeriod.periodKey(reportYear, reportMonth);

  bool get isUnapplied => payrollRunId == null || payrollRunId!.trim().isEmpty;

  factory Violation.fromJson(Map<String, dynamic> json) =>
      _$ViolationFromJson(_normalizedViolationJson(json));
}

Map<String, dynamic> _normalizedViolationJson(Map<String, dynamic> json) {
  final occurredAt =
      FirestoreSerializers.dateTime(json['occurredAt']) ??
      DateTime.fromMillisecondsSinceEpoch(0);
  var reportYear = FirestoreSerializers.intValue(json['reportYear']);
  var reportMonth = FirestoreSerializers.intValue(json['reportMonth']);
  if (reportYear == 0 || reportMonth == 0) {
    final fromKey = ReportPeriod.parsePeriodKey(
      FirestoreSerializers.string(json['reportPeriodKey']),
    );
    if (fromKey != null) {
      reportYear = fromKey.$1;
      reportMonth = fromKey.$2;
    } else {
      reportYear = ReportPeriod.yearFrom(occurredAt);
      reportMonth = ReportPeriod.monthFrom(occurredAt);
    }
  }

  final normalized = Map<String, dynamic>.from(json);
  normalized['occurredAt'] = occurredAt;
  normalized['reportYear'] = reportYear;
  normalized['reportMonth'] = reportMonth;
  normalized['violationType'] = _violationTypeFromJson(json);
  normalized['status'] = _normalizedStatusFromJson(json);
  normalized['amount'] = _amountFromJson(json);
  normalized['notes'] =
      FirestoreSerializers.string(json['notes']) ??
      FirestoreSerializers.string(json['reason']);
  normalized['ruleSnapshot'] = nullableStringDynamicMapFromJson(
    json['ruleSnapshot'],
  );
  normalized['minutesLate'] = json['minutesLate'] == null
      ? null
      : FirestoreSerializers.intValue(json['minutesLate']);
  return normalized;
}

String _sourceTypeFromJson(Object? value) =>
    nullableLooseStringFromJson(value) ?? ViolationSourceTypes.booking;

String _statusFromJson(Object? value) =>
    nullableLooseStringFromJson(value) ?? ViolationStatuses.pending;

String _violationTypeFromJson(Map<String, dynamic> json) {
  final violationTypeNew = FirestoreSerializers.string(json['violationType']);
  final typeLegacy = FirestoreSerializers.string(json['type']);
  return (violationTypeNew != null && violationTypeNew.isNotEmpty)
      ? violationTypeNew
      : (typeLegacy ?? '');
}

String _normalizedStatusFromJson(Map<String, dynamic> json) {
  var status = FirestoreSerializers.string(json['status']) ?? '';
  if (status == 'open' || status.isEmpty) {
    status = ViolationStatuses.pending;
  }
  return status;
}

double _amountFromJson(Map<String, dynamic> json) {
  final hasAmount = json.containsKey('amount');
  var amount = FirestoreSerializers.doubleValue(json['amount']);
  if (!hasAmount && json.containsKey('penaltyAmount')) {
    amount = FirestoreSerializers.doubleValue(json['penaltyAmount']);
  }
  return amount;
}
