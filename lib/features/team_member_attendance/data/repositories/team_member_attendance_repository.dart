import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/firestore_paths.dart';
import '../../../../core/firestore/firestore_write_payload.dart';
import '../models/attendance_correction_request_model.dart';
import '../models/attendance_record_model.dart';
import '../models/attendance_summary_model.dart';

class TeamMemberAttendanceRepository {
  TeamMemberAttendanceRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _attendanceRef(String salonId) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _firestore.collection(FirestorePaths.salonAttendance(salonId));
  }

  CollectionReference<Map<String, dynamic>> _correctionsRef(String salonId) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _firestore.collection(
      FirestorePaths.salonAttendanceCorrections(salonId),
    );
  }

  CollectionReference<Map<String, dynamic>> _auditLogsRef(String salonId) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _firestore.collection(FirestorePaths.salonAuditLogs(salonId));
  }

  String attendanceDocId({required String employeeId, required DateTime date}) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${employeeId}_$y$m$d';
  }

  int dateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return int.parse('$y$m$d');
  }

  String monthKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$y-$m';
  }

  /// ISO week label `yyyy-'W'ww` based on the calendar day in local time.
  static String weekKey(DateTime date) {
    final local = DateTime(date.year, date.month, date.day);
    final thursday = local.add(Duration(days: 4 - local.weekday));
    var y = thursday.year;
    var jan4 = DateTime(y, 1, 4);
    var week1Thursday = jan4.add(Duration(days: 4 - jan4.weekday));
    var diffDays = thursday.difference(week1Thursday).inDays;
    if (diffDays < 0) {
      y--;
      jan4 = DateTime(y, 1, 4);
      week1Thursday = jan4.add(Duration(days: 4 - jan4.weekday));
      diffDays = thursday.difference(week1Thursday).inDays;
    }
    final week = 1 + diffDays ~/ 7;
    return '$y-W${week.toString().padLeft(2, '0')}';
  }

  Stream<AttendanceRecordModel?> watchTodayAttendance({
    required String salonId,
    required String employeeId,
    required DateTime today,
  }) {
    final dayStart = DateTime(today.year, today.month, today.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    return _attendanceRef(salonId)
        .where('employeeId', isEqualTo: employeeId)
        .where('workDate', isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart))
        .where('workDate', isLessThan: Timestamp.fromDate(dayEnd))
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return AttendanceRecordModel.fromDoc(snapshot.docs.first);
        });
  }

  Stream<List<AttendanceRecordModel>> watchRecentAttendance({
    required String salonId,
    required String employeeId,
    int limit = 10,
  }) {
    return _attendanceRef(salonId)
        .where('employeeId', isEqualTo: employeeId)
        .orderBy('workDate', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(AttendanceRecordModel.fromDoc)
              .toList(growable: false),
        );
  }

  Stream<List<AttendanceCorrectionRequestModel>> watchCorrectionRequests({
    required String salonId,
    required String employeeId,
    int limit = 10,
  }) {
    return _correctionsRef(salonId)
        .where('employeeId', isEqualTo: employeeId)
        .orderBy('dateKey', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(AttendanceCorrectionRequestModel.fromDoc)
              .toList(growable: false),
        );
  }

  Future<AttendanceSummaryModel> getSummary({
    required String salonId,
    required String employeeId,
    required DateTime now,
  }) async {
    final snapshot = await _attendanceRef(salonId)
        .where('employeeId', isEqualTo: employeeId)
        .orderBy('workDate', descending: true)
        .limit(120)
        .get();

    final records = snapshot.docs.map(AttendanceRecordModel.fromDoc).toList();

    final weekStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - DateTime.monday));

    bool isInCurrentMonth(AttendanceRecordModel r) {
      final parsed = DateTime.tryParse(r.attendanceDate);
      if (parsed != null) {
        return parsed.year == now.year && parsed.month == now.month;
      }
      return r.monthKey == monthKey(now);
    }

    final monthRecords = records.where(isInCurrentMonth).toList();

    final lateCount = monthRecords
        .where((r) => r.lateMinutes > 0 || r.status == 'late')
        .length;
    final missingCheckoutCount = monthRecords
        .where((r) => r.missingCheckout)
        .length;

    final todayDay = DateTime(now.year, now.month, now.day);
    final weekPresentDates = <String>{};
    for (final r in records) {
      final recordDate = DateTime.tryParse(r.attendanceDate);
      if (recordDate == null) continue;
      final day = DateTime(recordDate.year, recordDate.month, recordDate.day);
      final inWeek = !day.isBefore(weekStart) && !day.isAfter(todayDay);
      if (!inWeek) continue;
      final eligible =
          r.status == 'present' ||
          r.status == 'late' ||
          r.status == 'manual' ||
          (r.checkInAt != null && r.status != 'absent');
      if (eligible) {
        weekPresentDates.add(r.attendanceDate);
      }
    }
    final weeklyPresentDays = weekPresentDates.length;

    final requestsSnapshot = await _correctionsRef(salonId)
        .where('employeeId', isEqualTo: employeeId)
        .where('status', isEqualTo: 'pending')
        .get();

    return AttendanceSummaryModel(
      weeklyPresentDays: weeklyPresentDays,
      monthlyLateCount: lateCount,
      monthlyMissingCheckoutCount: missingCheckoutCount,
      pendingCorrectionRequests: requestsSnapshot.docs.length,
    );
  }

  Future<void> upsertManualAttendance({
    required String salonId,
    required String employeeId,
    required String employeeName,
    required DateTime attendanceDate,
    required DateTime? checkInAt,
    required DateTime? checkOutAt,
    required String status,
    required int lateMinutes,
    required int earlyExitMinutes,
    required bool missingCheckout,
    required String notes,
    required String performedBy,
    required String performedByRole,
  }) async {
    final id = attendanceDocId(employeeId: employeeId, date: attendanceDate);
    final docRef = _attendanceRef(salonId).doc(id);
    final day = DateTime(
      attendanceDate.year,
      attendanceDate.month,
      attendanceDate.day,
    );
    final attendanceDateIso = day.toIso8601String().substring(0, 10);

    await _firestore.runTransaction((transaction) async {
      final oldDoc = await transaction.get(docRef);
      final oldValue = oldDoc.data();

      final data = <String, dynamic>{
        'salonId': salonId,
        'employeeId': employeeId,
        'employeeName': employeeName,
        'attendanceDate': attendanceDateIso,
        'dateKey': dateKey(day),
        'weekKey': weekKey(day),
        'monthKey': monthKey(day),
        'workDate': Timestamp.fromDate(day),
        'checkInAt': checkInAt == null ? null : Timestamp.fromDate(checkInAt),
        'checkOutAt': checkOutAt == null
            ? null
            : Timestamp.fromDate(checkOutAt),
        'status': status,
        'source': 'admin_manual',
        'lateMinutes': lateMinutes,
        'minutesLate': lateMinutes,
        'earlyExitMinutes': earlyExitMinutes,
        'missingCheckout': missingCheckout,
        'needsCorrection': missingCheckout,
        'manualEdited': true,
        'notes': notes,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': performedBy,
      };

      if (!oldDoc.exists) {
        data['createdAt'] = FieldValue.serverTimestamp();
        data['createdBy'] = performedBy;
      }

      transaction.set(docRef, data, SetOptions(merge: true));

      final auditRef = _auditLogsRef(salonId).doc();
      transaction.set(auditRef, {
        'salonId': salonId,
        'entityType': 'attendance',
        'entityId': id,
        'employeeId': employeeId,
        'action': oldDoc.exists
            ? 'manual_attendance_update'
            : 'manual_attendance_create',
        'performedBy': performedBy,
        'performedByRole': performedByRole,
        'oldValue': oldValue ?? {},
        'newValue': data,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> reviewCorrectionRequest({
    required String salonId,
    required String requestId,
    required String attendanceId,
    required bool approved,
    required String reviewNote,
    required String reviewedBy,
    required String reviewedByRole,
  }) async {
    final requestRef = _correctionsRef(salonId).doc(requestId);
    final attendanceRef = _attendanceRef(salonId).doc(attendanceId);

    await _firestore.runTransaction((transaction) async {
      final requestDoc = await transaction.get(requestRef);
      if (!requestDoc.exists) {
        throw StateError('Attendance correction request does not exist.');
      }

      final requestData = requestDoc.data()!;
      if (requestData['status'] != 'pending') {
        throw StateError('This request is already reviewed.');
      }

      transaction.update(requestRef, {
        'status': approved ? 'approved' : 'rejected',
        'reviewNote': reviewNote,
        'reviewedBy': reviewedBy,
        'reviewedByRole': reviewedByRole,
        'reviewedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (approved) {
        final updateData = <String, dynamic>{
          'source': 'correction_approved',
          'manualEdited': true,
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': reviewedBy,
        };

        final reqIn = requestData['requestedCheckInAt'];
        if (reqIn is Timestamp) {
          updateData['checkInAt'] = reqIn;
        }

        final reqOut = requestData['requestedCheckOutAt'];
        if (reqOut is Timestamp) {
          updateData['checkOutAt'] = reqOut;
          updateData['missingCheckout'] = false;
          updateData['needsCorrection'] = false;
        }

        transaction.set(attendanceRef, updateData, SetOptions(merge: true));
      }

      final auditRef = _auditLogsRef(salonId).doc();
      transaction.set(auditRef, {
        'salonId': salonId,
        'entityType': 'attendance_correction',
        'entityId': requestId,
        'employeeId': requestData['employeeId'],
        'action': approved ? 'correction_approved' : 'correction_rejected',
        'performedBy': reviewedBy,
        'performedByRole': reviewedByRole,
        'oldValue': requestData,
        'newValue': {
          'status': approved ? 'approved' : 'rejected',
          'reviewNote': reviewNote,
        },
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
