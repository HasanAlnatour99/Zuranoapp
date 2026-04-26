import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firestore/firestore_paths.dart';
import '../../../core/firestore/firestore_write_payload.dart';
import 'models/salon_sales_settings.dart';

class SalonSalesSettingsRepository {
  SalonSalesSettingsRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String salonId) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _firestore.doc(FirestorePaths.salonSalesSettingsDoc(salonId));
  }

  Stream<SalonSalesSettings> watchSettings(String salonId) {
    return _doc(
      salonId,
    ).snapshots().map((snap) => SalonSalesSettings.fromMap(snap.data()));
  }
}
