import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/sales_vs_expenses_point.dart';

class SalesVsExpensesChart extends StatelessWidget {
  const SalesVsExpensesChart({
    super.key,
    required this.points,
    required this.title,
    required this.periodLabel,
    required this.salesLegend,
    required this.expensesLegend,
    required this.currencyCode,
    required this.locale,
  });

  final List<SalesVsExpensesPoint> points;
  final String title;
  final String periodLabel;
  final String salesLegend;
  final String expensesLegend;
  final String currencyCode;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const SizedBox.shrink();
    }
    final n = points.length;
    final salesSpots = <FlSpot>[
      for (var i = 0; i < n; i++) FlSpot(i.toDouble(), points[i].salesTotal),
    ];
    final expenseSpots = <FlSpot>[
      for (var i = 0; i < n; i++) FlSpot(i.toDouble(), points[i].expensesTotal),
    ];

    var maxVal = 0.0;
    for (final p in points) {
      if (p.salesTotal > maxVal) maxVal = p.salesTotal;
      if (p.expensesTotal > maxVal) maxVal = p.expensesTotal;
    }
    final maxY = maxVal <= 0
        ? 100.0
        : (maxVal * 1.15).clamp(50.0, double.infinity);

    final labelIndices = <int>{0, (n - 1) ~/ 2, n - 1};

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: FinanceDashboardColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: FinanceDashboardColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: FinanceDashboardColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: FinanceDashboardColors.lightPurple.withValues(
                    alpha: 0.35,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: FinanceDashboardColors.border),
                ),
                child: Text(
                  periodLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: FinanceDashboardColors.deepPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _legendDot(FinanceDashboardColors.primaryPurple, salesLegend),
              const SizedBox(width: 16),
              _legendDot(FinanceDashboardColors.expensePink, expensesLegend),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY > 0 ? maxY / 4 : 25,
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: FinanceDashboardColors.border.withValues(alpha: 0.6),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      interval: maxY > 0 ? maxY / 4 : 25,
                      getTitlesWidget: (v, m) => Text(
                        NumberFormat.compact(
                          locale: locale.toString(),
                        ).format(v),
                        style: const TextStyle(
                          fontSize: 10,
                          color: FinanceDashboardColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 1,
                      getTitlesWidget: (v, m) {
                        final i = v.round();
                        if (i < 0 || i >= n || !labelIndices.contains(i)) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          DateFormat.MMMd(
                            locale.toString(),
                          ).format(points[i].date),
                          style: const TextStyle(
                            fontSize: 10,
                            color: FinanceDashboardColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (n - 1).toDouble(),
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: salesSpots,
                    isCurved: true,
                    color: FinanceDashboardColors.primaryPurple,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          FinanceDashboardColors.primaryPurple.withValues(
                            alpha: 0.22,
                          ),
                          FinanceDashboardColors.primaryPurple.withValues(
                            alpha: 0.02,
                          ),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: expenseSpots,
                    isCurved: true,
                    color: FinanceDashboardColors.expensePink,
                    barWidth: 2,
                    dashArray: [5, 4],
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color c, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: FinanceDashboardColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
