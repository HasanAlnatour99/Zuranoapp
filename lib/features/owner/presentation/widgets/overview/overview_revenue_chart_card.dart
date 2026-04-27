import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../../core/formatting/app_money_format.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../logic/owner_overview_state.dart';
import 'dashboard_section_card.dart';
import 'overview_design_tokens.dart';

/// Last 7 days completed sales as a compact purple line chart.
class OverviewRevenueChartCard extends StatelessWidget {
  const OverviewRevenueChartCard({
    super.key,
    required this.state,
    required this.locale,
  });

  final OwnerOverviewState state;
  final Locale locale;

  static const double _chartHeight = 132;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final series = state.last7DaysDailyRevenue;
    final safe = series.length == 7 ? series : List<double>.filled(7, 0);
    final total = safe.fold<double>(0, (a, b) => a + b);
    final totalLabel = formatAppMoney(total, state.currencyCode, locale);
    final maxY = safe.reduce((a, b) => a > b ? a : b);
    final top = maxY <= 0 ? 1.0 : maxY * 1.15;
    final hasRevenue = safe.any((value) => value > 0);

    final today = DateTime.now();
    final spots = <FlSpot>[
      for (var i = 0; i < 7; i++) FlSpot(i.toDouble(), safe[i]),
    ];

    return DashboardSectionCard(
      margin: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.ownerOverviewRevenueThisWeekTitle,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: OwnerOverviewTypography.chartTitle,
                        fontWeight: FontWeight.w900,
                        color: OwnerOverviewTokens.textPrimary,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      l10n.ownerOverviewRevenueThisWeekSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                        fontSize: OwnerOverviewTypography.chartSubtitle,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(12),
              Text(
                l10n.ownerOverviewRevenueThisWeekTotal(totalLabel),
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: OwnerOverviewTypography.chartBadge,
                  fontWeight: FontWeight.w800,
                  color: OwnerOverviewTokens.purple,
                ),
              ),
            ],
          ),
          const Gap(14),
          SizedBox(
            height: _chartHeight,
            child: hasRevenue
                ? LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: 6,
                      minY: 0,
                      maxY: top,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: scheme.outlineVariant.withValues(alpha: 0.45),
                          strokeWidth: 0.8,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            interval: 1,
                            getTitlesWidget: (v, meta) {
                              final i = v.round().clamp(0, 6);
                              final day = today.subtract(Duration(days: 6 - i));
                              final t = DateFormat.E(
                                locale.toString(),
                              ).format(day);
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  t,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        fontSize: OwnerOverviewTypography
                                            .chartAxis,
                                        color: const Color(0xFF9CA3AF),
                                      ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      lineTouchData: LineTouchData(
                        enabled: true,
                        handleBuiltInTouches: true,
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (spots) {
                            return spots.map((s) {
                              final v = formatAppMoney(
                                s.y,
                                state.currencyCode,
                                locale,
                              );
                              return LineTooltipItem(
                                v,
                                TextStyle(
                                  color: scheme.onInverseSurface,
                                  fontWeight: FontWeight.w600,
                                  fontSize: OwnerOverviewTypography.chartTooltip,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: OwnerOverviewTokens.purple,
                          barWidth: 3,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (s, p, b, i) => FlDotCirclePainter(
                              radius: 3,
                              color: Colors.white,
                              strokeWidth: 2,
                              strokeColor: OwnerOverviewTokens.purple,
                            ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                OwnerOverviewTokens.purple.withValues(
                                  alpha: 0.2,
                                ),
                                OwnerOverviewTokens.purple.withValues(
                                  alpha: 0.02,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.show_chart,
                          color: OwnerOverviewTokens.purple.withValues(
                            alpha: 0.42,
                          ),
                          size: 30,
                        ),
                        const Gap(8),
                        Text(
                          l10n.ownerOverviewRevenueThisWeekEmpty,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: const Color(0xFF6B7280),
                                fontWeight: FontWeight.w600,
                                fontSize: OwnerOverviewTypography.chartSubtitle,
                              ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
