/// Thrown when punch or correction validation fails (show [message] to user).
class AttendanceException implements Exception {
  AttendanceException(this.message);

  final String message;

  @override
  String toString() => message;
}
