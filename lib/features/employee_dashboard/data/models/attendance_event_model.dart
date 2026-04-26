import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/enums/attendance_punch_type.dart';

class AttendanceEventLocation {
  const AttendanceEventLocation({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });

  final double latitude;
  final double longitude;
  final double accuracy;

  factory AttendanceEventLocation.fromMap(Map<String, dynamic>? m) {
    if (m == null) {
      return const AttendanceEventLocation(
        latitude: 0,
        longitude: 0,
        accuracy: 0,
      );
    }
    return AttendanceEventLocation(
      latitude: (m['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (m['longitude'] as num?)?.toDouble() ?? 0,
      accuracy: (m['accuracy'] as num?)?.toDouble() ?? 0,
    );
  }
}

class AttendanceEventModel {
  const AttendanceEventModel({
    required this.eventId,
    required this.salonId,
    required this.attendanceId,
    required this.employeeId,
    required this.employeeUid,
    required this.type,
    required this.createdAt,
    required this.location,
    required this.distanceMeters,
    required this.insideZone,
    required this.source,
  });

  final String eventId;
  final String salonId;
  final String attendanceId;
  final String employeeId;
  final String employeeUid;
  final AttendancePunchType type;
  final DateTime createdAt;
  final AttendanceEventLocation location;
  final double distanceMeters;
  final bool insideZone;
  final String source;

  factory AttendanceEventModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data() ?? {};
    return AttendanceEventModel(
      eventId: doc.id,
      salonId: d['salonId']?.toString() ?? '',
      attendanceId: d['attendanceId']?.toString() ?? '',
      employeeId: d['employeeId']?.toString() ?? '',
      employeeUid: d['employeeUid']?.toString() ?? '',
      type: AttendancePunchType.fromFirestoreString(
        d['type']?.toString() ?? 'punchIn',
      ),
      createdAt:
          (d['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      location: AttendanceEventLocation.fromMap(
        d['location'] is Map
            ? Map<String, dynamic>.from(d['location'] as Map)
            : null,
      ),
      distanceMeters: (d['distanceMeters'] as num?)?.toDouble() ?? 0,
      insideZone: d['insideZone'] == true,
      source: d['source']?.toString() ?? 'employeeApp',
    );
  }
}
