import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/formatting/app_money_format.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';
import '../../data/models/expense.dart';
import '../utils/expense_category_icon.dart';
import 'payment_method_chip.dart';

class RecentExpensesCard extends StatelessWidget {
  const RecentExpensesCard({
    super.key,
    required this.expenses,
    required this.currencyCode,
    this.onExpenseTap,
    this.onViewAll,
  });

  final List<Expense> expenses;
  final String currencyCode;
  final void Function(Expense expense)? onExpenseTap;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final empty = expenses.isEmpty;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.expensesScreenRecentTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColorsLight.textPrimary,
                    ),
                  ),
                ),
                if (!empty && onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: Text(
                      '${l10n.expensesScreenViewAll} ›',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppBrandColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.medium),
            if (empty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Text(
                      l10n.expensesScreenEmptyTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColorsLight.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.expensesScreenEmptyMessage,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColorsLight.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            else
              for (final e in expenses)
                _RecentExpenseTile(
                  expense: e,
                  currencyCode: currencyCode,
                  locale: locale,
                  l10n: l10n,
                  onTap: onExpenseTap != null ? () => onExpenseTap!(e) : null,
                ),
          ],
        ),
      ),
    );
  }
}

class _RecentExpenseTile extends StatelessWidget {
  const _RecentExpenseTile({
    required this.expense,
    required this.currencyCode,
    required this.locale,
    required this.l10n,
    this.onTap,
  });

  final Expense expense;
  final String currencyCode;
  final Locale locale;
  final AppLocalizations l10n;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final title = expense.title.trim().isEmpty
        ? l10n.expensesScreenUnknownExpense
        : expense.title;
    final category = expense.category.trim().isEmpty
        ? l10n.moneyDashboardUncategorized
        : expense.category;
    final dateStr = DateFormat.yMMMd(
      locale.toString(),
    ).format(expense.incurredAt.toLocal());

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFF3E8FF),
                  child: Icon(
                    expenseCategoryIcon(category, l10n),
                    color: const Color(0xFF7C3AED),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColorsLight.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateStr,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColorsLight.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      PaymentMethodChip(method: expense.paymentMethod),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatAppMoney(expense.amount, currencyCode, locale),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColorsLight.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Icon(
                      AppIcons.chevron_right_rounded,
                      size: 20,
                      color: scheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
