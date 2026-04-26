import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/payroll_statuses.dart';
import '../../../core/firestore/firestore_paths.dart';
import '../../../core/firestore/firestore_write_payload.dart';
import 'models/payroll_record.dart';

class PayrollRepository {
  PayrollRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _payroll(String salonId) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _firestore.collection(FirestorePaths.salonPayroll(salonId));
  }

  Future<String> createPayrollRecord(
    String salonId,
    PayrollRecord payrollRecord,
  ) async {
    final collection = _payroll(salonId);
    final document = payrollRecord.id.isEmpty
        ? collection.doc()
        : collection.doc(payrollRecord.id);
    final payload = FirestoreWritePayload.withServerTimestampsForCreate({
      ...payrollRecord.toJson(),
      'id': document.id,
    });

    await document.set(payload);
    return document.id;
  }

  Future<void> updatePayrollRecord(
    String salonId,
    PayrollRecord payrollRecord,
  ) {
    return _payroll(salonId)
        .doc(payrollRecord.id)
        .set(
          FirestoreWritePayload.withServerTimestampForUpdate(
            payrollRecord.toJson(),
          ),
          SetOptions(merge: true),
        );
  }

  Future<PayrollRecord?> getPayrollRecord(
    String salonId,
    String payrollId,
  ) async {
    if (payrollId.isEmpty) {
      throw ArgumentError.value(
        payrollId,
        'payrollId',
        'Payroll ID is required.',
      );
    }
    final snapshot = await _payroll(salonId).doc(payrollId).get();
    final data = snapshot.data();
    if (!snapshot.exists || data == null) {
      return null;
    }
    return PayrollRecord.fromJson(data);
  }

  /// Non-voided payroll for the employee and calendar month, if any (latest by [periodStart]).
  Future<PayrollRecord?> findOpenPayrollForEmployeeMonth(
    String salonId,
    String employeeId,
    int year,
    int month,
  ) async {
    if (employeeId.isEmpty) {
      throw ArgumentError.value(
        employeeId,
        'employeeId',
        'Employee ID is required.',
      );
    }
    final snapshot = await _payroll(salonId)
        .where('employeeId', isEqualTo: employeeId)
        .where('year', isEqualTo: year)
        .where('month', isEqualTo: month)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final records = snapshot.docs
        .map((doc) => PayrollRecord.fromJson(doc.data()))
        .where((r) => r.status != PayrollStatuses.voided)
        .toList(growable: false);

    if (records.isEmpty) {
      return null;
    }

    records.sort((a, b) => b.periodStart.compareTo(a.periodStart));
    return records.first;
  }

  Future<void> markPayrollAsPaid(String salonId, String payrollId) async {
    if (payrollId.isEmpty) {
      throw ArgumentError.value(
        payrollId,
        'payrollId',
        'Payroll ID is required.',
      );
    }
    await _payroll(salonId).doc(payrollId).set({
      'status': PayrollStatuses.paid,
      'paidAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<List<PayrollRecord>> watchPayroll(
    String salonId, {
    String? employeeId,
    String? status,
    int? year,
    int? month,
    int limit = 36,
  }) {
    Query<Map<String, dynamic>> query = _payroll(
      salonId,
    ).orderBy('periodStart', descending: true).limit(limit);

    if (employeeId != null && employeeId.isNotEmpty) {
      query = query.where('employeeId', isEqualTo: employeeId);
    }

    if (status != null && status.isNotEmpty) {
      query = query.where('status', isEqualTo: status);
    }

    if (year != null && month != null) {
      query = query
          .where('year', isEqualTo: year)
          .where('month', isEqualTo: month);
    }

    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => PayrollRecord.fromJson(doc.data()))
          .toList(),
    );
  }
}
