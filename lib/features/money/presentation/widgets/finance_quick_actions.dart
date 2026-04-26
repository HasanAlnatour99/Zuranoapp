import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';
import 'premium_finance_card.dart';

class FinanceQuickActions extends StatelessWidget {
  const FinanceQuickActions({
    super.key,
    required this.payrollTitle,
    required this.payrollSubtitle,
    required this.salesTitle,
    required this.salesSubtitle,
    required this.expensesTitle,
    required this.expensesSubtitle,
    required this.onPayroll,
    required this.onSales,
    required this.onExpenses,
  });

  final String payrollTitle;
  final String payrollSubtitle;
  final String salesTitle;
  final String salesSubtitle;
  final String expensesTitle;
  final String expensesSubtitle;
  final VoidCallback onPayroll;
  final VoidCallback onSales;
  final VoidCallback onExpenses;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _QuickActionTile(
          icon: AppIcons.payments_outlined,
          title: payrollTitle,
          subtitle: payrollSubtitle,
          onTap: onPayroll,
          wide: true,
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _QuickActionTile(
                icon: AppIcons.receipt_long_outlined,
                title: salesTitle,
                subtitle: salesSubtitle,
                onTap: onSales,
                accent: const Color(0xFF16A34A),
                accentSoft: const Color(0xFFEFFBF4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionTile(
                icon: AppIcons.wallet_outlined,
                title: expensesTitle,
                subtitle: expensesSubtitle,
                onTap: onExpenses,
                accent: FinanceDashboardColors.expensePink,
                accentSoft: FinanceDashboardColors.expensePinkSoft,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.wide = false,
    this.accent,
    this.accentSoft,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool wide;
  final Color? accent;
  final Color? accentSoft;

  @override
  Widget build(BuildContext context) {
    final primary = accent ?? FinanceDashboardColors.primaryPurple;
    final soft = accentSoft ?? FinanceDashboardColors.lightPurple;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: PremiumFinanceCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: soft.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: primary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: FinanceDashboardColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: wide ? 2 : 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                        color: FinanceDashboardColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (wide) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: FinanceDashboardColors.textSecondary.withValues(
                    alpha: 0.7,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
