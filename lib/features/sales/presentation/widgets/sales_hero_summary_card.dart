import 'package:flutter/material.dart';

import '../../../../core/formatting/app_money_format.dart';
import '../../domain/sales_summary_model.dart';

class SalesHeroSummaryCard extends StatelessWidget {
  const SalesHeroSummaryCard({
    super.key,
    required this.summary,
    required this.currencyCode,
    required this.locale,
    required this.totalSalesLabel,
    required this.comparisonLine,
    required this.metricTransactionsLabel,
    required this.metricAvgTicketLabel,
    required this.metricTopBarberLabel,
    required this.metricTopServiceLabel,
    required this.emptyMetric,
  });

  final SalesSummaryModel summary;
  final String currencyCode;
  final Locale locale;
  final String totalSalesLabel;
  final String comparisonLine;
  final String metricTransactionsLabel;
  final String metricAvgTicketLabel;
  final String metricTopBarberLabel;
  final String metricTopServiceLabel;
  final String emptyMetric;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PositionedDirectional(
            end: 0,
            top: 0,
            child: Icon(
              Icons.show_chart_rounded,
              size: 120,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                totalSalesLabel,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                formatAppMoney(summary.totalSales, currencyCode, locale),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 29,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      size: 16,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        comparisonLine,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _metric(
                      metricTransactionsLabel,
                      '${summary.transactionsCount}',
                    ),
                  ),
                  _divider(),
                  Expanded(
                    child: _metric(
                      metricAvgTicketLabel,
                      formatAppMoney(
                        summary.averageTicket,
                        currencyCode,
                        locale,
                      ),
                    ),
                  ),
                  _divider(),
                  Expanded(
                    child: _metric(
                      metricTopBarberLabel,
                      summary.topBarberName ?? emptyMetric,
                      small: true,
                    ),
                  ),
                  _divider(),
                  Expanded(
                    child: _metric(
                      metricTopServiceLabel,
                      summary.topServiceName ?? emptyMetric,
                      small: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
          PositionedDirectional(
            top: -4,
            end: -4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.insights_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 36,
    margin: const EdgeInsets.symmetric(horizontal: 6),
    color: Colors.white.withValues(alpha: 0.22),
  );

  Widget _metric(String label, String value, {bool small = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.72),
            fontSize: 10,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: small ? 2 : 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: small ? 11 : 13,
          ),
        ),
      ],
    );
  }
}
