/// Thrown when a booking write requires a Firebase Auth session but none exists.
class BookingNotAuthenticatedException implements Exception {
  const BookingNotAuthenticatedException();

  @override
  String toString() => 'You must be signed in to create a booking.';
}
