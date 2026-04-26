import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';
import '../providers/expense_providers.dart';
import '../../domain/expense_filter_state.dart';

class ExpenseDateRangeSelector extends ConsumerWidget {
  const ExpenseDateRangeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selected = ref.watch(expensesFiltersProvider).datePreset;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _rangeChip(
          context,
          ref,
          label: l10n.salesDateToday,
          preset: ExpensesDatePreset.today,
          selected: selected,
        ),
        _rangeChip(
          context,
          ref,
          label: l10n.salesDateThisWeek,
          preset: ExpensesDatePreset.thisWeek,
          selected: selected,
        ),
        _rangeChip(
          context,
          ref,
          label: l10n.salesDateThisMonth,
          preset: ExpensesDatePreset.thisMonth,
          selected: selected,
        ),
        _rangeChip(
          context,
          ref,
          label: l10n.salesDateCustom,
          preset: ExpensesDatePreset.custom,
          selected: selected,
        ),
      ],
    );
  }

  Widget _rangeChip(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required ExpensesDatePreset preset,
    required ExpensesDatePreset selected,
  }) {
    final isSelected = selected == preset;
    return FilterChip(
      avatar: Icon(
        AppIcons.calendar_month_rounded,
        size: 18,
        color: isSelected ? Colors.white : AppColorsLight.textPrimary,
      ),
      label: Text(label),
      selected: isSelected,
      showCheckmark: false,
      selectedColor: AppBrandColors.primary,
      backgroundColor: Colors.white,
      side: BorderSide(
        color: isSelected ? AppBrandColors.primary : const Color(0xFFE5E7EB),
      ),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColorsLight.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      onSelected: (_) async {
        ref.read(expensesFiltersProvider.notifier).setDatePreset(preset);
        if (preset == ExpensesDatePreset.custom) {
          final filters = ref.read(expensesFiltersProvider);
          final picked = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
            initialDateRange: filters.customRange,
          );
          if (context.mounted) {
            ref.read(expensesFiltersProvider.notifier).setCustomRange(picked);
          }
        }
      },
    );
  }
}
