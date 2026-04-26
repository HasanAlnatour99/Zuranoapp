import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/sale_reporting.dart';
import '../../../../core/firestore/firestore_json_helpers.dart'
    show
        falseBoolFromJson,
        firestoreDateTimeFromJson,
        firestoreDateTimeToJson,
        looseDoubleFromJson,
        looseIntFromJson,
        looseStringFromJson,
        nullableFirestoreDateTimeFromJson,
        nullableFirestoreDateTimeToJson,
        nullableLooseStringFromJson;
import '../../../../core/firestore/firestore_serializers.dart';
import '../../../../core/firestore/report_period.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

@freezed
abstract class Expense with _$Expense {
  const Expense._();

  const factory Expense({
    @JsonKey(fromJson: looseStringFromJson) required String id,
    @JsonKey(fromJson: looseStringFromJson) required String salonId,
    @JsonKey(fromJson: looseStringFromJson) required String title,
    @JsonKey(fromJson: looseStringFromJson) required String category,
    @JsonKey(fromJson: looseDoubleFromJson) required double amount,
    @JsonKey(
      fromJson: firestoreDateTimeFromJson,
      toJson: firestoreDateTimeToJson,
    )
    required DateTime incurredAt,
    @JsonKey(fromJson: looseStringFromJson) required String createdByUid,
    @JsonKey(fromJson: looseStringFromJson) required String createdByName,
    @Default(0) @JsonKey(fromJson: looseIntFromJson) int reportYear,
    @Default(0) @JsonKey(fromJson: looseIntFromJson) int reportMonth,
    @Default(SalePaymentMethods.cash)
    @JsonKey(fromJson: _paymentMethodFromJson)
    String paymentMethod,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? linkedEmployeeId,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? linkedSupplierName,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? vendorName,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? notes,
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
    @Default(false) @JsonKey(fromJson: falseBoolFromJson) bool isDeleted,
  }) = _Expense;

  String get reportPeriodKey => ReportPeriod.periodKey(reportYear, reportMonth);
  DateTime get expenseDate => incurredAt;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(_normalizedExpenseJson(json));
}

Map<String, dynamic> _normalizedExpenseJson(Map<String, dynamic> json) {
  final incurredAt =
      FirestoreSerializers.dateTime(json['incurredAt']) ??
      FirestoreSerializers.dateTime(json['expenseDate']) ??
      DateTime.fromMillisecondsSinceEpoch(0);
  var reportYear = FirestoreSerializers.intValue(json['reportYear']);
  var reportMonth = FirestoreSerializers.intValue(json['reportMonth']);
  if (reportYear == 0 || reportMonth == 0) {
    final fromKey = ReportPeriod.parsePeriodKey(
      FirestoreSerializers.string(json['reportPeriodKey']),
    );
    if (fromKey != null) {
      reportYear = fromKey.$1;
      reportMonth = fromKey.$2;
    } else {
      reportYear = ReportPeriod.yearFrom(incurredAt);
      reportMonth = ReportPeriod.monthFrom(incurredAt);
    }
  }

  final normalized = Map<String, dynamic>.from(json);
  normalized['incurredAt'] = incurredAt;
  normalized['reportYear'] = reportYear;
  normalized['reportMonth'] = reportMonth;
  normalized['linkedSupplierName'] =
      FirestoreSerializers.string(json['linkedSupplierName']) ??
      FirestoreSerializers.string(json['vendorName']);
  return normalized;
}

String _paymentMethodFromJson(Object? value) =>
    nullableLooseStringFromJson(value) ?? SalePaymentMethods.cash;
