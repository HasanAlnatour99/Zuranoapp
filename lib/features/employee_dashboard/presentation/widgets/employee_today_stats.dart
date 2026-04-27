import 'package:flutter/material.dart';

import '../../../../core/formatting/app_money_format.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/zurano_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/employee_today_summary_model.dart';

class EmployeeTodayStats extends StatelessWidget {
  const EmployeeTodayStats({
    super.key,
    required this.summary,
    this.currencyCode = 'USD',
  });

  final EmployeeTodaySummaryModel summary;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final code = currencyCode.trim().isEmpty ? 'USD' : currencyCode.trim();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.employeeTodayStatsTitle,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: ZuranoPremiumUiColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ZuranoCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.content_cut_rounded,
                        color: ZuranoPremiumUiColors.primaryPurple,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${summary.servicesCount}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        l10n.employeeSalesKpiServices,
                        style: TextStyle(
                          fontSize: 12,
                          color: ZuranoPremiumUiColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ZuranoCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        color: Color(0xFF16A34A),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatMoney(
                          summary.salesTotal,
                          code,
                          Localizations.localeOf(context),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        l10n.employeeTodayStatsSalesLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: ZuranoPremiumUiColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ZuranoCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        color: Color(0xFF3B82F6),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        summary.workedHoursLabel,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        l10n.employeeTodayStatsHoursLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: ZuranoPremiumUiColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
