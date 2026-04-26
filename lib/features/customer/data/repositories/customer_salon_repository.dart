import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/firestore_paths.dart';
import '../models/salon_public_model.dart';

/// Local MVP search over already-public salon rows (name, area, gender, denormalized keywords).
///
/// TODO(Step 16+): When the public salon catalog grows past ~500 documents, add Algolia or
/// Typesense (or Firestore vector search) — local substring search will not scale.
List<SalonPublicModel> filterPublicSalonsByQuery(
  List<SalonPublicModel> items,
  String rawQuery,
) {
  final q = rawQuery.trim().toLowerCase();
  if (q.isEmpty) {
    return items;
  }
  bool tokenMatch(SalonPublicModel s) {
    final name = s.salonName.toLowerCase();
    final area = s.area.toLowerCase();
    if (name.contains(q) || area.contains(q)) {
      return true;
    }
    final gender = s.genderTarget ?? '';
    if (gender.isNotEmpty && gender.contains(q)) {
      return true;
    }
    for (final k in s.searchKeywords) {
      if (k.contains(q)) {
        return true;
      }
    }
    for (final k in s.areaKeywords) {
      if (k.contains(q)) {
        return true;
      }
    }
    for (final k in s.serviceKeywords) {
      if (k.contains(q)) {
        return true;
      }
    }
    return false;
  }

  return items.where(tokenMatch).toList(growable: false);
}

abstract class CustomerSalonRepository {
  Stream<List<SalonPublicModel>> watchPublicSalons();

  /// Same backing stream as [watchPublicSalons], filtered in memory (MVP).
  Stream<List<SalonPublicModel>> searchPublicSalons(String query);

  Future<SalonPublicModel?> getPublicSalonById(String salonId);
}

class FirestoreCustomerSalonRepository implements CustomerSalonRepository {
  FirestoreCustomerSalonRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Query<Map<String, dynamic>> _publicQuery() {
    return _firestore
        .collection(FirestorePaths.publicSalons)
        .where('isPublic', isEqualTo: true)
        .where('isActive', isEqualTo: true)
        .orderBy('ratingAverage', descending: true)
        .limit(50);
  }

  @override
  Stream<List<SalonPublicModel>> watchPublicSalons() {
    return _publicQuery().snapshots().map(
      (snap) =>
          snap.docs.map(SalonPublicModel.fromFirestore).toList(growable: false),
    );
  }

  @override
  Stream<List<SalonPublicModel>> searchPublicSalons(String query) {
    return watchPublicSalons().map(
      (list) => filterPublicSalonsByQuery(list, query),
    );
  }

  @override
  Future<SalonPublicModel?> getPublicSalonById(String salonId) async {
    final id = salonId.trim();
    if (id.isEmpty) {
      return null;
    }
    try {
      final doc = await _firestore.doc(FirestorePaths.publicSalon(id)).get();
      if (!doc.exists) {
        return null;
      }
      return SalonPublicModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        return null;
      }
      rethrow;
    }
  }
}
