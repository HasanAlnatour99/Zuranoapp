import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/firestore_paths.dart';
import '../../../../core/firestore/firestore_write_payload.dart';
import '../models/attendance_day_model.dart';
import '../models/attendance_event_model.dart';

/// Read-only employee attendance repository: today/day stream + history list.
///
/// The legacy `submitPunch` flow was replaced by the unified employee_today
/// punch pipeline that consumes `AttendanceSettingsModel`. This file no longer
/// owns punch writes; only reads.
class EmployeeAttendanceRepository {
  EmployeeAttendanceRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  static String compactDateKey(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y$m$day';
  }

  static String attendanceDocumentId(String employeeId, String dateKey) =>
      '${employeeId}_$dateKey';

  DocumentReference<Map<String, dynamic>> _dayRef(
    String salonId,
    String attendanceId,
  ) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _firestore.doc(
      FirestorePaths.salonAttendanceRecord(salonId, attendanceId),
    );
  }

  Stream<AttendanceDayModel?> watchDay({
    required String salonId,
    required String employeeId,
    required DateTime day,
  }) {
    final dk = compactDateKey(day);
    final id = attendanceDocumentId(employeeId, dk);
    return _dayRef(salonId, id).snapshots().map((s) {
      if (!s.exists) {
        return null;
      }
      return AttendanceDayModel.fromFirestore(s);
    });
  }

  Stream<List<AttendanceEventModel>> watchDayEvents({
    required String salonId,
    required String employeeId,
    required DateTime day,
  }) {
    final dk = compactDateKey(day);
    final id = attendanceDocumentId(employeeId, dk);
    return _firestore
        .collection(FirestorePaths.salonAttendanceEventsCollection(salonId, id))
        .orderBy('createdAt', descending: false)
        .limit(64)
        .snapshots()
        .map(
          (s) => s.docs
              .map(AttendanceEventModel.fromFirestore)
              .toList(growable: false),
        );
  }

  Future<List<AttendanceDayModel>> listRecentDays({
    required String salonId,
    required String employeeId,
    int limit = 31,
  }) async {
    FirestoreWritePayload.assertSalonId(salonId);
    final q = await _firestore
        .collection(FirestorePaths.salonAttendance(salonId))
        .where('employeeId', isEqualTo: employeeId)
        .orderBy('dateKey', descending: true)
        .limit(limit)
        .get();
    return q.docs.map(AttendanceDayModel.fromFirestore).toList(growable: false);
  }
}
