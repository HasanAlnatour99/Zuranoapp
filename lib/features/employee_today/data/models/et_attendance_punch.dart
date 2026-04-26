import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../employee_dashboard/domain/enums/attendance_punch_type.dart';

class EtAttendancePunch {
  const EtAttendancePunch({
    required this.id,
    required this.salonId,
    required this.employeeId,
    required this.attendanceDayId,
    required this.type,
    required this.punchTime,
    required this.source,
    required this.insideZone,
    this.latitude,
    this.longitude,
    this.distanceFromSalonMeters,
    this.correctionRequestId,
    this.createdAt,
    required this.createdBy,
  });

  final String id;
  final String salonId;
  final String employeeId;
  final String attendanceDayId;
  final AttendancePunchType type;
  final DateTime punchTime;
  final String source;
  final bool insideZone;
  final double? latitude;
  final double? longitude;
  final double? distanceFromSalonMeters;
  final String? correctionRequestId;
  final DateTime? createdAt;
  final String createdBy;

  factory EtAttendancePunch.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data() ?? {};
    DateTime? ts(String k) => (d[k] as Timestamp?)?.toDate();

    return EtAttendancePunch(
      id: doc.id,
      salonId: d['salonId']?.toString() ?? '',
      employeeId: d['employeeId']?.toString() ?? '',
      attendanceDayId: d['attendanceDayId']?.toString() ?? '',
      type: AttendancePunchType.fromFirestoreString(
        d['type']?.toString() ?? 'punchIn',
      ),
      punchTime: ts('punchTime') ?? DateTime.now(),
      source: d['source']?.toString() ?? 'employee',
      insideZone: d['insideZone'] == true,
      latitude: (d['latitude'] as num?)?.toDouble(),
      longitude: (d['longitude'] as num?)?.toDouble(),
      distanceFromSalonMeters: (d['distanceFromSalonMeters'] as num?)
          ?.toDouble(),
      correctionRequestId: d['correctionRequestId']?.toString(),
      createdAt: ts('createdAt'),
      createdBy: d['createdBy']?.toString() ?? '',
    );
  }
}
