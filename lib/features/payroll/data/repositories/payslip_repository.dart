import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/firestore_json_helpers.dart';
import '../../../../core/firestore/firestore_paths.dart';
import '../../../../core/firestore/firestore_write_payload.dart';
import '../models/payroll_ai_summary_model.dart';
import '../models/payslip_line_model.dart';
import '../models/payslip_model.dart';

class PayslipRepository {
  PayslipRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _payslips(String salonId) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _firestore.collection(FirestorePaths.salonPayslips(salonId));
  }

  /// Visible approved/paid payslip for [year]/[month], with ordered lines.
  Stream<PayslipModel?> watchEmployeePayslip({
    required String salonId,
    required String employeeId,
    required int year,
    required int month,
  }) {
    final sid = salonId.trim();
    final eid = employeeId.trim();
    if (sid.isEmpty || eid.isEmpty) {
      return Stream<PayslipModel?>.value(null);
    }

    return _payslips(sid)
        .where('employeeId', isEqualTo: eid)
        .where('employeeVisible', isEqualTo: true)
        .where('year', isEqualTo: year)
        .where('month', isEqualTo: month)
        .limit(1)
        .snapshots()
        .asyncMap((snapshot) async {
          if (snapshot.docs.isEmpty) {
            return null;
          }
          final doc = snapshot.docs.first;
          final linesSnap = await doc.reference
              .collection(FirestorePaths.payslipLines)
              .orderBy('displayOrder')
              .get();
          final lines = linesSnap.docs
              .map(PayslipLineModel.fromFirestore)
              .toList(growable: false);
          return PayslipModel.fromFirestore(doc, lines);
        });
  }

  Stream<List<PayslipModel>> watchRecentEmployeePayslips({
    required String salonId,
    required String employeeId,
    int limit = 6,
  }) {
    final sid = salonId.trim();
    final eid = employeeId.trim();
    if (sid.isEmpty || eid.isEmpty) {
      return Stream<List<PayslipModel>>.value(const []);
    }

    return _payslips(sid)
        .where('employeeId', isEqualTo: eid)
        .where('employeeVisible', isEqualTo: true)
        .orderBy('periodStart', descending: true)
        .limit(limit)
        .snapshots()
        .asyncMap((snapshot) async {
          final out = <PayslipModel>[];
          for (final doc in snapshot.docs) {
            final linesSnap = await doc.reference
                .collection(FirestorePaths.payslipLines)
                .orderBy('displayOrder')
                .get();
            final lines = linesSnap.docs
                .map(PayslipLineModel.fromFirestore)
                .toList(growable: false);
            out.add(PayslipModel.fromFirestore(doc, lines));
          }
          return out;
        });
  }

  Future<PayslipModel?> getPayslipForEmployee({
    required String salonId,
    required String employeeId,
    required String payslipId,
  }) async {
    final sid = salonId.trim();
    final eid = employeeId.trim();
    final pid = payslipId.trim();
    if (sid.isEmpty || eid.isEmpty || pid.isEmpty) {
      return null;
    }
    final doc = await _payslips(sid).doc(pid).get();
    if (!doc.exists) {
      return null;
    }
    final data = doc.data();
    if (data == null) {
      return null;
    }
    if (looseStringFromJson(data['employeeId']) != eid) {
      return null;
    }
    if (trueBoolFromJson(data['employeeVisible']) != true) {
      return null;
    }
    final linesSnap = await doc.reference
        .collection(FirestorePaths.payslipLines)
        .orderBy('displayOrder')
        .get();
    final lines = linesSnap.docs
        .map(PayslipLineModel.fromFirestore)
        .toList(growable: false);
    return PayslipModel.fromFirestore(doc, lines);
  }

  Stream<PayrollAiSummaryModel?> watchSalaryNotes({
    required String salonId,
    required String payslipId,
  }) {
    final sid = salonId.trim();
    final pid = payslipId.trim();
    if (sid.isEmpty || pid.isEmpty) {
      return Stream<PayrollAiSummaryModel?>.value(null);
    }
    return _firestore
        .doc(
          '${FirestorePaths.salonPayslip(sid, pid)}/${FirestorePaths.payslipAiAnalysis}/main',
        )
        .snapshots()
        .map((doc) {
          if (!doc.exists) {
            return null;
          }
          return PayrollAiSummaryModel.fromFirestore(doc);
        });
  }
}
