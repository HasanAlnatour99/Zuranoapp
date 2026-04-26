import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firestore/firestore_paths.dart';
import '../../../core/firestore/firestore_write_payload.dart';
import 'models/barber_metrics.dart';

class BarberMetricsRepository {
  BarberMetricsRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String salonId) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _firestore.collection(FirestorePaths.salonBarberMetrics(salonId));
  }

  /// Fetches metrics for [employeeIds] using batched `whereIn` (max 10 ids per query).
  Future<Map<String, BarberMetrics>> getForEmployees(
    String salonId,
    List<String> employeeIds,
  ) async {
    FirestoreWritePayload.assertSalonId(salonId);
    if (employeeIds.isEmpty) {
      return {};
    }
    final unique = employeeIds.toSet().toList();
    final out = <String, BarberMetrics>{};
    const chunk = 10;
    for (var i = 0; i < unique.length; i += chunk) {
      final end = i + chunk <= unique.length ? i + chunk : unique.length;
      final part = unique.sublist(i, end);
      if (part.isEmpty) {
        continue;
      }
      final snap = await _col(
        salonId,
      ).where(FieldPath.documentId, whereIn: part).get();
      for (final doc in snap.docs) {
        out[doc.id] = BarberMetrics.fromDocumentJson(
          doc.data(),
          documentId: doc.id,
        );
      }
    }
    return out;
  }
}
