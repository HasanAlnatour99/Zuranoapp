import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/firestore_json_helpers.dart';

/// `salons/{salonId}/payslips/{payslipId}/aiAnalysis/main`
class PayrollAiSummaryModel {
  const PayrollAiSummaryModel({
    required this.salonId,
    required this.payslipId,
    required this.employeeId,
    required this.summary,
    required this.highlights,
    required this.warnings,
    this.generatedAt,
  });

  final String salonId;
  final String payslipId;
  final String employeeId;
  final String summary;
  final List<String> highlights;
  final List<String> warnings;
  final DateTime? generatedAt;

  factory PayrollAiSummaryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data() ?? {};
    final h = d['highlights'];
    final w = d['warnings'];
    return PayrollAiSummaryModel(
      salonId: looseStringFromJson(d['salonId']),
      payslipId: looseStringFromJson(d['payslipId']),
      employeeId: looseStringFromJson(d['employeeId']),
      summary: looseStringFromJson(d['summary']),
      highlights: h is List
          ? h.map((e) => e.toString()).where((e) => e.isNotEmpty).toList()
          : const [],
      warnings: w is List
          ? w.map((e) => e.toString()).where((e) => e.isNotEmpty).toList()
          : const [],
      generatedAt: nullableFirestoreDateTimeFromJson(d['generatedAt']),
    );
  }
}
