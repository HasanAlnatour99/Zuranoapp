import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/booking_statuses.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/session_provider.dart';
import '../../bookings/data/models/booking.dart';
import '../data/models/customer.dart';

class CreateBookingInput {
  const CreateBookingInput({
    required this.customer,
    required this.barberId,
    required this.barberName,
    required this.serviceIds,
    required this.serviceNames,
    required this.totalPrice,
    required this.totalDurationMinutes,
    required this.startAt,
    required this.endAt,
    this.notes,
    this.isWalkIn = false,
  });

  final Customer customer;
  final String barberId;
  final String barberName;
  final List<String> serviceIds;
  final List<String> serviceNames;
  final double totalPrice;
  final int totalDurationMinutes;
  final DateTime startAt;
  final DateTime endAt;
  final String? notes;
  final bool isWalkIn;
}

class CreateBookingController {
  CreateBookingController(this._ref);

  final Ref _ref;

  Future<String> createBooking(CreateBookingInput input) async {
    final user = _ref.read(sessionUserProvider).asData?.value;
    final salonId = user?.salonId ?? '';
    if (salonId.isEmpty) {
      throw StateError('No salon is linked to this account.');
    }
    if (input.serviceIds.isEmpty) {
      throw StateError('At least one service is required.');
    }
    if (input.startAt.isAfter(input.endAt) ||
        input.startAt.isAtSameMomentAs(input.endAt)) {
      throw StateError('Booking end time must be after start time.');
    }
    final bookingRepo = _ref.read(bookingRepositoryProvider);
    try {
      final bookingId = await bookingRepo.createBooking(
        salonId,
        Booking(
          id: '',
          salonId: salonId,
          barberId: input.barberId,
          customerId: input.customer.id,
          startAt: input.startAt,
          endAt: input.endAt,
          status: BookingStatuses.confirmed,
          barberName: input.barberName,
          customerName: input.customer.fullName,
          serviceId: input.serviceIds.first,
          serviceName: input.serviceNames.isEmpty
              ? null
              : input.serviceNames.first,
          notes: input.notes,
        ),
        slotStepMinutes: 15,
        extraPayload: {
          'customerPhone': input.customer.phoneNumber,
          'serviceIds': input.serviceIds,
          'serviceNames': input.serviceNames,
          'totalPrice': input.totalPrice,
          'totalDurationMinutes': input.totalDurationMinutes,
          'bookingDate': DateTime(
            input.startAt.year,
            input.startAt.month,
            input.startAt.day,
          ),
          'createdBy': user?.uid,
          'createdByRole': user?.role,
          'isWalkIn': input.isWalkIn,
        },
      );

      return bookingId;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}

final createBookingControllerProvider = Provider<CreateBookingController>((
  ref,
) {
  return CreateBookingController(ref);
});
