import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/firestore/firestore_json_helpers.dart';
import '../payroll_constants.dart';

part 'payroll_result_model.freezed.dart';
part 'payroll_result_model.g.dart';

@freezed
abstract class PayrollResultModel with _$PayrollResultModel {
  const factory PayrollResultModel({
    @JsonKey(fromJson: looseStringFromJson) required String id,
    @JsonKey(fromJson: looseStringFromJson) required String payrollRunId,
    @JsonKey(fromJson: looseStringFromJson) required String employeeId,
    @JsonKey(fromJson: looseStringFromJson) required String employeeName,
    @JsonKey(fromJson: looseStringFromJson) required String elementCode,
    @JsonKey(fromJson: looseStringFromJson) required String elementName,
    @JsonKey(fromJson: _classificationFromJson) required String classification,
    @JsonKey(fromJson: _recurrenceTypeFromJson) required String recurrenceType,
    @JsonKey(fromJson: looseDoubleFromJson) required double amount,
    @JsonKey(fromJson: nullableLooseDoubleFromJson) double? quantity,
    @JsonKey(fromJson: nullableLooseDoubleFromJson) double? rate,
    @JsonKey(fromJson: _sourceTypeFromJson) required String sourceType,
    @Default(<String>[])
    @JsonKey(fromJson: stringListFromJson)
    List<String> sourceRefIds,
    @Default(true) @JsonKey(fromJson: trueBoolFromJson) bool visibleOnPayslip,
    @Default(0) @JsonKey(fromJson: looseIntFromJson) int displayOrder,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? calculationSource,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    DateTime? createdAt,
  }) = _PayrollResultModel;

  factory PayrollResultModel.fromJson(Map<String, dynamic> json) =>
      _$PayrollResultModelFromJson(json);
}

String _classificationFromJson(Object? value) =>
    nullableLooseStringFromJson(value) ?? PayrollElementClassifications.earning;

String _recurrenceTypeFromJson(Object? value) =>
    nullableLooseStringFromJson(value) ?? PayrollRecurrenceTypes.recurring;

String _sourceTypeFromJson(Object? value) =>
    nullableLooseStringFromJson(value) ?? PayrollResultSourceTypes.manual;
