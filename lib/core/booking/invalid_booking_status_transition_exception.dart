/// Thrown when a booking status change violates the booking status machine rules.
class InvalidBookingStatusTransitionException implements Exception {
  const InvalidBookingStatusTransitionException(this.fromStatus, this.toStatus);

  final String fromStatus;
  final String toStatus;

  @override
  String toString() =>
      'InvalidBookingStatusTransitionException: cannot go from "$fromStatus" to "$toStatus".';
}
