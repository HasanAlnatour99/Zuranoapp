import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/firestore_paths.dart';
import '../models/customer_booking_details_model.dart';

abstract class CustomerBookingDetailsRepository {
  Future<CustomerBookingDetailsModel?> getBookingDetails({
    required String salonId,
    required String bookingId,
    String? phoneNormalized,
    String? bookingCode,
  });
}

class FirestoreCustomerBookingDetailsRepository
    implements CustomerBookingDetailsRepository {
  FirestoreCustomerBookingDetailsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<CustomerBookingDetailsModel?> getBookingDetails({
    required String salonId,
    required String bookingId,
    String? phoneNormalized,
    String? bookingCode,
  }) async {
    final sid = salonId.trim();
    final bid = bookingId.trim();
    if (sid.isEmpty || bid.isEmpty) {
      return null;
    }

    final bookingRef = _firestore.doc(FirestorePaths.salonBooking(sid, bid));
    final publicRef = _firestore.doc(FirestorePaths.publicSalon(sid));

    final bookingSnap = await bookingRef.get();
    if (!bookingSnap.exists) {
      return null;
    }

    final bookingData = bookingSnap.data() ?? const <String, dynamic>{};

    SalonPublicSlice publicSlice = SalonPublicSlice.empty(sid);
    final publicSnap = await publicRef.get();
    if (publicSnap.exists) {
      final data = publicSnap.data() ?? const <String, dynamic>{};
      publicSlice = SalonPublicSlice.fromMap(publicSnap.id, data);
    }

    return CustomerBookingDetailsModel.fromFirestore(
      bookingId: bid,
      bookingData: bookingData,
      publicSalon: publicSlice,
    );
  }
}
