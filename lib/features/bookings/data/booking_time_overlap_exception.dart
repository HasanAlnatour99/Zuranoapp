/// Thrown when a booking's time range overlaps another active booking for the same barber.
class BookingTimeOverlapException implements Exception {
  const BookingTimeOverlapException([
    this.message = 'This time overlaps an existing booking for that barber.',
  ]);

  final String message;

  @override
  String toString() => 'BookingTimeOverlapException: $message';
}
