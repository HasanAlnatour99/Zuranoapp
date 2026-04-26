abstract final class ViolationTypes {
  static const barberLate = 'barber_late';
  static const barberNoShow = 'barber_no_show';
}

abstract final class ViolationStatuses {
  static const pending = 'pending';
  static const approved = 'approved';
  static const rejected = 'rejected';
  static const applied = 'applied';
}

abstract final class ViolationSourceTypes {
  static const booking = 'booking';
}
