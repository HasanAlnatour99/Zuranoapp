enum AttendancePunchType {
  punchIn,
  punchOut,
  breakOut,
  breakIn;

  String get firestoreValue => name;

  static AttendancePunchType fromFirestoreString(String value) {
    return AttendancePunchType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AttendancePunchType.punchIn,
    );
  }
}
