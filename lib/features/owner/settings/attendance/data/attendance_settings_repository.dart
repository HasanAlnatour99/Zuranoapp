import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/firestore/firestore_paths.dart';
import '../../../../../core/firestore/firestore_write_payload.dart';
import '../domain/models/attendance_settings_model.dart';

/// Single repository for the unified attendance settings document at
/// `salons/{salonId}/settings/attendance`.
///
/// Replaces the previous duplicated repositories
/// (`SalonAttendanceSettingsRepository`,
/// `EmployeeTodayAttendanceRepository.watchAttendanceSettings`) for write
/// access. Reads stay backward-compatible via [AttendanceSettingsModel.fromMap]
/// which understands both new and legacy field names.
class AttendanceSettingsRepository {
  AttendanceSettingsRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _ref(String salonId) {
    return _firestore.doc(FirestorePaths.salonAttendanceSettingsDoc(salonId));
  }

  /// Streams the unified document. When the document does not exist, the
  /// stream emits [AttendanceSettingsModel.defaults] so the UI never has to
  /// handle a `null` settings state.
  Stream<AttendanceSettingsModel> watchSettings(String salonId) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _ref(salonId).snapshots().map((snap) {
      if (!snap.exists) {
        return AttendanceSettingsModel.defaults(salonId);
      }
      return AttendanceSettingsModel.fromFirestore(salonId, snap);
    });
  }

  /// One-shot read. Falls back to defaults if the document is missing or
  /// any field is malformed.
  Future<AttendanceSettingsModel> getSettings(String salonId) async {
    FirestoreWritePayload.assertSalonId(salonId);
    final snap = await _ref(salonId).get();
    if (!snap.exists) {
      return AttendanceSettingsModel.defaults(salonId);
    }
    return AttendanceSettingsModel.fromFirestore(salonId, snap);
  }

  /// Persists the unified document.
  ///
  /// - Always merges (no full overwrite).
  /// - Always stamps `updatedAt` + `updatedBy`.
  /// - Stamps `createdAt` only when the document does not yet exist.
  Future<void> saveSettings({
    required String salonId,
    required AttendanceSettingsModel settings,
    required String updatedBy,
  }) async {
    FirestoreWritePayload.assertSalonId(salonId);
    final ref = _ref(salonId);
    final snap = await ref.get();
    final isNew = !snap.exists;

    final payload = <String, dynamic>{
      ...settings.toFirestoreMergeMap(),
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
      if (isNew) 'createdAt': FieldValue.serverTimestamp(),
    };

    await ref.set(payload, SetOptions(merge: true));
  }
}
