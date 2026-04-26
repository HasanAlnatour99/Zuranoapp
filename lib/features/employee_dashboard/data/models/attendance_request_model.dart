import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/enums/attendance_punch_type.dart';
import '../../domain/enums/attendance_request_status.dart';
import '../../domain/enums/attendance_request_type.dart';

class AttendanceRequestModel {
  const AttendanceRequestModel({
    required this.requestId,
    required this.salonId,
    required this.employeeId,
    required this.employeeUid,
    required this.employeeName,
    required this.attendanceId,
    required this.dateKey,
    required this.requestType,
    required this.requestedPunchType,
    required this.requestedDateTime,
    required this.reason,
    required this.status,
    this.reviewedByUid,
    this.reviewedByName,
    this.reviewedAt,
    this.reviewNote,
    this.createdAt,
    this.updatedAt,
  });

  final String requestId;
  final String salonId;
  final String employeeId;
  final String employeeUid;
  final String employeeName;
  final String attendanceId;
  final String dateKey;
  final String requestType;
  final AttendancePunchType requestedPunchType;
  final DateTime requestedDateTime;
  final String reason;
  final String status;
  final String? reviewedByUid;
  final String? reviewedByName;
  final DateTime? reviewedAt;
  final String? reviewNote;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AttendanceRequestModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data() ?? {};
    return AttendanceRequestModel(
      requestId: doc.id,
      salonId: d['salonId']?.toString() ?? '',
      employeeId: d['employeeId']?.toString() ?? '',
      employeeUid: d['employeeUid']?.toString() ?? '',
      employeeName: d['employeeName']?.toString() ?? '',
      attendanceId: d['attendanceId']?.toString() ?? '',
      dateKey: d['dateKey']?.toString() ?? '',
      requestType:
          d['requestType']?.toString() ?? AttendanceRequestTypes.missingPunch,
      requestedPunchType: AttendancePunchType.fromFirestoreString(
        d['requestedPunchType']?.toString() ?? 'punchOut',
      ),
      requestedDateTime:
          (d['requestedDateTime'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      reason: d['reason']?.toString() ?? '',
      status: d['status']?.toString() ?? AttendanceRequestStatuses.pending,
      reviewedByUid: d['reviewedByUid']?.toString(),
      reviewedByName: d['reviewedByName']?.toString(),
      reviewedAt: (d['reviewedAt'] as Timestamp?)?.toDate(),
      reviewNote: d['reviewNote']?.toString(),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (d['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
