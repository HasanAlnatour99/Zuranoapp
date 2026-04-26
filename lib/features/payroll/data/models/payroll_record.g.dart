// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PayrollRecord _$PayrollRecordFromJson(Map<String, dynamic> json) =>
    _PayrollRecord(
      id: looseStringFromJson(json['id']),
      salonId: looseStringFromJson(json['salonId']),
      employeeId: looseStringFromJson(json['employeeId']),
      employeeName: looseStringFromJson(json['employeeName']),
      periodStart: firestoreDateTimeFromJson(json['periodStart']),
      periodEnd: firestoreDateTimeFromJson(json['periodEnd']),
      baseAmount: looseDoubleFromJson(json['baseAmount']),
      commissionAmount: looseDoubleFromJson(json['commissionAmount']),
      totalSales: json['totalSales'] == null
          ? 0
          : looseDoubleFromJson(json['totalSales']),
      commissionRate: json['commissionRate'] == null
          ? 0
          : looseDoubleFromJson(json['commissionRate']),
      bonusAmount: looseDoubleFromJson(json['bonusAmount']),
      deductionAmount: looseDoubleFromJson(json['deductionAmount']),
      manualDeductionAmount: json['manualDeductionAmount'] == null
          ? 0
          : looseDoubleFromJson(json['manualDeductionAmount']),
      deductionLines: json['deductionLines'] == null
          ? const <PayrollDeductionLine>[]
          : PayrollDeductionLine.listFromJson(json['deductionLines']),
      netAmount: looseDoubleFromJson(json['netAmount']),
      status: _statusFromJson(json['status']),
      month: json['month'] == null ? 0 : looseIntFromJson(json['month']),
      year: json['year'] == null ? 0 : looseIntFromJson(json['year']),
      notes: nullableLooseStringFromJson(json['notes']),
      paidAt: nullableFirestoreDateTimeFromJson(json['paidAt']),
      createdAt: nullableFirestoreDateTimeFromJson(json['createdAt']),
      updatedAt: nullableFirestoreDateTimeFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$PayrollRecordToJson(_PayrollRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'periodStart': firestoreDateTimeToJson(instance.periodStart),
      'periodEnd': firestoreDateTimeToJson(instance.periodEnd),
      'baseAmount': instance.baseAmount,
      'commissionAmount': instance.commissionAmount,
      'totalSales': instance.totalSales,
      'commissionRate': instance.commissionRate,
      'bonusAmount': instance.bonusAmount,
      'deductionAmount': instance.deductionAmount,
      'manualDeductionAmount': instance.manualDeductionAmount,
      'deductionLines': instance.deductionLines,
      'netAmount': instance.netAmount,
      'status': instance.status,
      'month': instance.month,
      'year': instance.year,
      'notes': instance.notes,
      'paidAt': nullableFirestoreDateTimeToJson(instance.paidAt),
      'createdAt': nullableFirestoreDateTimeToJson(instance.createdAt),
      'updatedAt': nullableFirestoreDateTimeToJson(instance.updatedAt),
    };
