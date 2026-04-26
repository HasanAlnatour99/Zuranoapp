import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/attendance_day_states.dart';

class AttendanceDayModel {
  const AttendanceDayModel({
    required this.attendanceId,
    required this.salonId,
    required this.employeeId,
    required this.employeeUid,
    required this.employeeName,
    required this.dateKey,
    required this.workDate,
    required this.status,
    required this.currentState,
    this.punchInAt,
    this.punchOutAt,
    required this.totalBreakMinutes,
    required this.totalWorkedMinutes,
    required this.lastEventType,
    this.lastEventAt,
    required this.insideZoneAtLastPunch,
    required this.distanceMetersAtLastPunch,
    required this.hasCorrectionRequest,
    this.correctionStatus,
    this.lastBreakOutAt,
    this.lastBreakInAt,
    this.createdAt,
    this.updatedAt,
  });

  final String attendanceId;
  final String salonId;
  final String employeeId;
  final String employeeUid;
  final String employeeName;
  final String dateKey;
  final DateTime workDate;
  final String status;
  final String currentState;
  final DateTime? punchInAt;
  final DateTime? punchOutAt;
  final int totalBreakMinutes;
  final int totalWorkedMinutes;
  final String lastEventType;
  final DateTime? lastEventAt;
  final bool insideZoneAtLastPunch;
  final double distanceMetersAtLastPunch;
  final bool hasCorrectionRequest;
  final String? correctionStatus;
  final DateTime? lastBreakOutAt;
  final DateTime? lastBreakInAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AttendanceDayModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data() ?? {};
    DateTime? ts(String key) => (d[key] as Timestamp?)?.toDate();

    return AttendanceDayModel(
      attendanceId: doc.id,
      salonId: d['salonId']?.toString() ?? '',
      employeeId: d['employeeId']?.toString() ?? '',
      employeeUid: d['employeeUid']?.toString() ?? '',
      employeeName: d['employeeName']?.toString() ?? '',
      dateKey: d['dateKey']?.toString() ?? '',
      workDate: ts('workDate') ?? DateTime.fromMillisecondsSinceEpoch(0),
      status: d['status']?.toString() ?? AttendanceDayStatuses.notStarted,
      currentState:
          d['currentState']?.toString() ?? AttendanceCurrentStates.notStarted,
      punchInAt: ts('punchInAt'),
      punchOutAt: ts('punchOutAt'),
      totalBreakMinutes: (d['totalBreakMinutes'] as num?)?.toInt() ?? 0,
      totalWorkedMinutes: (d['totalWorkedMinutes'] as num?)?.toInt() ?? 0,
      lastEventType: d['lastEventType']?.toString() ?? '',
      lastEventAt: ts('lastEventAt'),
      insideZoneAtLastPunch: d['insideZoneAtLastPunch'] == true,
      distanceMetersAtLastPunch:
          (d['distanceMetersAtLastPunch'] as num?)?.toDouble() ?? 0,
      hasCorrectionRequest: d['hasCorrectionRequest'] == true,
      correctionStatus: d['correctionStatus']?.toString(),
      lastBreakOutAt: ts('lastBreakOutAt'),
      lastBreakInAt: ts('lastBreakInAt'),
      createdAt: ts('createdAt'),
      updatedAt: ts('updatedAt'),
    );
  }
}
