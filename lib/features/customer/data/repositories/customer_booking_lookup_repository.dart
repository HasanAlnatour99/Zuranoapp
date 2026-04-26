import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/firestore_paths.dart';
import '../models/customer_booking_lookup_model.dart';

abstract class CustomerBookingLookupRepository {
  Future<List<CustomerBookingLookupModel>> findBookings({
    required String phoneNormalized,
    String? bookingCode,
    String? salonIdForPolicy,
  });
}

class FirestoreCustomerBookingLookupRepository
    implements CustomerBookingLookupRepository {
  FirestoreCustomerBookingLookupRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<List<CustomerBookingLookupModel>> findBookings({
    required String phoneNormalized,
    String? bookingCode,
    String? salonIdForPolicy,
  }) async {
    final normalizedPhone = phoneNormalized.trim();
    final normalizedCode = bookingCode?.trim().toUpperCase();
    if (normalizedPhone.isEmpty) {
      return const [];
    }

    final snapshot = await _firestore
        .collectionGroup(FirestorePaths.bookings)
        .where('customerPhoneNormalized', isEqualTo: normalizedPhone)
        .orderBy('startAt', descending: true)
        .limit(20)
        .get();

    return snapshot.docs
        .where((doc) => _isCustomerVisibleBooking(doc.data()))
        .where((doc) {
          if (normalizedCode == null || normalizedCode.isEmpty) {
            return true;
          }
          return '${doc.data()['bookingCode'] ?? ''}'.trim().toUpperCase() ==
              normalizedCode;
        })
        .map(CustomerBookingLookupModel.fromFirestore)
        .where((booking) {
          return booking.salonId.isNotEmpty &&
              booking.customerPhoneNormalized == normalizedPhone;
        })
        .toList(growable: false);
  }

  bool _isCustomerVisibleBooking(Map<String, dynamic> data) {
    final phone = data['customerPhoneNormalized'];
    return data['source'] == 'customer_app' ||
        (phone is String && phone.trim().isNotEmpty);
  }
}
