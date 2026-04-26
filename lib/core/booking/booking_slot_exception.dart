/// Thrown when [BookingSlots] validation fails.
class BookingSlotException implements Exception {
  const BookingSlotException(this.message);

  final String message;

  @override
  String toString() => 'BookingSlotException: $message';
}
