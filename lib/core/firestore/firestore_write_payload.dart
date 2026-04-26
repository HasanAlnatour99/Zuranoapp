import 'package:cloud_firestore/cloud_firestore.dart';

/// Shared [FieldValue.serverTimestamp] patterns for Firestore writes.
abstract final class FirestoreWritePayload {
  static Map<String, dynamic> withServerTimestampsForCreate(
    Map<String, dynamic> data,
  ) {
    return {
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static Map<String, dynamic> withServerTimestampForUpdate(
    Map<String, dynamic> data,
  ) {
    return {...data, 'updatedAt': FieldValue.serverTimestamp()};
  }

  static Map<String, dynamic> touchUpdatedAtOnly() {
    return {'updatedAt': FieldValue.serverTimestamp()};
  }

  static void assertSalonId(String salonId) {
    if (salonId.isEmpty) {
      throw ArgumentError.value(salonId, 'salonId', 'Salon ID is required.');
    }
  }
}
