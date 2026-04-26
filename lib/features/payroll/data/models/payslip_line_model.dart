import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/firestore_json_helpers.dart';

/// `salons/{salonId}/payslips/{payslipId}/lines/{lineId}`
class PayslipLineModel {
  const PayslipLineModel({
    required this.id,
    required this.salonId,
    required this.payslipId,
    required this.employeeId,
    required this.elementCode,
    required this.elementName,
    required this.type,
    required this.amount,
    required this.sourceType,
    this.sourceRef,
    required this.displayOrder,
    this.createdAt,
  });

  final String id;
  final String salonId;
  final String payslipId;
  final String employeeId;
  final String elementCode;
  final String elementName;

  /// `earning` | `deduction`
  final String type;
  final double amount;
  final String sourceType;
  final String? sourceRef;
  final int displayOrder;
  final DateTime? createdAt;

  bool get isEarning => type == 'earning';

  factory PayslipLineModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data() ?? {};
    return PayslipLineModel(
      id: doc.id,
      salonId: looseStringFromJson(d['salonId']),
      payslipId: looseStringFromJson(d['payslipId']),
      employeeId: looseStringFromJson(d['employeeId']),
      elementCode: looseStringFromJson(d['elementCode']),
      elementName: looseStringFromJson(d['elementName']),
      type: looseStringFromJson(d['type']),
      amount: looseDoubleFromJson(d['amount']),
      sourceType: looseStringFromJson(d['sourceType']),
      sourceRef: nullableLooseStringFromJson(d['sourceRef']),
      displayOrder: looseIntFromJson(d['displayOrder']),
      createdAt: nullableFirestoreDateTimeFromJson(d['createdAt']),
    );
  }
}
