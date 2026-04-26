/// Firestore `bookingCreateFieldsValid` caps notes at 2000; keep app limit in sync.
abstract final class CustomerBookingLimits {
  static const int maxNotesLength = 2000;
}
