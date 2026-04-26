import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/firestore/firestore_json_helpers.dart';
import '../../../../core/firestore/firestore_serializers.dart';
import '../../../../core/firestore/report_period.dart';
import '../payroll_constants.dart';

part 'payroll_run_model.freezed.dart';
part 'payroll_run_model.g.dart';

@freezed
abstract class PayrollRunModel with _$PayrollRunModel {
  const PayrollRunModel._();

  const factory PayrollRunModel({
    @JsonKey(fromJson: looseStringFromJson) required String id,
    @JsonKey(fromJson: _runTypeFromJson) required String runType,
    @JsonKey(fromJson: looseStringFromJson) required String salonId,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? employeeId,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? employeeName,
    @Default(0) @JsonKey(fromJson: looseIntFromJson) int year,
    @Default(0) @JsonKey(fromJson: looseIntFromJson) int month,
    @Default(PayrollRunStatuses.draft)
    @JsonKey(fromJson: _statusFromJson)
    String status,
    @Default(0) @JsonKey(fromJson: looseDoubleFromJson) double totalEarnings,
    @Default(0) @JsonKey(fromJson: looseDoubleFromJson) double totalDeductions,
    @Default(0) @JsonKey(fromJson: looseDoubleFromJson) double netPay,
    @Default(<String>[])
    @JsonKey(fromJson: stringListFromJson)
    List<String> employeeIds,
    @Default(0) @JsonKey(fromJson: looseIntFromJson) int employeeCount,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? createdBy,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    DateTime? createdAt,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    DateTime? approvedAt,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? approvedBy,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    DateTime? paidAt,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? paidBy,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    DateTime? updatedAt,
  }) = _PayrollRunModel;

  String get reportPeriodKey => ReportPeriod.periodKey(year, month);

  bool get isQuickPay => runType == PayrollRunTypes.quickPay;

  factory PayrollRunModel.fromJson(Map<String, dynamic> json) =>
      _$PayrollRunModelFromJson(_normalizedPayrollRunJson(json));
}

Map<String, dynamic> _normalizedPayrollRunJson(Map<String, dynamic> json) {
  final normalized = Map<String, dynamic>.from(json);
  var year = FirestoreSerializers.intValue(json['year']);
  var month = FirestoreSerializers.intValue(json['month']);
  if (year == 0 || month == 0) {
    final period = ReportPeriod.parsePeriodKey(
      FirestoreSerializers.string(json['reportPeriodKey']),
    );
    if (period != null) {
      year = period.$1;
      month = period.$2;
    }
  }
  final employeeIds = stringListFromJson(json['employeeIds']);
  normalized['year'] = year;
  normalized['month'] = month;
  normalized['employeeIds'] = employeeIds;
  normalized['employeeCount'] ??= employeeIds.length;
  return normalized;
}

String _runTypeFromJson(Object? value) =>
    nullableLooseStringFromJson(value) ?? PayrollRunTypes.payrollRun;

String _statusFromJson(Object? value) =>
    nullableLooseStringFromJson(value) ?? PayrollRunStatuses.draft;
