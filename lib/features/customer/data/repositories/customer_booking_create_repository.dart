import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../../core/firestore/firestore_paths.dart';
import '../models/customer_booking_create_result.dart';
import '../models/customer_booking_draft.dart';
import '../models/customer_booking_settings.dart';

class SlotUnavailableException implements Exception {
  const SlotUnavailableException();
}

class CustomerBookingValidationException implements Exception {
  const CustomerBookingValidationException(this.message);

  final String message;
}

abstract class CustomerBookingCreateRepository {
  Future<CustomerBookingCreateResult> createBookingFromDraft({
    required String salonId,
    required CustomerBookingDraft draft,
    required CustomerBookingSettings bookingSettings,
  });
}

/// MVP direct Firestore create (bypassed in app by [CallableCustomerBookingCreateRepository]).
///
/// TODO: Remove after Cloud Functions deployment is verified end-to-end.
class FirestoreCustomerBookingCreateRepository
    implements CustomerBookingCreateRepository {
  FirestoreCustomerBookingCreateRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static const _blockingStatuses = {
    'pending',
    'confirmed',
    'checkedIn',
    'checked_in',
  };

  @override
  Future<CustomerBookingCreateResult> createBookingFromDraft({
    required String salonId,
    required CustomerBookingDraft draft,
    required CustomerBookingSettings bookingSettings,
  }) async {
    validateDraft(draft, bookingSettings);

    final startAt = draft.selectedStartAt!;
    final endAt = draft.selectedEndAt!;
    final employeeId = draft.selectedEmployeeId!.trim();
    final employeeName = draft.selectedEmployeeName?.trim() ?? '';
    final dayStart = DateTime(startAt.year, startAt.month, startAt.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final candidateBookingRefs = await _firestore
        .collection(FirestorePaths.salonBookings(salonId))
        .where('startAt', isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart))
        .where('startAt', isLessThan: Timestamp.fromDate(dayEnd))
        .get()
        .then((snap) => snap.docs.map((doc) => doc.reference).toList());

    final bookingRef = _firestore
        .collection(FirestorePaths.salonBookings(salonId))
        .doc();
    final customerDocId = _stableCustomerDocId(
      draft: draft,
      bookingId: bookingRef.id,
    );
    final stableCustomerRef = _firestore
        .collection(
          '${FirestorePaths.salon(salonId)}/${FirestorePaths.customers}',
        )
        .doc(customerDocId);

    final result = await _firestore.runTransaction<CustomerBookingCreateResult>(
      (transaction) async {
        for (final ref in candidateBookingRefs) {
          final snap = await transaction.get(ref);
          if (!snap.exists) {
            continue;
          }
          final data = snap.data();
          if (data == null) {
            continue;
          }
          if (_blocksSlot(
            data,
            employeeId,
            startAt,
            endAt,
            bookingSettings.bufferMinutes,
          )) {
            throw const SlotUnavailableException();
          }
        }

        final now = FieldValue.serverTimestamp();
        final phoneNorm = draft.customerPhoneNormalized?.trim() ?? '';
        final displayName = draft.customerName?.trim().isNotEmpty == true
            ? draft.customerName!.trim()
            : 'Guest';
        final displayPhone = draft.customerPhone?.trim().isNotEmpty == true
            ? draft.customerPhone!.trim()
            : (phoneNorm.isNotEmpty ? phoneNorm : '—');
        final customerData = <String, dynamic>{
          'salonId': salonId,
          'fullName': displayName,
          'phone': displayPhone,
          'phoneNormalized': phoneNorm.isNotEmpty
              ? phoneNorm
              : 'guest_$bookingRef.id',
          'gender': draft.customerGender,
          'notes': draft.customerNote,
          'type': 'new',
          'isVip': false,
          'discountPercent': 0,
          'totalVisits': 0,
          'totalSpent': 0,
          'lastVisitAt': null,
          'isActive': true,
          'createdAt': now,
          'updatedAt': now,
        };
        transaction.set(
          stableCustomerRef,
          customerData,
          SetOptions(merge: true),
        );

        final status = bookingSettings.autoConfirmBookings
            ? 'confirmed'
            : 'pending';
        final bookingCode = _bookingCode(startAt);
        final services = draft.selectedServices
            .map(
              (service) => <String, dynamic>{
                'serviceId': service.id,
                'serviceName': service.displayTitle,
                'price': service.price,
                'durationMinutes': service.durationMinutes,
                'category': service.category,
              },
            )
            .toList(growable: false);

        transaction.set(bookingRef, {
          'salonId': salonId,
          'customerId': stableCustomerRef.id,
          'customerName': displayName,
          'customerPhone': displayPhone,
          'customerPhoneNormalized': phoneNorm.isNotEmpty
              ? phoneNorm
              : 'guest_${bookingRef.id}',
          'employeeId': employeeId,
          'employeeName': employeeName,
          'barberId': employeeId,
          'barberName': employeeName,
          'services': services,
          'serviceNames': draft.serviceNames,
          'subtotal': draft.subtotal,
          'discountAmount': draft.discountAmount,
          'totalAmount': draft.totalAmount,
          'durationMinutes': draft.durationMinutes,
          'startAt': Timestamp.fromDate(startAt),
          'endAt': Timestamp.fromDate(endAt),
          'status': status,
          'source': 'customer_app',
          'bookingCode': bookingCode,
          'customerNote': draft.customerNote,
          'customerGender': draft.customerGender,
          'createdAt': now,
          'updatedAt': now,
        });

        return CustomerBookingCreateResult(
          bookingId: bookingRef.id,
          salonId: salonId,
          customerId: stableCustomerRef.id,
          bookingCode: bookingCode,
          status: status,
          startAt: startAt,
          endAt: endAt,
        );
      },
    );

    return result;
  }

  /// Used by [CustomerCallableBookingRepository] before HTTPS create.
  static void validateDraft(
    CustomerBookingDraft draft,
    CustomerBookingSettings settings,
  ) {
    if (!draft.hasServices) {
      throw const CustomerBookingValidationException('missing_services');
    }
    if (!draft.hasTeamSelection || draft.selectedEmployeeId == null) {
      throw const CustomerBookingValidationException('missing_specialist');
    }
    if (!draft.hasDateTime) {
      throw const CustomerBookingValidationException('missing_time');
    }
    if (!settings.customerDetailsSatisfied(
      customerName: draft.customerName,
      customerPhoneNormalized: draft.customerPhoneNormalized,
    )) {
      throw const CustomerBookingValidationException('missing_customer');
    }
  }

  static String _stableCustomerDocId({
    required CustomerBookingDraft draft,
    required String bookingId,
  }) {
    final phoneNorm = draft.customerPhoneNormalized?.trim() ?? '';
    if (phoneNorm.isNotEmpty) {
      return _customerIdFromPhone(phoneNorm);
    }
    return 'guest_$bookingId';
  }

  static bool _blocksSlot(
    Map<String, dynamic> data,
    String employeeId,
    DateTime startAt,
    DateTime endAt,
    int bufferMinutes,
  ) {
    final status = '${data['status'] ?? ''}'.trim();
    if (!_blockingStatuses.contains(status)) {
      return false;
    }
    final bookingEmployeeId =
        (data['employeeId'] as String?) ?? (data['barberId'] as String?);
    if (bookingEmployeeId != employeeId) {
      return false;
    }
    final existingStart = _dateTime(data['startAt']);
    final existingEnd = _dateTime(data['endAt']);
    if (existingStart == null || existingEnd == null) {
      return false;
    }
    final buffer = Duration(minutes: bufferMinutes.clamp(0, 240));
    final existingEndBuffered = existingEnd.add(buffer);
    return existingStart.isBefore(endAt) &&
        existingEndBuffered.isAfter(startAt);
  }

  static DateTime? _dateTime(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return null;
  }

  static String _bookingCode(DateTime startAt) {
    final date = DateFormat('yyyyMMdd').format(startAt);
    final random = Random.secure().nextInt(90000) + 10000;
    return 'ZR-$date-$random';
  }

  static String _customerIdFromPhone(String phoneNormalized) {
    final digits = phoneNormalized.replaceAll(RegExp(r'\D'), '');
    return 'phone_$digits';
  }
}
