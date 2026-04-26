import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../core/firestore/firestore_paths.dart';
import '../../bookings/data/models/booking.dart';
import '../../sales/data/models/sale.dart';
import 'models/customer.dart';
import 'models/customer_note.dart';

class CustomerRepository {
  CustomerRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _customersRef(String salonId) {
    return _firestore
        .collection(FirestorePaths.salons)
        .doc(salonId)
        .collection(FirestorePaths.customers);
  }

  CollectionReference<Map<String, dynamic>> _salesRef(String salonId) {
    return _firestore.collection(FirestorePaths.salonSales(salonId));
  }

  CollectionReference<Map<String, dynamic>> _bookingsRef(String salonId) {
    return _firestore.collection(FirestorePaths.salonBookings(salonId));
  }

  CollectionReference<Map<String, dynamic>> _customerNotes(String salonId) {
    return _firestore.collection(
      '${FirestorePaths.salon(salonId)}/customer_notes',
    );
  }

  /// Real-time list ordered by [createdAt] (newest first).
  ///
  /// When [includeInactive] is false, applies `where('isActive', isEqualTo: true)`
  /// (matches Firestore security rules and composite index).
  Stream<List<Customer>> streamCustomers({
    required String salonId,
    bool includeInactive = false,
  }) {
    if (salonId.trim().isEmpty) {
      return Stream.value(const <Customer>[]);
    }
    Query<Map<String, dynamic>> query = _customersRef(salonId);
    if (!includeInactive) {
      query = query.where('isActive', isEqualTo: true);
    }
    query = query.orderBy('createdAt', descending: true);
    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) => Customer.fromJson(<String, dynamic>{
              ...doc.data(),
              'id': doc.id,
            }),
          )
          .toList(),
    );
  }

  Future<List<Customer>> searchCustomers(String salonId, String query) async {
    if (salonId.trim().isEmpty) {
      return const <Customer>[];
    }
    final normalizedQuery = query.trim().toLowerCase();
    final keyword = normalizeCustomerName(normalizedQuery).split(' ').first;
    if (normalizedQuery.isEmpty) {
      final snapshot = await _customersRef(salonId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();
      return snapshot.docs
          .map(
            (doc) => Customer.fromJson(<String, dynamic>{
              ...doc.data(),
              'id': doc.id,
            }),
          )
          .toList();
    }
    final snapshot = await _customersRef(salonId)
        .where('isActive', isEqualTo: true)
        .where('searchKeywords', arrayContains: keyword)
        .limit(150)
        .get();
    final digits = normalizeCustomerPhone(normalizedQuery) ?? '';
    return snapshot.docs
        .map(
          (doc) =>
              Customer.fromJson(<String, dynamic>{...doc.data(), 'id': doc.id}),
        )
        .where((customer) {
          final matchesName = customer.normalizedFullName.contains(
            normalizedQuery,
          );
          final phone = customer.normalizedPhoneNumber ?? '';
          final matchesPhone = digits.isNotEmpty && phone.contains(digits);
          return matchesName || matchesPhone;
        })
        .toList();
  }

  Future<Customer?> getCustomerById(String salonId, String customerId) async {
    if (salonId.trim().isEmpty || customerId.isEmpty) return null;
    final snapshot = await _customersRef(salonId).doc(customerId).get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    return Customer.fromJson(<String, dynamic>{
      ...snapshot.data()!,
      'id': snapshot.id,
    });
  }

  /// Real-time single customer at `salons/{salonId}/customers/{customerId}`.
  ///
  /// Emits [null] when the document is missing or inactive. Stream errors
  /// (e.g. permission-denied) propagate to the provider.
  Stream<Customer?> watchCustomerById({
    required String salonId,
    required String customerId,
    bool requireActive = true,
  }) {
    final sid = salonId.trim();
    final cid = customerId.trim();
    if (sid.isEmpty || cid.isEmpty) {
      return Stream.value(null);
    }
    if (kDebugMode) {
      debugPrint(
        '[CUSTOMER_READ] path=${FirestorePaths.salon(sid)}/${FirestorePaths.customers}/$cid',
      );
    }
    return _customersRef(sid).doc(cid).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }
      final customer = Customer.fromJson(<String, dynamic>{
        ...snapshot.data()!,
        'id': snapshot.id,
      });
      if (requireActive && !customer.isActive) {
        return null;
      }
      return customer;
    });
  }

  /// Sales for a salon customer, newest [Sale.soldAt] first.
  Stream<List<Sale>> watchCustomerSales({
    required String salonId,
    required String customerId,
    int limit = 20,
  }) {
    final sid = salonId.trim();
    final cid = customerId.trim();
    if (sid.isEmpty || cid.isEmpty) {
      return Stream.value(const <Sale>[]);
    }
    return _salesRef(sid)
        .where('customerId', isEqualTo: cid)
        .orderBy('soldAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Sale.fromJson(doc.data()))
              .toList(growable: false),
        );
  }

  /// Upcoming bookings for this customer (same salon document id as [customerId]).
  Stream<List<Booking>> watchUpcomingBookings({
    required String salonId,
    required String customerId,
    int limit = 5,
  }) {
    final sid = salonId.trim();
    final cid = customerId.trim();
    if (sid.isEmpty || cid.isEmpty) {
      return Stream.value(const <Booking>[]);
    }
    final now = Timestamp.fromDate(DateTime.now());
    return _bookingsRef(sid)
        .where('customerId', isEqualTo: cid)
        .where('startAt', isGreaterThanOrEqualTo: now)
        .orderBy('startAt')
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Booking.fromJson(doc.data()))
              .toList(growable: false),
        );
  }

  Future<void> updateCustomerDiscount({
    required String salonId,
    required String customerId,
    required double discountPercentage,
    required String updatedByUid,
  }) {
    if (discountPercentage < 0 || discountPercentage > 100) {
      throw ArgumentError('Discount must be between 0 and 100');
    }
    if (salonId.trim().isEmpty || customerId.trim().isEmpty) {
      return Future.value();
    }
    return _customersRef(salonId.trim()).doc(customerId.trim()).set({
      'discountPercentage': discountPercentage,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedByUid,
    }, SetOptions(merge: true));
  }

  Future<void> toggleVipStatus({
    required String salonId,
    required String customerId,
    required bool isVip,
    required String updatedByUid,
  }) {
    if (salonId.trim().isEmpty || customerId.trim().isEmpty) {
      return Future.value();
    }
    final payload = <String, dynamic>{
      'isVip': isVip,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedByUid,
    };
    if (isVip) {
      payload['category'] = 'vip';
    } else {
      payload['category'] = FieldValue.delete();
    }
    return _customersRef(
      salonId.trim(),
    ).doc(customerId.trim()).set(payload, SetOptions(merge: true));
  }

  Future<void> updateCustomerPhone({
    required String salonId,
    required String customerId,
    required String phone,
    required String updatedByUid,
  }) async {
    final sid = salonId.trim();
    final cid = customerId.trim();
    if (sid.isEmpty || cid.isEmpty) {
      return;
    }
    final snap = await _customersRef(sid).doc(cid).get();
    if (!snap.exists || snap.data() == null) {
      return;
    }
    final existing = Customer.fromJson(<String, dynamic>{
      ...snap.data()!,
      'id': snap.id,
    });
    final normalizedPhone = normalizeCustomerPhone(phone);
    await _customersRef(sid).doc(cid).set({
      'phone': phone.trim(),
      'normalizedPhoneNumber': normalizedPhone,
      'searchKeywords': buildCustomerSearchKeywords(
        fullName: existing.fullName,
        phoneNumber: phone.trim(),
      ),
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedByUid,
    }, SetOptions(merge: true));
  }

  Future<String> createCustomer({
    required String salonId,
    required Customer customer,
  }) async {
    if (salonId.trim().isEmpty) {
      throw StateError('salonId is required to create a customer.');
    }
    final docRef = _customersRef(salonId).doc();
    final now = FieldValue.serverTimestamp();
    final payload = customer.toJson()
      ..remove('id')
      ..['id'] = docRef.id
      ..['salonId'] = salonId
      ..['isActive'] = true
      // New customers start as "new" (VIP must be enabled manually later).
      ..['isVip'] = false
      ..['discountPercentage'] = customer.discountPercentage
      ..['createdAt'] = now
      ..['updatedAt'] = now
      ..['searchKeywords'] = buildCustomerSearchKeywords(
        fullName: customer.fullName,
        phoneNumber: customer.phone,
      )
      ..['category'] = 'new'
      ..['status'] ??= 'active'
      ..['visitsCount'] = customer.visitCount
      ..['totalVisits'] = customer.visitCount;

    final normalizedPhone = normalizeCustomerPhone(customer.phone);
    payload['normalizedPhoneNumber'] = normalizedPhone;
    if (normalizedPhone != null && normalizedPhone.isNotEmpty) {
      final duplicate = await _customersRef(salonId)
          .where('normalizedPhoneNumber', isEqualTo: normalizedPhone)
          .limit(1)
          .get();
      if (duplicate.docs.isNotEmpty) {
        throw StateError('A customer with this phone already exists.');
      }
    }
    await docRef.set(payload);
    return docRef.id;
  }

  Future<void> updateCustomer(String salonId, Customer customer) async {
    if (salonId.trim().isEmpty) {
      throw StateError('salonId is required to update a customer.');
    }
    final normalizedPhone = normalizeCustomerPhone(customer.phone);
    if (normalizedPhone != null && normalizedPhone.isNotEmpty) {
      final duplicate = await _customersRef(salonId)
          .where('normalizedPhoneNumber', isEqualTo: normalizedPhone)
          .limit(2)
          .get();
      for (final doc in duplicate.docs) {
        if (doc.id != customer.id) {
          throw StateError('A customer with this phone already exists.');
        }
      }
    }
    final payload = customer.toJson()
      ..remove('id')
      ..['updatedAt'] = FieldValue.serverTimestamp()
      ..['normalizedPhoneNumber'] = normalizedPhone
      ..['searchKeywords'] = buildCustomerSearchKeywords(
        fullName: customer.fullName,
        phoneNumber: customer.phone,
      )
      ..['visitsCount'] = customer.visitCount;
    await _customersRef(
      salonId,
    ).doc(customer.id).set(payload, SetOptions(merge: true));
  }

  Future<void> archiveCustomer(String salonId, String customerId) {
    if (salonId.trim().isEmpty) return Future.value();
    return _customersRef(salonId).doc(customerId).set({
      'isActive': false,
      'status': 'inactive',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> deleteCustomer(String salonId, String customerId) {
    return archiveCustomer(salonId, customerId);
  }

  Stream<List<CustomerNote>> streamCustomerHistory(
    String salonId,
    String customerId,
  ) {
    return _customerNotes(salonId)
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => CustomerNote.fromJson({...doc.data(), 'id': doc.id}),
              )
              .toList(),
        );
  }
}
