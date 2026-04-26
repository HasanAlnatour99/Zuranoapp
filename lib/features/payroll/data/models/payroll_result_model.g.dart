// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PayrollResultModel _$PayrollResultModelFromJson(Map<String, dynamic> json) =>
    _PayrollResultModel(
      id: looseStringFromJson(json['id']),
      payrollRunId: looseStringFromJson(json['payrollRunId']),
      employeeId: looseStringFromJson(json['employeeId']),
      employeeName: looseStringFromJson(json['employeeName']),
      elementCode: looseStringFromJson(json['elementCode']),
      elementName: looseStringFromJson(json['elementName']),
      classification: _classificationFromJson(json['classification']),
      recurrenceType: _recurrenceTypeFromJson(json['recurrenceType']),
      amount: looseDoubleFromJson(json['amount']),
      quantity: nullableLooseDoubleFromJson(json['quantity']),
      rate: nullableLooseDoubleFromJson(json['rate']),
      sourceType: _sourceTypeFromJson(json['sourceType']),
      sourceRefIds: json['sourceRefIds'] == null
          ? const <String>[]
          : stringListFromJson(json['sourceRefIds']),
      visibleOnPayslip: json['visibleOnPayslip'] == null
          ? true
          : trueBoolFromJson(json['visibleOnPayslip']),
      displayOrder: json['displayOrder'] == null
          ? 0
          : looseIntFromJson(json['displayOrder']),
      calculationSource: nullableLooseStringFromJson(json['calculationSource']),
      createdAt: nullableFirestoreDateTimeFromJson(json['createdAt']),
    );

Map<String, dynamic> _$PayrollResultModelToJson(_PayrollResultModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payrollRunId': instance.payrollRunId,
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'elementCode': instance.elementCode,
      'elementName': instance.elementName,
      'classification': instance.classification,
      'recurrenceType': instance.recurrenceType,
      'amount': instance.amount,
      'quantity': instance.quantity,
      'rate': instance.rate,
      'sourceType': instance.sourceType,
      'sourceRefIds': instance.sourceRefIds,
      'visibleOnPayslip': instance.visibleOnPayslip,
      'displayOrder': instance.displayOrder,
      'calculationSource': instance.calculationSource,
      'createdAt': nullableFirestoreDateTimeToJson(instance.createdAt),
    };
