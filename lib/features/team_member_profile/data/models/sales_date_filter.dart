/// Preset for the sales history range (KPIs always use the live calendar window).
enum SalesDateFilterKind { thisMonth, today, thisWeek, custom }

class SalesDateFilter {
  const SalesDateFilter({
    required this.startInclusive,
    required this.endExclusive,
    required this.kind,
  });

  final DateTime startInclusive;
  final DateTime endExclusive;
  final SalesDateFilterKind kind;

  factory SalesDateFilter.thisMonth([DateTime? clock]) {
    final now = clock ?? DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 1);
    return SalesDateFilter(
      startInclusive: start,
      endExclusive: end,
      kind: SalesDateFilterKind.thisMonth,
    );
  }

  factory SalesDateFilter.today([DateTime? clock]) {
    final now = clock ?? DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day + 1);
    return SalesDateFilter(
      startInclusive: start,
      endExclusive: end,
      kind: SalesDateFilterKind.today,
    );
  }

  factory SalesDateFilter.thisWeek([DateTime? clock]) {
    final now = clock ?? DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    final monday = day.subtract(Duration(days: day.weekday - DateTime.monday));
    final end = DateTime(day.year, day.month, day.day + 1);
    return SalesDateFilter(
      startInclusive: monday,
      endExclusive: end,
      kind: SalesDateFilterKind.thisWeek,
    );
  }

  factory SalesDateFilter.custom({
    required DateTime rangeStartDay,
    required DateTime rangeEndDay,
  }) {
    final s = DateTime(
      rangeStartDay.year,
      rangeStartDay.month,
      rangeStartDay.day,
    );
    final eDay = DateTime(rangeEndDay.year, rangeEndDay.month, rangeEndDay.day);
    final endExclusive = DateTime(eDay.year, eDay.month, eDay.day + 1);
    return SalesDateFilter(
      startInclusive: s,
      endExclusive: endExclusive,
      kind: SalesDateFilterKind.custom,
    );
  }
}

/// Earliest local instant needed on the KPI stream: Monday this week or the
/// first day of the current month (whichever is earlier).
DateTime teamMemberKpiQueryStartLocal(DateTime now) {
  final day = DateTime(now.year, now.month, now.day);
  final monday = day.subtract(Duration(days: day.weekday - DateTime.monday));
  final monthStart = DateTime(now.year, now.month, 1);
  return monday.isBefore(monthStart) ? monday : monthStart;
}

/// Start of tomorrow (local), exclusive upper bound for “through today” KPIs.
DateTime teamMemberKpiQueryEndExclusiveLocal(DateTime now) {
  final day = DateTime(now.year, now.month, now.day);
  return DateTime(day.year, day.month, day.day + 1);
}
