/// Thrown when [bookingCancel] / [bookingReschedule] return a domain
/// [failed-precondition] from Cloud Functions.
class BookingAlreadyEndedException implements Exception {
  BookingAlreadyEndedException([this.message = 'Booking already ended.']);

  final String message;

  @override
  String toString() => message;
}

class BookingAlreadyCancelledException implements Exception {
  BookingAlreadyCancelledException([
    this.message = 'Booking already cancelled.',
  ]);

  final String message;

  @override
  String toString() => message;
}

class BookingAlreadyRescheduledException implements Exception {
  BookingAlreadyRescheduledException([
    this.message = 'Booking already rescheduled.',
  ]);

  final String message;

  @override
  String toString() => message;
}

class BookingStaleStateException implements Exception {
  BookingStaleStateException([
    this.message = 'Booking state changed; refresh and try again.',
  ]);

  final String message;

  @override
  String toString() => message;
}

class BookingUnauthorizedRoleException implements Exception {
  BookingUnauthorizedRoleException([this.message = 'Permission denied.']);

  final String message;

  @override
  String toString() => message;
}
