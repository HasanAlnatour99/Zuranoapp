import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/firestore/firestore_json_helpers.dart';
import '../payroll_constants.dart';

part 'payroll_element_model.freezed.dart';
part 'payroll_element_model.g.dart';

@freezed
abstract class PayrollElementModel with _$PayrollElementModel {
  const factory PayrollElementModel({
    @JsonKey(fromJson: looseStringFromJson) required String id,
    @JsonKey(fromJson: looseStringFromJson) required String code,
    @JsonKey(fromJson: looseStringFromJson) required String name,
    @JsonKey(fromJson: _classificationFromJson) required String classification,
    @JsonKey(fromJson: _recurrenceTypeFromJson) required String recurrenceType,
    @JsonKey(fromJson: _calculationMethodFromJson)
    required String calculationMethod,
    @Default(0) @JsonKey(fromJson: looseDoubleFromJson) double defaultAmount,
    @Default(false) @JsonKey(fromJson: falseBoolFromJson) bool isSystemElement,
    @Default(true) @JsonKey(fromJson: trueBoolFromJson) bool isActive,
    @Default(true) @JsonKey(fromJson: trueBoolFromJson) bool affectsNetPay,
    @Default(true) @JsonKey(fromJson: trueBoolFromJson) bool visibleOnPayslip,
    @Default(0) @JsonKey(fromJson: looseIntFromJson) int displayOrder,
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
  }) = _PayrollElementModel;

  factory PayrollElementModel.fromJson(Map<String, dynamic> json) =>
      _$PayrollElementModelFromJson(json);
}

String _classificationFromJson(Object? value) =>
    nullableLooseStringFromJson(value) ?? PayrollElementClassifications.earning;

String _recurrenceTypeFromJson(Object? value) =>
    nullableLooseStringFromJson(value) ?? PayrollRecurrenceTypes.recurring;

String _calculationMethodFromJson(Object? value) =>
    nullableLooseStringFromJson(value) ?? PayrollCalculationMethods.fixed;
