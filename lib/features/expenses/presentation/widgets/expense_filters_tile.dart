import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatting/sale_payment_method_localized.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_modal_sheet.dart';
import '../../../../core/widgets/keyboard_safe_form_scaffold.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';
import '../providers/expense_providers.dart';

class ExpenseFiltersTile extends ConsumerWidget {
  const ExpenseFiltersTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final filters = ref.watch(expensesFiltersProvider);
    final hasFilters =
        filters.category != null ||
        filters.paymentMethod != null ||
        filters.createdByUid != null;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _openFilters(context),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.medium,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: hasFilters
                  ? const Color(0xFF7C3AED).withValues(alpha: 0.36)
                  : const Color(0xFFE5E7EB),
            ),
            gradient: hasFilters
                ? LinearGradient(
                    colors: [
                      const Color(0xFF7C3AED).withValues(alpha: 0.05),
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: Row(
            children: [
              Badge(
                isLabelVisible: hasFilters,
                smallSize: 8,
                child: Icon(
                  AppIcons.tune_rounded,
                  size: 22,
                  color: hasFilters
                      ? const Color(0xFF7C3AED)
                      : AppColorsLight.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.expensesScreenFiltersButton,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColorsLight.textPrimary,
                  ),
                ),
              ),
              Icon(
                AppIcons.chevron_right_rounded,
                color: AppColorsLight.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _openFilters(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return showAppModalBottomSheet<void>(
    context: context,
    expand: false,
    builder: (modalContext) {
      return Consumer(
        builder: (context, ref, _) {
          final theme = Theme.of(context);
          final filters = ref.watch(expensesFiltersProvider);
          final categories = ref.watch(expensesCategoryOptionsProvider);
          final paymentMethods = ref.watch(expensePaymentMethodOptionsProvider);
          final creators = ref.watch(expenseCreatedByFilterOptionsProvider);

          return KeyboardSafeModalFormScroll(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.large,
              AppSpacing.small,
              AppSpacing.large,
              AppSpacing.large + kKeyboardSafePaddingExtra,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4ECFF),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE9DDFE)),
                      ),
                      child: const Icon(
                        AppIcons.tune_rounded,
                        color: Color(0xFF7C3AED),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.expensesScreenFiltersSheetTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(modalContext).maybePop(),
                      icon: const Icon(AppIcons.close_rounded),
                      tooltip: MaterialLocalizations.of(
                        modalContext,
                      ).closeButtonTooltip,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.medium),
                _FiltersSectionCard(
                  title: l10n.ownerOverviewAddExpenseCategoryField,
                  child: Wrap(
                    spacing: AppSpacing.small,
                    runSpacing: AppSpacing.small,
                    children: [
                      _FilterOptionChip(
                        label: l10n.expensesScreenAllCategories,
                        selected: filters.category == null,
                        onTap: () {
                          ref
                              .read(expensesFiltersProvider.notifier)
                              .setCategory(null);
                        },
                      ),
                      for (final c in categories)
                        _FilterOptionChip(
                          label: c,
                          selected: filters.category == c,
                          onTap: () {
                            ref
                                .read(expensesFiltersProvider.notifier)
                                .setCategory(filters.category == c ? null : c);
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.large),
                _FiltersSectionCard(
                  title: l10n.addSalePaymentMethodField,
                  child: Wrap(
                    spacing: AppSpacing.small,
                    runSpacing: AppSpacing.small,
                    children: [
                      _FilterOptionChip(
                        label: l10n.salesScreenAllPayments,
                        selected: filters.paymentMethod == null,
                        onTap: () {
                          ref
                              .read(expensesFiltersProvider.notifier)
                              .setPaymentMethod(null);
                        },
                      ),
                      for (final m in paymentMethods)
                        _FilterOptionChip(
                          label: localizedSalePaymentMethod(l10n, m),
                          selected: filters.paymentMethod == m,
                          onTap: () {
                            ref
                                .read(expensesFiltersProvider.notifier)
                                .setPaymentMethod(
                                  filters.paymentMethod == m ? null : m,
                                );
                          },
                        ),
                    ],
                  ),
                ),
                if (creators.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.large),
                  _FiltersSectionCard(
                    title: l10n.expensesScreenRecordedByLabel,
                    child: Wrap(
                      spacing: AppSpacing.small,
                      runSpacing: AppSpacing.small,
                      children: [
                        _FilterOptionChip(
                          label: l10n.expensesScreenAllCreators,
                          selected: filters.createdByUid == null,
                          onTap: () {
                            ref
                                .read(expensesFiltersProvider.notifier)
                                .setCreatedByUid(null);
                          },
                        ),
                        for (final c in creators)
                          _FilterOptionChip(
                            label: c.name,
                            selected: filters.createdByUid == c.uid,
                            onTap: () {
                              ref
                                  .read(expensesFiltersProvider.notifier)
                                  .setCreatedByUid(
                                    filters.createdByUid == c.uid
                                        ? null
                                        : c.uid,
                                  );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.large),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          side: BorderSide(
                            color: const Color(
                              0xFF7C3AED,
                            ).withValues(alpha: 0.45),
                          ),
                          foregroundColor: const Color(0xFF7C3AED),
                        ),
                        onPressed: () {
                          ref
                              .read(expensesFiltersProvider.notifier)
                              .clearFilters();
                        },
                        child: Text(l10n.expensesScreenClearFilters),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          backgroundColor: const Color(0xFF7C3AED),
                        ),
                        onPressed: () => Navigator.of(modalContext).maybePop(),
                        child: Text(l10n.expensesScreenApplyFilters),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _FiltersSectionCard extends StatelessWidget {
  const _FiltersSectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9DDFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _FilterOptionChip extends StatelessWidget {
  const _FilterOptionChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFF7C3AED) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? const Color(0xFF7C3AED)
                  : const Color(0xFFD1D5DB),
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.24),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ),
              if (selected) ...[
                const SizedBox(width: 6),
                const Icon(Icons.check_rounded, size: 16, color: Colors.white),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
