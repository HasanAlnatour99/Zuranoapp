import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/firestore_json_helpers.dart';

/// `salons/{salonId}/payroll_adjustments/{adjustmentId}` (owner/admin; used by payroll engine).
class PayrollAdjustmentModel {
  const PayrollAdjustmentModel({
    required this.id,
    required this.salonId,
    required this.employeeId,
    required this.year,
    required this.month,
    required this.type,
    required this.elementCode,
    required this.title,
    required this.amount,
    required this.reason,
    required this.status,
  });

  final String id;
  final String salonId;
  final String employeeId;
  final int year;
  final int month;
  final String type;
  final String elementCode;
  final String title;
  final double amount;
  final String reason;
  final String status;

  factory PayrollAdjustmentModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data() ?? {};
    return PayrollAdjustmentModel(
      id: doc.id,
      salonId: looseStringFromJson(d['salonId']),
      employeeId: looseStringFromJson(d['employeeId']),
      year: looseIntFromJson(d['year']),
      month: looseIntFromJson(d['month']),
      type: looseStringFromJson(d['type']),
      elementCode: looseStringFromJson(d['elementCode']),
      title: looseStringFromJson(d['title']),
      amount: looseDoubleFromJson(d['amount']),
      reason: looseStringFromJson(d['reason']),
      status: looseStringFromJson(d['status']),
    );
  }
}
