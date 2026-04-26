// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_element_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PayrollElementModel _$PayrollElementModelFromJson(Map<String, dynamic> json) =>
    _PayrollElementModel(
      id: looseStringFromJson(json['id']),
      code: looseStringFromJson(json['code']),
      name: looseStringFromJson(json['name']),
      classification: _classificationFromJson(json['classification']),
      recurrenceType: _recurrenceTypeFromJson(json['recurrenceType']),
      calculationMethod: _calculationMethodFromJson(json['calculationMethod']),
      defaultAmount: json['defaultAmount'] == null
          ? 0
          : looseDoubleFromJson(json['defaultAmount']),
      isSystemElement: json['isSystemElement'] == null
          ? false
          : falseBoolFromJson(json['isSystemElement']),
      isActive: json['isActive'] == null
          ? true
          : trueBoolFromJson(json['isActive']),
      affectsNetPay: json['affectsNetPay'] == null
          ? true
          : trueBoolFromJson(json['affectsNetPay']),
      visibleOnPayslip: json['visibleOnPayslip'] == null
          ? true
          : trueBoolFromJson(json['visibleOnPayslip']),
      displayOrder: json['displayOrder'] == null
          ? 0
          : looseIntFromJson(json['displayOrder']),
      createdAt: nullableFirestoreDateTimeFromJson(json['createdAt']),
      updatedAt: nullableFirestoreDateTimeFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$PayrollElementModelToJson(
  _PayrollElementModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'classification': instance.classification,
  'recurrenceType': instance.recurrenceType,
  'calculationMethod': instance.calculationMethod,
  'defaultAmount': instance.defaultAmount,
  'isSystemElement': instance.isSystemElement,
  'isActive': instance.isActive,
  'affectsNetPay': instance.affectsNetPay,
  'visibleOnPayslip': instance.visibleOnPayslip,
  'displayOrder': instance.displayOrder,
  'createdAt': nullableFirestoreDateTimeToJson(instance.createdAt),
  'updatedAt': nullableFirestoreDateTimeToJson(instance.updatedAt),
};
