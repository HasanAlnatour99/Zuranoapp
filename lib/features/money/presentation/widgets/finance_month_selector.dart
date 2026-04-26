import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../logic/money_dashboard_providers.dart';

class FinanceMonthSelector extends ConsumerWidget {
  const FinanceMonthSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context);
    final months = ref.watch(moneyMonthOptionsProvider);
    final selected = ref.watch(moneySelectedMonthProvider);

    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: months.length,
        itemBuilder: (context, index) {
          final month = months[index];
          final selectedHere =
              month.year == selected.year && month.month == selected.month;
          final label = DateFormat.MMM(locale.toString()).format(month);
          return Padding(
            padding: EdgeInsetsDirectional.only(start: index == 0 ? 0 : 10),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => ref
                    .read(moneySelectedMonthProvider.notifier)
                    .selectMonth(month),
                borderRadius: BorderRadius.circular(22),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: selectedHere
                        ? const LinearGradient(
                            colors: [
                              FinanceDashboardColors.primaryPurple,
                              FinanceDashboardColors.deepPurple,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: selectedHere ? null : FinanceDashboardColors.surface,
                    border: Border.all(
                      color: selectedHere
                          ? Colors.transparent
                          : FinanceDashboardColors.border,
                    ),
                    boxShadow: selectedHere
                        ? [
                            BoxShadow(
                              color: FinanceDashboardColors.primaryPurple
                                  .withValues(alpha: 0.28),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selectedHere) ...[
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 18,
                          color: Colors.white.withValues(alpha: 0.95),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: selectedHere
                              ? Colors.white
                              : FinanceDashboardColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
