import 'package:cloud_firestore/cloud_firestore.dart';

class EtPolicyReadable {
  const EtPolicyReadable({
    required this.salonId,
    required this.title,
    required this.summary,
    required this.employeeRules,
    required this.violationRules,
    required this.correctionRules,
    required this.generatedBy,
    this.generatedAt,
    this.updatedAt,
  });

  final String salonId;
  final String title;
  final String summary;
  final List<String> employeeRules;
  final List<String> violationRules;
  final List<String> correctionRules;
  final String generatedBy;
  final DateTime? generatedAt;
  final DateTime? updatedAt;

  factory EtPolicyReadable.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data() ?? {};
    List<String> listOf(String key) {
      final v = d[key];
      if (v is List) {
        return v.map((e) => e.toString()).toList(growable: false);
      }
      return const [];
    }

    DateTime? ts(String k) => (d[k] as Timestamp?)?.toDate();

    return EtPolicyReadable(
      salonId: d['salonId']?.toString() ?? '',
      title: d['title']?.toString() ?? '',
      summary: d['summary']?.toString() ?? '',
      employeeRules: listOf('employeeRules'),
      violationRules: listOf('violationRules'),
      correctionRules: listOf('correctionRules'),
      generatedBy: d['generatedBy']?.toString() ?? '',
      generatedAt: ts('generatedAt'),
      updatedAt: ts('updatedAt'),
    );
  }
}
