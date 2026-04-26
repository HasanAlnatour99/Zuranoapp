/// `salons/{salonId}/bookings/{id}.status` values.
///
/// New bookings use [pending]. Legacy documents may still store `scheduled`;
/// [BookingStatusMachine.normalize] maps that to [pending].
abstract final class BookingStatuses {
  static const pending = 'pending';
  static const confirmed = 'confirmed';
  static const completed = 'completed';
  static const cancelled = 'cancelled';
  static const noShow = 'no_show';

  /// Superseded row after a reschedule (new booking holds the new slot).
  static const rescheduled = 'rescheduled';
}
