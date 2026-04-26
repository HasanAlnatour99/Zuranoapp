import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/firestore_paths.dart';
import '../../../../core/firestore/firestore_write_payload.dart';
import '../models/et_policy_readable.dart';

class AttendancePolicyRepository {
  AttendancePolicyRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _ref(String salonId) =>
      _firestore.doc(FirestorePaths.salonAttendancePolicyReadableDoc(salonId));

  Stream<EtPolicyReadable?> watchReadablePolicy(String salonId) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _ref(salonId).snapshots().map((s) {
      if (!s.exists) {
        return null;
      }
      return EtPolicyReadable.fromFirestore(s);
    });
  }
}
