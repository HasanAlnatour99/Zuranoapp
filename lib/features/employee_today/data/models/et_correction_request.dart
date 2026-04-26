import 'package:cloud_firestore/cloud_firestore.dart';

class EtCorrectionRequest {
  const EtCorrectionRequest({
    required this.id,
    required this.salonId,
    required this.employeeId,
    required this.employeeName,
    required this.attendanceDayId,
    required this.dateKey,
    required this.requestedPunchType,
    required this.requestedPunchTime,
    required this.reason,
    required this.status,
    this.reviewedBy,
    this.reviewedByName,
    this.reviewedAt,
    this.reviewNote,
    this.createdPunchId,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String salonId;
  final String employeeId;
  final String employeeName;
  final String attendanceDayId;
  final String dateKey;
  final String requestedPunchType;
  final DateTime requestedPunchTime;
  final String reason;
  final String status;
  final String? reviewedBy;
  final String? reviewedByName;
  final DateTime? reviewedAt;
  final String? reviewNote;
  final String? createdPunchId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory EtCorrectionRequest.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data() ?? {};
    DateTime? ts(String k) => (d[k] as Timestamp?)?.toDate();

    return EtCorrectionRequest(
      id: doc.id,
      salonId: d['salonId']?.toString() ?? '',
      employeeId: d['employeeId']?.toString() ?? '',
      employeeName: d['employeeName']?.toString() ?? '',
      attendanceDayId: d['attendanceDayId']?.toString() ?? '',
      dateKey: d['dateKey']?.toString() ?? '',
      requestedPunchType: d['requestedPunchType']?.toString() ?? '',
      requestedPunchTime: ts('requestedPunchTime') ?? DateTime.now(),
      reason: d['reason']?.toString() ?? '',
      status: d['status']?.toString() ?? 'pending',
      reviewedBy: d['reviewedBy']?.toString(),
      reviewedByName: d['reviewedByName']?.toString(),
      reviewedAt: ts('reviewedAt'),
      reviewNote: d['reviewNote']?.toString(),
      createdPunchId: d['createdPunchId']?.toString(),
      createdAt: ts('createdAt'),
      updatedAt: ts('updatedAt'),
    );
  }
}
