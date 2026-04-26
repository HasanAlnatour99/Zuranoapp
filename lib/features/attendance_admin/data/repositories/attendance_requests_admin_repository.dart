import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/firestore_paths.dart';
import '../../../../core/firestore/firestore_write_payload.dart';
import '../../../employee_dashboard/data/models/attendance_day_model.dart';
import '../../../employee_dashboard/domain/attendance_day_states.dart';
import '../../../employee_dashboard/domain/enums/attendance_punch_type.dart';
import '../../../employee_dashboard/domain/enums/attendance_request_status.dart';
import '../../../employee_dashboard/domain/services/attendance_calculation_service.dart';
import '../../../employee_dashboard/data/models/attendance_request_model.dart';

class AttendanceRequestsAdminRepository {
  AttendanceRequestsAdminRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;
  final AttendanceCalculationService _calc = AttendanceCalculationService();

  CollectionReference<Map<String, dynamic>> _requests(String salonId) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _firestore.collection(
      FirestorePaths.salonAttendanceRequests(salonId),
    );
  }

  Stream<List<AttendanceRequestModel>> watchPending(String salonId) {
    return _requests(salonId)
        .where('status', isEqualTo: AttendanceRequestStatuses.pending)
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots()
        .map(
          (s) => s.docs
              .map(AttendanceRequestModel.fromFirestore)
              .toList(growable: false),
        );
  }

  Future<void> rejectRequest({
    required String salonId,
    required String requestId,
    required String reviewerUid,
    required String reviewerName,
    String? reviewNote,
  }) {
    final ref = _requests(salonId).doc(requestId);
    return ref.update({
      'status': AttendanceRequestStatuses.rejected,
      'reviewedByUid': reviewerUid,
      'reviewedByName': reviewerName,
      'reviewedAt': FieldValue.serverTimestamp(),
      'reviewNote': reviewNote?.trim() ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> approveRequest({
    required String salonId,
    required String requestId,
    required String reviewerUid,
    required String reviewerName,
    String? reviewNote,
  }) async {
    final reqRef = _requests(salonId).doc(requestId);
    await _firestore.runTransaction((tx) async {
      final reqSnap = await tx.get(reqRef);
      if (!reqSnap.exists) {
        throw StateError('Request not found.');
      }
      final req = AttendanceRequestModel.fromFirestore(reqSnap);
      if (req.status != AttendanceRequestStatuses.pending) {
        throw StateError('Request is no longer pending.');
      }

      final attendanceRef = _firestore.doc(
        FirestorePaths.salonAttendanceRecord(salonId, req.attendanceId),
      );
      final attendanceSnap = await tx.get(attendanceRef);
      if (!attendanceSnap.exists) {
        throw StateError('Attendance day not found.');
      }
      final day = AttendanceDayModel.fromFirestore(attendanceSnap);

      final eventsCol = _firestore.collection(
        FirestorePaths.salonAttendanceEventsCollection(
          salonId,
          req.attendanceId,
        ),
      );
      final eventRef = eventsCol.doc();

      final at = Timestamp.fromDate(req.requestedDateTime);
      tx.set(eventRef, {
        'eventId': eventRef.id,
        'salonId': salonId,
        'attendanceId': req.attendanceId,
        'employeeId': req.employeeId,
        'employeeUid': req.employeeUid,
        'type': req.requestedPunchType.name,
        'createdAt': at,
        'location': {'latitude': 0, 'longitude': 0, 'accuracy': 0},
        'zone': {},
        'distanceMeters': 0,
        'insideZone': true,
        'source': 'adminCorrection',
        'deviceInfo': {'platform': 'admin'},
      });

      final patch = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
        'lastEventAt': at,
        'lastEventType': req.requestedPunchType.name,
        'hasCorrectionRequest': false,
        'correctionStatus': AttendanceRequestStatuses.approved,
      };

      switch (req.requestedPunchType) {
        case AttendancePunchType.punchOut:
          if (day.punchInAt == null) {
            throw StateError('Cannot approve punch out without punch in.');
          }
          final worked = _calc.calculateWorkedMinutes(
            punchInAt: day.punchInAt!,
            punchOutAt: req.requestedDateTime,
            totalBreakMinutes: day.totalBreakMinutes,
          );
          patch['punchOutAt'] = at;
          patch['status'] = AttendanceDayStatuses.checkedOut;
          patch['currentState'] = AttendanceCurrentStates.finished;
          patch['totalWorkedMinutes'] = worked;
          break;
        case AttendancePunchType.punchIn:
          patch['punchInAt'] = at;
          patch['status'] = AttendanceDayStatuses.checkedIn;
          patch['currentState'] = day.punchOutAt == null
              ? AttendanceCurrentStates.working
              : AttendanceCurrentStates.finished;
          break;
        case AttendancePunchType.breakOut:
        case AttendancePunchType.breakIn:
          throw UnsupportedError(
            'Break corrections are not supported in this version.',
          );
      }

      tx.set(attendanceRef, patch, SetOptions(merge: true));

      tx.update(reqRef, {
        'status': AttendanceRequestStatuses.approved,
        'reviewedByUid': reviewerUid,
        'reviewedByName': reviewerName,
        'reviewedAt': FieldValue.serverTimestamp(),
        'reviewNote': reviewNote?.trim() ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
