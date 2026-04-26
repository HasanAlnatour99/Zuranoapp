import 'dart:math';

import '../domain/models/ai_surface_response.dart';
import '../domain/repositories/owner_dashboard_ai_repository.dart';

class MockOwnerDashboardAiRepository implements OwnerDashboardAiRepository {
  const MockOwnerDashboardAiRepository();

  @override
  Future<SalonRevenueSummary> getSalonRevenueSummary({
    required String salonId,
    required AiTimeframe timeframe,
  }) async {
    final range = timeframe.range;
    final seed = salonId.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
    final random = Random(seed + range.index + 13);
    final totalRevenue = switch (range) {
      AiTimeRange.today => 1200 + random.nextInt(2200).toDouble(),
      AiTimeRange.last7Days => 7600 + random.nextInt(4200).toDouble(),
      AiTimeRange.month => 18000 + random.nextInt(16000).toDouble(),
      AiTimeRange.quarter => 52000 + random.nextInt(28000).toDouble(),
      AiTimeRange.custom => 9500 + random.nextInt(6400).toDouble(),
    };
    final transactionCount = switch (range) {
      AiTimeRange.today => 6 + random.nextInt(10),
      AiTimeRange.last7Days => 28 + random.nextInt(18),
      AiTimeRange.month => 72 + random.nextInt(34),
      AiTimeRange.quarter => 180 + random.nextInt(80),
      AiTimeRange.custom => 36 + random.nextInt(16),
    };

    return SalonRevenueSummary(
      range: range,
      rangeLabel: _rangeLabel(timeframe),
      currencyCode: 'USD',
      grossSales: totalRevenue,
      transactionCount: transactionCount,
      averageTicket: totalRevenue / max(transactionCount, 1),
    );
  }

  @override
  Future<List<TopBarberSnapshot>> getTopBarbers({
    required String salonId,
    required AiTimeframe timeframe,
  }) async {
    final range = timeframe.range;
    final seed = salonId.codeUnits.fold<int>(7, (sum, unit) => sum + unit);
    final random = Random(seed + (range.index * 31));
    final names = <String>['Omar', 'Youssef', 'Adam', 'Zaid', 'Kareem'];

    final items = names
        .asMap()
        .entries
        .map((entry) {
          final rank = entry.key + 1;
          final baseRevenue = switch (range) {
            AiTimeRange.today => 280.0,
            AiTimeRange.last7Days => 1800.0,
            AiTimeRange.month => 3200.0,
            AiTimeRange.quarter => 7400.0,
            AiTimeRange.custom => 2100.0,
          };
          final variable = switch (range) {
            AiTimeRange.today => 180.0,
            AiTimeRange.last7Days => 850.0,
            AiTimeRange.month => 1700.0,
            AiTimeRange.quarter => 3200.0,
            AiTimeRange.custom => 1200.0,
          };
          final revenue =
              baseRevenue + (random.nextDouble() * variable) + (5 - rank) * 95;
          final completedSales = switch (range) {
            AiTimeRange.today => max(1, 7 - rank),
            AiTimeRange.last7Days => max(4, 15 - (rank * 2)),
            AiTimeRange.month => max(6, 24 - (rank * 3)),
            AiTimeRange.quarter => max(12, 62 - (rank * 6)),
            AiTimeRange.custom => max(5, 18 - (rank * 2)),
          };
          return TopBarberSnapshot(
            employeeId: 'barber_$rank',
            employeeName: entry.value,
            salesAmount: double.parse(revenue.toStringAsFixed(2)),
            transactionsCount: completedSales,
            averageTicket: revenue / completedSales,
            rank: rank,
          );
        })
        .toList(growable: false);

    items.sort((a, b) => b.salesAmount.compareTo(a.salesAmount));
    return items
        .asMap()
        .entries
        .map(
          (entry) => TopBarberSnapshot(
            employeeId: entry.value.employeeId,
            employeeName: entry.value.employeeName,
            photoUrl: entry.value.photoUrl,
            salesAmount: entry.value.salesAmount,
            transactionsCount: entry.value.transactionsCount,
            averageTicket: entry.value.averageTicket,
            rank: entry.key + 1,
          ),
        )
        .toList(growable: false);
  }
}

String _rangeLabel(AiTimeframe timeframe) {
  if (timeframe.hasCustomDateRange) {
    return '${_formatDate(timeframe.startDate!)}_${_formatDate(timeframe.endDate!)}';
  }
  if (timeframe.hasSpecificQuarter) {
    return '${timeframe.year}-Q${timeframe.quarter}';
  }
  if (timeframe.hasSpecificMonth) {
    return '${timeframe.year}-${timeframe.month!.toString().padLeft(2, '0')}';
  }

  return switch (timeframe.range) {
    AiTimeRange.today => 'today',
    AiTimeRange.last7Days => 'last_7_days',
    AiTimeRange.month => 'this_month',
    AiTimeRange.quarter => 'this_quarter',
    AiTimeRange.custom => 'custom_range',
  };
}

String _formatDate(DateTime value) {
  final year = value.year.toString().padLeft(4, '0');
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
