// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Expense _$ExpenseFromJson(Map<String, dynamic> json) => _Expense(
  id: looseStringFromJson(json['id']),
  salonId: looseStringFromJson(json['salonId']),
  title: looseStringFromJson(json['title']),
  category: looseStringFromJson(json['category']),
  amount: looseDoubleFromJson(json['amount']),
  incurredAt: firestoreDateTimeFromJson(json['incurredAt']),
  createdByUid: looseStringFromJson(json['createdByUid']),
  createdByName: looseStringFromJson(json['createdByName']),
  reportYear: json['reportYear'] == null
      ? 0
      : looseIntFromJson(json['reportYear']),
  reportMonth: json['reportMonth'] == null
      ? 0
      : looseIntFromJson(json['reportMonth']),
  paymentMethod: json['paymentMethod'] == null
      ? SalePaymentMethods.cash
      : _paymentMethodFromJson(json['paymentMethod']),
  linkedEmployeeId: nullableLooseStringFromJson(json['linkedEmployeeId']),
  linkedSupplierName: nullableLooseStringFromJson(json['linkedSupplierName']),
  vendorName: nullableLooseStringFromJson(json['vendorName']),
  notes: nullableLooseStringFromJson(json['notes']),
  createdAt: nullableFirestoreDateTimeFromJson(json['createdAt']),
  updatedAt: nullableFirestoreDateTimeFromJson(json['updatedAt']),
  isDeleted: json['isDeleted'] == null
      ? false
      : falseBoolFromJson(json['isDeleted']),
);

Map<String, dynamic> _$ExpenseToJson(_Expense instance) => <String, dynamic>{
  'id': instance.id,
  'salonId': instance.salonId,
  'title': instance.title,
  'category': instance.category,
  'amount': instance.amount,
  'incurredAt': firestoreDateTimeToJson(instance.incurredAt),
  'createdByUid': instance.createdByUid,
  'createdByName': instance.createdByName,
  'reportYear': instance.reportYear,
  'reportMonth': instance.reportMonth,
  'paymentMethod': instance.paymentMethod,
  'linkedEmployeeId': instance.linkedEmployeeId,
  'linkedSupplierName': instance.linkedSupplierName,
  'vendorName': instance.vendorName,
  'notes': instance.notes,
  'createdAt': nullableFirestoreDateTimeToJson(instance.createdAt),
  'updatedAt': nullableFirestoreDateTimeToJson(instance.updatedAt),
  'isDeleted': instance.isDeleted,
};
