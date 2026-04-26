import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/firestore_paths.dart';
import '../models/customer_booking_settings_model.dart';

class CustomerBookingSettingsRepository {
  CustomerBookingSettingsRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String salonId) =>
      _firestore.doc(FirestorePaths.salonCustomerBookingSettingsDoc(salonId));

  Stream<CustomerBookingSettingsModel> watchSettings(String salonId) {
    final id = salonId.trim();
    if (id.isEmpty) {
      return Stream.value(CustomerBookingSettingsModel.defaults(''));
    }
    return _doc(id).snapshots().map((snap) {
      if (!snap.exists) {
        return CustomerBookingSettingsModel.defaults(id);
      }
      return CustomerBookingSettingsModel.fromFirestore(snap);
    });
  }

  Future<CustomerBookingSettingsModel> getSettings(String salonId) async {
    final id = salonId.trim();
    if (id.isEmpty) {
      return CustomerBookingSettingsModel.defaults('');
    }
    final snap = await _doc(id).get();
    if (!snap.exists) {
      return CustomerBookingSettingsModel.defaults(id);
    }
    return CustomerBookingSettingsModel.fromFirestore(snap);
  }

  Future<void> saveSettings({
    required String salonId,
    required CustomerBookingSettingsModel settings,
    required String updatedByUid,
  }) async {
    final id = salonId.trim();
    if (id.isEmpty) {
      throw ArgumentError.value(salonId, 'salonId', 'Salon id is required.');
    }
    if (updatedByUid.trim().isEmpty) {
      throw ArgumentError.value(updatedByUid, 'updatedByUid', 'User id is required.');
    }
    final err = settings.validationErrorKey();
    if (err != null) {
      throw CustomerBookingSettingsValidationException(err);
    }

    final ts = FieldValue.serverTimestamp();
    final snap = await _doc(id).get();
    final payload = settings
        .copyWith(salonId: id)
        .toFirestoreWrite(
          timestamp: ts,
          updatedByUid: updatedByUid.trim(),
          includeCreated: !snap.exists,
        );

    final batch = _firestore.batch();
    batch.set(_doc(id), payload, SetOptions(merge: true));
    batch.set(
      _firestore.doc(FirestorePaths.publicSalon(id)),
      <String, dynamic>{
        'customerBookingSettings': settings.copyWith(salonId: id).toPublicSalonSettingsMap(),
      },
      SetOptions(merge: true),
    );
    await batch.commit();
  }
}

class CustomerBookingSettingsValidationException implements Exception {
  const CustomerBookingSettingsValidationException(this.code);

  final String code;
}
