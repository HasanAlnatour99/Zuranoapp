// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'violation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Violation _$ViolationFromJson(Map<String, dynamic> json) => _Violation(
  id: looseStringFromJson(json['id']),
  salonId: looseStringFromJson(json['salonId']),
  employeeId: looseStringFromJson(json['employeeId']),
  employeeName: nullableLooseStringFromJson(json['employeeName']),
  bookingId: nullableLooseStringFromJson(json['bookingId']),
  sourceType: _sourceTypeFromJson(json['sourceType']),
  violationType: looseStringFromJson(json['violationType']),
  status: _statusFromJson(json['status']),
  occurredAt: firestoreDateTimeFromJson(json['occurredAt']),
  reportYear: json['reportYear'] == null
      ? 0
      : looseIntFromJson(json['reportYear']),
  reportMonth: json['reportMonth'] == null
      ? 0
      : looseIntFromJson(json['reportMonth']),
  minutesLate: nullableLooseIntFromJson(json['minutesLate']),
  amount: json['amount'] == null ? 0 : looseDoubleFromJson(json['amount']),
  percent: nullableLooseDoubleFromJson(json['percent']),
  currency: nullableLooseStringFromJson(json['currency']),
  ruleSnapshot: nullableStringDynamicMapFromJson(json['ruleSnapshot']),
  notes: nullableLooseStringFromJson(json['notes']),
  createdByUid: nullableLooseStringFromJson(json['createdByUid']),
  createdByRole: nullableLooseStringFromJson(json['createdByRole']),
  approvedByUid: nullableLooseStringFromJson(json['approvedByUid']),
  approvedAt: nullableFirestoreDateTimeFromJson(json['approvedAt']),
  payrollRunId: nullableLooseStringFromJson(json['payrollRunId']),
  appliedAt: nullableFirestoreDateTimeFromJson(json['appliedAt']),
  createdAt: nullableFirestoreDateTimeFromJson(json['createdAt']),
  updatedAt: nullableFirestoreDateTimeFromJson(json['updatedAt']),
);

Map<String, dynamic> _$ViolationToJson(_Violation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'bookingId': instance.bookingId,
      'sourceType': instance.sourceType,
      'violationType': instance.violationType,
      'status': instance.status,
      'occurredAt': firestoreDateTimeToJson(instance.occurredAt),
      'reportYear': instance.reportYear,
      'reportMonth': instance.reportMonth,
      'minutesLate': instance.minutesLate,
      'amount': instance.amount,
      'percent': instance.percent,
      'currency': instance.currency,
      'ruleSnapshot': nullableStringDynamicMapToJson(instance.ruleSnapshot),
      'notes': instance.notes,
      'createdByUid': instance.createdByUid,
      'createdByRole': instance.createdByRole,
      'approvedByUid': instance.approvedByUid,
      'approvedAt': nullableFirestoreDateTimeToJson(instance.approvedAt),
      'payrollRunId': instance.payrollRunId,
      'appliedAt': nullableFirestoreDateTimeToJson(instance.appliedAt),
      'createdAt': nullableFirestoreDateTimeToJson(instance.createdAt),
      'updatedAt': nullableFirestoreDateTimeToJson(instance.updatedAt),
    };
