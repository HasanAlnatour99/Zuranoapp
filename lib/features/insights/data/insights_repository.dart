import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firestore/firestore_paths.dart';
import '../../../core/firestore/firestore_write_payload.dart';
import 'models/salon_insight.dart';

class InsightsRepository {
  InsightsRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _insights(String salonId) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _firestore.collection(FirestorePaths.salonInsights(salonId));
  }

  /// Newest insight runs first (weekly job writes all three with same [createdAt]).
  Stream<List<SalonInsight>> watchInsights(String salonId, {int limit = 30}) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _insights(salonId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => SalonInsight.fromDocumentJson(d.id, d.data()))
              .toList(),
        );
  }
}
