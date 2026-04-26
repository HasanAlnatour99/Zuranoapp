import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/booking_status_machine.dart';
import '../../../../core/constants/booking_statuses.dart';
import '../../../../core/firestore/firestore_paths.dart';
import '../models/customer_booking_settings.dart';

enum CustomerBookingCancelFailure {
  notFound,
  invalidStatus,
  cutoffExpired,
  reasonTooLong,
  permissionDenied,
}

class CustomerBookingCancelException implements Exception {
  const CustomerBookingCancelException(this.failure);

  final CustomerBookingCancelFailure failure;

  @override
  String toString() => 'CustomerBookingCancelException($failure)';
}

abstract class CustomerBookingCancelRepository {
  Future<void> cancelBooking({
    required String salonId,
    required String bookingId,
    required String cancelReason,
    required String phoneNormalized,
    required String bookingCode,
  });
}

class FirestoreCustomerBookingCancelRepository
    implements CustomerBookingCancelRepository {
  FirestoreCustomerBookingCancelRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<void> cancelBooking({
    required String salonId,
    required String bookingId,
    required String cancelReason,
    required String phoneNormalized,
    required String bookingCode,
  }) async {
    final bookingRef = _firestore.doc(
      FirestorePaths.salonBooking(salonId, bookingId),
    );
    final snap = await bookingRef.get();
    if (!snap.exists) {
      throw const CustomerBookingCancelException(
        CustomerBookingCancelFailure.notFound,
      );
    }
    final data = snap.data();
    if (data == null) {
      throw const CustomerBookingCancelException(
        CustomerBookingCancelFailure.notFound,
      );
    }

    if ('${data['customerPhoneNormalized'] ?? ''}'.trim() !=
        phoneNormalized.trim()) {
      throw const CustomerBookingCancelException(
        CustomerBookingCancelFailure.permissionDenied,
      );
    }
    if ('${data['bookingCode'] ?? ''}'.trim().toUpperCase() !=
        bookingCode.trim().toUpperCase()) {
      throw const CustomerBookingCancelException(
        CustomerBookingCancelFailure.permissionDenied,
      );
    }

    final statusRaw = data['status']?.toString();
    final normalized = BookingStatusMachine.normalize(statusRaw);
    if (normalized != BookingStatuses.pending &&
        normalized != BookingStatuses.confirmed) {
      throw const CustomerBookingCancelException(
        CustomerBookingCancelFailure.invalidStatus,
      );
    }

    final startAt = _readTimestamp(data['startAt']);
    if (startAt == null) {
      throw const CustomerBookingCancelException(
        CustomerBookingCancelFailure.invalidStatus,
      );
    }

    final cutoffMinutes = await _readCancellationCutoffMinutes(salonId);
    final nowUtc = DateTime.now().toUtc();
    final startUtc = startAt.toUtc();
    final deadline = startUtc.subtract(Duration(minutes: cutoffMinutes));
    if (!nowUtc.isBefore(deadline)) {
      throw const CustomerBookingCancelException(
        CustomerBookingCancelFailure.cutoffExpired,
      );
    }

    await bookingRef.update({
      'status': BookingStatuses.cancelled,
      'cancelReason': cancelReason,
      'cancelledBy': 'customer',
      'cancelledAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  DateTime? _readTimestamp(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return null;
  }

  Future<int> _readCancellationCutoffMinutes(String salonId) async {
    final publicSnap = await _firestore
        .doc(FirestorePaths.publicSalon(salonId))
        .get();
    final raw = publicSnap.data()?['customerBookingSettings'];
    if (raw is! Map<String, dynamic>) {
      return const CustomerBookingSettings().cancellationCutoffMinutes;
    }
    return CustomerBookingSettings.fromMap(raw).cancellationCutoffMinutes;
  }
}
