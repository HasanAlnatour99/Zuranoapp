import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/firestore/firestore_json_helpers.dart';
import '../payroll_constants.dart';

part 'employee_element_entry_model.freezed.dart';
part 'employee_element_entry_model.g.dart';

@freezed
abstract class EmployeeElementEntryModel with _$EmployeeElementEntryModel {
  const EmployeeElementEntryModel._();

  const factory EmployeeElementEntryModel({
    @JsonKey(fromJson: looseStringFromJson) required String id,
    @JsonKey(fromJson: looseStringFromJson) required String employeeId,
    @JsonKey(fromJson: looseStringFromJson) required String employeeName,
    @JsonKey(fromJson: looseStringFromJson) required String elementCode,
    @JsonKey(fromJson: looseStringFromJson) required String elementName,
    @JsonKey(fromJson: _classificationFromJson) required String classification,
    @JsonKey(fromJson: _recurrenceTypeFromJson) required String recurrenceType,
    @Default(0) @JsonKey(fromJson: looseDoubleFromJson) double amount,
    @JsonKey(fromJson: nullableLooseDoubleFromJson) double? percentage,
    @JsonKey(
      fromJson: nullableStringDynamicMapFromJson,
      toJson: nullableStringDynamicMapToJson,
    )
    Map<String, dynamic>? formulaConfig,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    DateTime? startDate,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    DateTime? endDate,
    @JsonKey(fromJson: nullableLooseIntFromJson) int? payrollYear,
    @JsonKey(fromJson: nullableLooseIntFromJson) int? payrollMonth,
    @Default(PayrollEntryStatuses.active)
    @JsonKey(fromJson: _statusFromJson)
    String status,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? note,
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
  }) = _EmployeeElementEntryModel;

  bool get isActive => status == PayrollEntryStatuses.active;

  bool appliesToPeriod({
    required DateTime periodStart,
    required DateTime periodEnd,
    required int year,
    required int month,
  }) {
    if (!isActive) {
      return false;
    }

    if (recurrenceType == PayrollRecurrenceTypes.nonrecurring) {
      return payrollYear == year && payrollMonth == month;
    }

    final startsBeforeEnd = startDate == null || !startDate!.isAfter(periodEnd);
    final endsAfterStart = endDate == null || !endDate!.isBefore(periodStart);
    return startsBeforeEnd && endsAfterStart;
  }

  factory EmployeeElementEntryModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeElementEntryModelFromJson(json);
}

String _classificationFromJson(Object? value) =>
    nullableLooseStringFromJson(value) ?? PayrollElementClassifications.earning;

String _recurrenceTypeFromJson(Object? value) =>
    nullableLooseStringFromJson(value) ?? PayrollRecurrenceTypes.recurring;

String _statusFromJson(Object? value) =>
    nullableLooseStringFromJson(value) ?? PayrollEntryStatuses.active;
