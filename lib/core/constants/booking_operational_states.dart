/// Day-of `salons/.../bookings` operational flow (separate from [BookingStatuses]).
abstract final class BookingOperationalStates {
  static const waiting = 'waiting';
  static const customerArrived = 'customer_arrived';
  static const serviceStarted = 'service_started';
  static const completed = 'completed';
  static const noShowCustomer = 'no_show_customer';
  static const noShowBarber = 'no_show_barber';

  static const Set<String> all = {
    waiting,
    customerArrived,
    serviceStarted,
    completed,
    noShowCustomer,
    noShowBarber,
  };

  static const Set<String> terminal = {completed, noShowCustomer, noShowBarber};

  /// Default when field absent for active bookings.
  static String normalize(String? raw) {
    final s = raw?.trim() ?? '';
    if (s.isEmpty) {
      return waiting;
    }
    return all.contains(s) ? s : waiting;
  }
}
