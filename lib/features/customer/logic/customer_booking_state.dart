import '../../bookings/data/models/booking.dart';
import '../../employees/data/models/employee.dart';
import '../../services/data/models/service.dart';

class CustomerBookingState {
  const CustomerBookingState({
    this.selectedDay,
    this.service,
    this.barber,
    this.slotStartUtc,
    this.notes = '',
    this.isSubmitting = false,
    this.submissionErrorCode,
    this.rescheduleBooking,
    this.rescheduleApplied = false,
  });

  final DateTime? selectedDay;
  final SalonService? service;
  final Employee? barber;
  final DateTime? slotStartUtc;
  final String notes;
  final bool isSubmitting;

  /// Machine-oriented code; map to [AppLocalizations] in the UI.
  final String? submissionErrorCode;
  final Booking? rescheduleBooking;
  final bool rescheduleApplied;

  bool get isRescheduleFlow => rescheduleBooking != null;

  CustomerBookingState copyWith({
    DateTime? selectedDay,
    Object? service = _sentinel,
    Object? barber = _sentinel,
    Object? slotStartUtc = _sentinel,
    String? notes,
    bool? isSubmitting,
    Object? submissionErrorCode = _sentinel,
    Object? rescheduleBooking = _sentinel,
    bool? rescheduleApplied,
  }) {
    return CustomerBookingState(
      selectedDay: selectedDay ?? this.selectedDay,
      service: identical(service, _sentinel)
          ? this.service
          : service as SalonService?,
      barber: identical(barber, _sentinel) ? this.barber : barber as Employee?,
      slotStartUtc: identical(slotStartUtc, _sentinel)
          ? this.slotStartUtc
          : slotStartUtc as DateTime?,
      notes: notes ?? this.notes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionErrorCode: identical(submissionErrorCode, _sentinel)
          ? this.submissionErrorCode
          : submissionErrorCode as String?,
      rescheduleBooking: identical(rescheduleBooking, _sentinel)
          ? this.rescheduleBooking
          : rescheduleBooking as Booking?,
      rescheduleApplied: rescheduleApplied ?? this.rescheduleApplied,
    );
  }
}

const Object _sentinel = Object();
