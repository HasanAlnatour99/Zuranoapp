// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_element_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmployeeElementEntryModel _$EmployeeElementEntryModelFromJson(
  Map<String, dynamic> json,
) => _EmployeeElementEntryModel(
  id: looseStringFromJson(json['id']),
  employeeId: looseStringFromJson(json['employeeId']),
  employeeName: looseStringFromJson(json['employeeName']),
  elementCode: looseStringFromJson(json['elementCode']),
  elementName: looseStringFromJson(json['elementName']),
  classification: _classificationFromJson(json['classification']),
  recurrenceType: _recurrenceTypeFromJson(json['recurrenceType']),
  amount: json['amount'] == null ? 0 : looseDoubleFromJson(json['amount']),
  percentage: nullableLooseDoubleFromJson(json['percentage']),
  formulaConfig: nullableStringDynamicMapFromJson(json['formulaConfig']),
  startDate: nullableFirestoreDateTimeFromJson(json['startDate']),
  endDate: nullableFirestoreDateTimeFromJson(json['endDate']),
  payrollYear: nullableLooseIntFromJson(json['payrollYear']),
  payrollMonth: nullableLooseIntFromJson(json['payrollMonth']),
  status: json['status'] == null
      ? PayrollEntryStatuses.active
      : _statusFromJson(json['status']),
  note: nullableLooseStringFromJson(json['note']),
  createdAt: nullableFirestoreDateTimeFromJson(json['createdAt']),
  updatedAt: nullableFirestoreDateTimeFromJson(json['updatedAt']),
);

Map<String, dynamic> _$EmployeeElementEntryModelToJson(
  _EmployeeElementEntryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'employeeId': instance.employeeId,
  'employeeName': instance.employeeName,
  'elementCode': instance.elementCode,
  'elementName': instance.elementName,
  'classification': instance.classification,
  'recurrenceType': instance.recurrenceType,
  'amount': instance.amount,
  'percentage': instance.percentage,
  'formulaConfig': nullableStringDynamicMapToJson(instance.formulaConfig),
  'startDate': nullableFirestoreDateTimeToJson(instance.startDate),
  'endDate': nullableFirestoreDateTimeToJson(instance.endDate),
  'payrollYear': instance.payrollYear,
  'payrollMonth': instance.payrollMonth,
  'status': instance.status,
  'note': instance.note,
  'createdAt': nullableFirestoreDateTimeToJson(instance.createdAt),
  'updatedAt': nullableFirestoreDateTimeToJson(instance.updatedAt),
};
