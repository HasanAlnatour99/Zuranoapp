/// `salons/{salonId}/attendance/{id}.status`
abstract final class AttendanceDayStatuses {
  static const notStarted = 'notStarted';
  static const checkedIn = 'checkedIn';
  static const onBreak = 'onBreak';
  static const checkedOut = 'checkedOut';
  static const missingPunchOut = 'missingPunchOut';
}

/// `salons/{salonId}/attendance/{id}.currentState`
abstract final class AttendanceCurrentStates {
  static const notStarted = 'notStarted';
  static const working = 'working';
  static const onBreak = 'onBreak';
  static const finished = 'finished';
}
