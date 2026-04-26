import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/payroll_statuses.dart';
import '../../../../core/firestore/firestore_json_helpers.dart';
import '../../../../core/firestore/firestore_serializers.dart';
import '../../../../core/firestore/report_period.dart';
import 'payroll_deduction_line.dart';

part 'payroll_record.freezed.dart';
part 'payroll_record.g.dart';

@freezed
abstract class PayrollRecord with _$PayrollRecord {
  const PayrollRecord._();

  const factory PayrollRecord({
    @JsonKey(fromJson: looseStringFromJson) required String id,
    @JsonKey(fromJson: looseStringFromJson) required String salonId,
    @JsonKey(fromJson: looseStringFromJson) required String employeeId,
    @JsonKey(fromJson: looseStringFromJson) required String employeeName,
    @JsonKey(
      fromJson: firestoreDateTimeFromJson,
      toJson: firestoreDateTimeToJson,
    )
    required DateTime periodStart,
    @JsonKey(
      fromJson: firestoreDateTimeFromJson,
      toJson: firestoreDateTimeToJson,
    )
    required DateTime periodEnd,
    @JsonKey(fromJson: looseDoubleFromJson) required double baseAmount,
    @JsonKey(fromJson: looseDoubleFromJson) required double commissionAmount,
    @Default(0) @JsonKey(fromJson: looseDoubleFromJson) double totalSales,
    @Default(0) @JsonKey(fromJson: looseDoubleFromJson) double commissionRate,
    @JsonKey(fromJson: looseDoubleFromJson) required double bonusAmount,
    @JsonKey(fromJson: looseDoubleFromJson) required double deductionAmount,
    @Default(0)
    @JsonKey(fromJson: looseDoubleFromJson)
    double manualDeductionAmount,
    @Default(<PayrollDeductionLine>[])
    @JsonKey(fromJson: PayrollDeductionLine.listFromJson)
    List<PayrollDeductionLine> deductionLines,
    @JsonKey(fromJson: looseDoubleFromJson) required double netAmount,
    @JsonKey(fromJson: _statusFromJson) required String status,
    @Default(0) @JsonKey(fromJson: looseIntFromJson) int month,
    @Default(0) @JsonKey(fromJson: looseIntFromJson) int year,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? notes,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    DateTime? paidAt,
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
  }) = _PayrollRecord;

  String get reportPeriodKey => ReportPeriod.periodKey(year, month);

  factory PayrollRecord.fromJson(Map<String, dynamic> json) =>
      _$PayrollRecordFromJson(_normalizedPayrollRecordJson(json));
}

Map<String, dynamic> _normalizedPayrollRecordJson(Map<String, dynamic> json) {
  final normalized = Map<String, dynamic>.from(json);
  final periodStart =
      FirestoreSerializers.dateTime(json['periodStart']) ??
      DateTime.fromMillisecondsSinceEpoch(0);
  var month = FirestoreSerializers.intValue(json['month']);
  var year = FirestoreSerializers.intValue(json['year']);
  if (month == 0 || year == 0) {
    final fromKey = ReportPeriod.parsePeriodKey(
      FirestoreSerializers.string(json['reportPeriodKey']),
    );
    if (fromKey != null) {
      year = fromKey.$1;
      month = fromKey.$2;
    } else {
      month = ReportPeriod.monthFrom(periodStart);
      year = ReportPeriod.yearFrom(periodStart);
    }
  }
  normalized['periodStart'] = periodStart;
  normalized['month'] = month;
  normalized['year'] = year;
  return normalized;
}

String _statusFromJson(Object? value) =>
    nullableLooseStringFromJson(value) ?? PayrollStatuses.draft;
