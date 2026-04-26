import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'owner_overview_controller.dart';
import 'owner_overview_state.dart';

/// Structured insight rows computed from [OwnerOverviewState] (no UI strings).
sealed class DashboardInsightLine {
  const DashboardInsightLine();
}

final class InsightTopBarberLine extends DashboardInsightLine {
  const InsightTopBarberLine({required this.name, required this.percent});

  final String name;
  final double percent;
}

final class InsightTopServiceWeekLine extends DashboardInsightLine {
  const InsightTopServiceWeekLine({required this.serviceName});

  final String serviceName;
}

/// Signed percent change: `(today - yesterday) / max(yesterday, 1) * 100`.
final class InsightBookingsCompareLine extends DashboardInsightLine {
  const InsightBookingsCompareLine({required this.signedPercent});

  final double signedPercent;
}

final class InsightNoBookingsTodayLine extends DashboardInsightLine {
  const InsightNoBookingsTodayLine();
}

/// Strong, data-backed insights only (max 3). Localization happens in UI.
final dashboardInsightLinesProvider = Provider<List<DashboardInsightLine>>((
  ref,
) {
  final state = ref.watch(ownerOverviewControllerProvider);
  return computeDashboardInsightLines(state);
});

List<DashboardInsightLine> computeDashboardInsightLines(
  OwnerOverviewState state,
) {
  final out = <DashboardInsightLine>[];

  final barber = state.topBarberTodayInsight;
  final barberName = (barber?.barberName ?? '').trim();
  if (barber != null &&
      barberName.length >= 2 &&
      state.todayRevenue > 0 &&
      barber.contributionPercent >= 12) {
    out.add(
      InsightTopBarberLine(
        name: barberName,
        percent: barber.contributionPercent,
      ),
    );
  }

  final weekName = (state.topServiceThisWeekName ?? '').trim();
  if (weekName.length >= 2 && state.topServiceThisWeekUses >= 2) {
    out.add(InsightTopServiceWeekLine(serviceName: weekName));
  }

  final today = state.bookingsToday;
  final yesterday = state.bookingsYesterdayCount;
  if (yesterday >= 2 && today == 0) {
    out.add(const InsightNoBookingsTodayLine());
  } else {
    final compare = _bookingsSignedPercent(today, yesterday);
    if (compare != null && compare.abs() >= 12) {
      out.add(InsightBookingsCompareLine(signedPercent: compare));
    } else if (yesterday == 0 && today >= 3) {
      out.add(const InsightBookingsCompareLine(signedPercent: 100));
    }
  }

  return out.take(3).toList();
}

double? _bookingsSignedPercent(int today, int yesterday) {
  if (today == 0 && yesterday == 0) return null;
  if (yesterday == 0) return null;
  return ((today - yesterday) / yesterday) * 100;
}
