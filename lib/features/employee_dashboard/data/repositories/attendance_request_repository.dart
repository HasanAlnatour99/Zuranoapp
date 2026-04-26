import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/firestore_paths.dart';
import '../../../../core/firestore/firestore_write_payload.dart';
import '../../domain/enums/attendance_punch_type.dart';
import '../../domain/enums/attendance_request_status.dart';
import '../../domain/enums/attendance_request_type.dart';
import '../models/attendance_request_model.dart';

class AttendanceRequestRepository {
  AttendanceRequestRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String salonId) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _firestore.collection(
      FirestorePaths.salonAttendanceRequests(salonId),
    );
  }

  static String compactDateKey(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y$m$day';
  }

  Future<bool> hasPendingDuplicate({
    required String salonId,
    required String employeeId,
    required String dateKey,
    required AttendancePunchType requestedPunchType,
  }) async {
    final q = await _col(salonId)
        .where('employeeId', isEqualTo: employeeId)
        .where('status', isEqualTo: AttendanceRequestStatuses.pending)
        .limit(50)
        .get();
    return q.docs.any((d) {
      final m = d.data();
      return m['dateKey'] == dateKey &&
          m['requestedPunchType'] == requestedPunchType.name;
    });
  }

  Future<String> submitRequest({
    required String salonId,
    required String employeeId,
    required String employeeUid,
    required String employeeName,
    required String attendanceId,
    required String dateKey,
    required AttendancePunchType requestedPunchType,
    required DateTime requestedDateTime,
    required String reason,
    String requestType = AttendanceRequestTypes.missingPunch,
  }) async {
    FirestoreWritePayload.assertSalonId(salonId);
    final doc = _col(salonId).doc();
    await doc.set({
      'requestId': doc.id,
      'salonId': salonId,
      'employeeId': employeeId,
      'employeeUid': employeeUid,
      'employeeName': employeeName,
      'attendanceId': attendanceId,
      'dateKey': dateKey,
      'requestType': requestType,
      'requestedPunchType': requestedPunchType.name,
      'requestedDateTime': Timestamp.fromDate(requestedDateTime),
      'reason': reason.trim(),
      'status': AttendanceRequestStatuses.pending,
      'reviewedByUid': null,
      'reviewedByName': null,
      'reviewedAt': null,
      'reviewNote': null,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': employeeUid,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': employeeUid,
    });
    return doc.id;
  }

  Stream<List<AttendanceRequestModel>> watchMyRequests({
    required String salonId,
    required String employeeId,
    int limit = 50,
  }) {
    return _col(salonId)
        .where('employeeId', isEqualTo: employeeId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => AttendanceRequestModel.fromFirestore(d))
              .toList(growable: false),
        );
  }

  Future<int> countPendingForEmployee({
    required String salonId,
    required String employeeId,
  }) async {
    final q = await _col(salonId)
        .where('employeeId', isEqualTo: employeeId)
        .where('status', isEqualTo: AttendanceRequestStatuses.pending)
        .limit(25)
        .get();
    return q.docs.length;
  }
}
