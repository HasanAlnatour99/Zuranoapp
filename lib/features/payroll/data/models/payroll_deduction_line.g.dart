// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_deduction_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PayrollDeductionLine _$PayrollDeductionLineFromJson(
  Map<String, dynamic> json,
) => _PayrollDeductionLine(
  kind: _kindFromJson(json['kind']),
  amount: looseDoubleFromJson(json['amount']),
  violationId: nullableLooseStringFromJson(json['violationId']),
  bookingId: nullableLooseStringFromJson(json['bookingId']),
  label: nullableLooseStringFromJson(json['label']),
);

Map<String, dynamic> _$PayrollDeductionLineToJson(
  _PayrollDeductionLine instance,
) => <String, dynamic>{
  'kind': instance.kind,
  'amount': instance.amount,
  'violationId': instance.violationId,
  'bookingId': instance.bookingId,
  'label': instance.label,
};
