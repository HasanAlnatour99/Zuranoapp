/// Aggregated “today” metrics for a salon employee profile overview.
class TeamMemberTodaySummaryModel {
  const TeamMemberTodaySummaryModel({
    required this.todaySales,
    required this.servicesCount,
    required this.attendanceDay,
  });

  final double todaySales;
  final int servicesCount;
  final TeamMemberAttendanceDaySummary attendanceDay;
}

/// Raw attendance state for the employee’s calendar day (local).
enum TeamMemberAttendanceDaySummary {
  notCheckedIn,
  checkedIn,
  checkedOut,
  absent,
}
