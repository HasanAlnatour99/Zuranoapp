import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../data/repositories/customer_booking_cancel_repository.dart';

class CustomerBookingCancelService {
  CustomerBookingCancelService(this._repository);

  final CustomerBookingCancelRepository _repository;

  static const int maxCancelReasonLength = 200;

  Future<void> cancelBooking({
    required String salonId,
    required String bookingId,
    required String cancelReason,
    required String phoneNormalized,
    required String bookingCode,
  }) async {
    final trimmed = cancelReason.trim();
    if (trimmed.length > maxCancelReasonLength) {
      throw const CustomerBookingCancelException(
        CustomerBookingCancelFailure.reasonTooLong,
      );
    }

    try {
      await _repository.cancelBooking(
        salonId: salonId,
        bookingId: bookingId,
        cancelReason: trimmed,
        phoneNormalized: phoneNormalized,
        bookingCode: bookingCode,
      );
    } on CustomerBookingCancelException {
      rethrow;
    } on FirebaseFunctionsException catch (e) {
      if (e.code == 'permission-denied') {
        throw const CustomerBookingCancelException(
          CustomerBookingCancelFailure.permissionDenied,
        );
      }
      if (e.code == 'failed-precondition') {
        final m = '${e.message}';
        if (m.contains('cutoff')) {
          throw const CustomerBookingCancelException(
            CustomerBookingCancelFailure.cutoffExpired,
          );
        }
        if (m.contains('invalid_status')) {
          throw const CustomerBookingCancelException(
            CustomerBookingCancelFailure.invalidStatus,
          );
        }
      }
      if (e.code == 'not-found') {
        throw const CustomerBookingCancelException(
          CustomerBookingCancelFailure.notFound,
        );
      }
      rethrow;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw const CustomerBookingCancelException(
          CustomerBookingCancelFailure.permissionDenied,
        );
      }
      rethrow;
    }
  }
}
