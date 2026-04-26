import 'package:flutter/material.dart';

/// Period chips on the Sales dashboard (default: [thisMonth]).
enum SalesFilter { today, thisWeek, thisMonth, custom }

bool dateTimeMatchesSalesFilter({
  required DateTime at,
  required SalesFilter filter,
  DateTimeRange? customRange,
  DateTime? clock,
}) {
  final now = clock ?? DateTime.now();
  final local = at.toLocal();
  final day = DateUtils.dateOnly(local);
  final today = DateUtils.dateOnly(now);
  switch (filter) {
    case SalesFilter.today:
      return day == today;
    case SalesFilter.thisWeek:
      final start = today.subtract(
        Duration(days: today.weekday - DateTime.monday),
      );
      final end = start.add(const Duration(days: 7));
      return !day.isBefore(start) && day.isBefore(end);
    case SalesFilter.thisMonth:
      return local.year == now.year && local.month == now.month;
    case SalesFilter.custom:
      final range = customRange;
      if (range == null) return true;
      final start = DateUtils.dateOnly(range.start);
      final end = DateUtils.dateOnly(range.end).add(const Duration(days: 1));
      return !day.isBefore(start) && day.isBefore(end);
  }
}
