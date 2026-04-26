import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../../core/constants/violation_types.dart';
import '../../../core/firebase/cloud_functions_region.dart';
import '../../../core/firestore/firestore_paths.dart';
import '../../../core/firestore/firestore_write_payload.dart';
import '../../../core/firestore/report_period.dart';
import 'models/violation.dart';

class ViolationRepository {
  ViolationRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _violations(String salonId) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _firestore.collection(FirestorePaths.salonViolations(salonId));
  }

  Future<String> createViolation(String salonId, Violation violation) async {
    final collection = _violations(salonId);
    final document = violation.id.isEmpty
        ? collection.doc()
        : collection.doc(violation.id);
    final payload = FirestoreWritePayload.withServerTimestampsForCreate({
      ...violation.toJson(),
      'id': document.id,
    });

    await document.set(payload);
    return document.id;
  }

  Future<void> updateViolation(String salonId, Violation violation) {
    return _violations(salonId)
        .doc(violation.id)
        .set(
          FirestoreWritePayload.withServerTimestampForUpdate(
            violation.toJson(),
          ),
          SetOptions(merge: true),
        );
  }

  Stream<List<Violation>> watchViolations(
    String salonId, {
    String? employeeId,
    String? status,
    int limit = 100,
  }) {
    Query<Map<String, dynamic>> query = _violations(
      salonId,
    ).orderBy('occurredAt', descending: true).limit(limit);

    if (employeeId != null && employeeId.isNotEmpty) {
      query = query.where('employeeId', isEqualTo: employeeId);
    }

    if (status != null && status.isNotEmpty) {
      query = query.where('status', isEqualTo: status);
    }

    return query.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => Violation.fromJson(doc.data())).toList(),
    );
  }

  /// Approved payroll deductions not yet tied to a payroll run.
  Future<List<Violation>> getApprovedUnappliedForEmployeeMonth(
    String salonId,
    String employeeId,
    int year,
    int month,
  ) async {
    if (employeeId.isEmpty) {
      return const [];
    }
    final key = ReportPeriod.periodKey(year, month);
    final snapshot = await _violations(salonId)
        .where('employeeId', isEqualTo: employeeId)
        .where('reportPeriodKey', isEqualTo: key)
        .where('status', isEqualTo: ViolationStatuses.approved)
        .get();
    return snapshot.docs
        .map((d) => Violation.fromJson(d.data()))
        .where((v) => v.isUnapplied)
        .toList(growable: false);
  }

  Future<List<Violation>> getPayrollEligibleForEmployeeMonth(
    String salonId,
    String employeeId,
    int year,
    int month, {
    String? includeRunId,
  }) async {
    if (employeeId.isEmpty) {
      return const [];
    }

    final key = ReportPeriod.periodKey(year, month);
    final snapshot = await _violations(salonId)
        .where('employeeId', isEqualTo: employeeId)
        .where('reportPeriodKey', isEqualTo: key)
        .get();

    return snapshot.docs
        .map((doc) => Violation.fromJson(doc.data()))
        .where((violation) {
          if (violation.status == ViolationStatuses.approved &&
              violation.isUnapplied) {
            return true;
          }
          if (includeRunId != null &&
              includeRunId.isNotEmpty &&
              violation.status == ViolationStatuses.applied &&
              violation.payrollRunId == includeRunId) {
            return true;
          }
          return false;
        })
        .toList(growable: false);
  }

  Future<void> applyToPayrollRun(
    String salonId,
    List<String> violationIds, {
    required String payrollRunId,
  }) async {
    if (violationIds.isEmpty) {
      return;
    }
    final batch = _firestore.batch();
    for (final violationId in violationIds.toSet()) {
      final ref = _firestore.doc(
        FirestorePaths.salonViolation(salonId, violationId),
      );
      batch.update(ref, {
        'status': ViolationStatuses.applied,
        'payrollRunId': payrollRunId,
        'appliedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  Future<void> rollbackPayrollRun(
    String salonId,
    List<String> violationIds, {
    required String payrollRunId,
  }) async {
    if (violationIds.isEmpty) {
      return;
    }
    final batch = _firestore.batch();
    for (final violationId in violationIds.toSet()) {
      final ref = _firestore.doc(
        FirestorePaths.salonViolation(salonId, violationId),
      );
      batch.update(ref, {
        'status': ViolationStatuses.approved,
        'payrollRunId': FieldValue.delete(),
        'appliedAt': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  /// Owner/admin review via [violationReview] Cloud Function.
  Future<void> reviewViolation({
    required String salonId,
    required String violationId,
    required bool approve,
    String? notes,
  }) async {
    try {
      final callable = appCloudFunctions().httpsCallable('violationReview');
      await callable.call({
        'salonId': salonId,
        'violationId': violationId,
        'decision': approve ? 'approve' : 'reject',
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      });
    } on FirebaseFunctionsException catch (e) {
      throw StateError(e.message ?? 'violationReview failed');
    }
  }
}
