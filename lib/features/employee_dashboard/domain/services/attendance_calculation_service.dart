class AttendanceCalculationService {
  int calculateWorkedMinutes({
    required DateTime punchInAt,
    required DateTime? punchOutAt,
    required int totalBreakMinutes,
  }) {
    final end = punchOutAt ?? DateTime.now();
    final grossMinutes = end.difference(punchInAt).inMinutes;
    final netMinutes = grossMinutes - totalBreakMinutes;
    return netMinutes < 0 ? 0 : netMinutes;
  }

  int calculateBreakMinutes({
    required DateTime breakOutAt,
    required DateTime breakInAt,
  }) {
    final minutes = breakInAt.difference(breakOutAt).inMinutes;
    return minutes < 0 ? 0 : minutes;
  }

  String formatHoursFromMinutes(int minutes) {
    final hours = minutes / 60;
    return hours.toStringAsFixed(1);
  }
}
