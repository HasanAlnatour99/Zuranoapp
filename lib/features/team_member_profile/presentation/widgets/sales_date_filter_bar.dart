import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/team_member_sales_providers.dart';
import '../../data/models/sales_date_filter.dart';
import '../../../../l10n/app_localizations.dart';
import '../theme/team_member_profile_colors.dart';

class SalesDateFilterBar extends ConsumerWidget {
  const SalesDateFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final filter = ref.watch(teamSalesDateFilterProvider);

    Widget chip({
      required bool selected,
      required String label,
      required VoidCallback onSelected,
    }) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FilterChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => onSelected(),
          showCheckmark: false,
          selectedColor: TeamMemberProfileColors.softPurple,
          backgroundColor: TeamMemberProfileColors.card,
          side: BorderSide(
            color: selected
                ? TeamMemberProfileColors.primary
                : TeamMemberProfileColors.border,
          ),
          labelStyle: TextStyle(
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: selected
                ? TeamMemberProfileColors.primary
                : TeamMemberProfileColors.textSecondary,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          chip(
            selected: filter.kind == SalesDateFilterKind.thisMonth,
            label: l10n.teamMemberSalesFilterThisMonth,
            onSelected: () {
              ref
                  .read(teamSalesDateFilterProvider.notifier)
                  .setFilter(SalesDateFilter.thisMonth());
            },
          ),
          chip(
            selected: filter.kind == SalesDateFilterKind.today,
            label: l10n.teamMemberSalesFilterToday,
            onSelected: () {
              ref
                  .read(teamSalesDateFilterProvider.notifier)
                  .setFilter(SalesDateFilter.today());
            },
          ),
          chip(
            selected: filter.kind == SalesDateFilterKind.thisWeek,
            label: l10n.teamMemberSalesFilterThisWeek,
            onSelected: () {
              ref
                  .read(teamSalesDateFilterProvider.notifier)
                  .setFilter(SalesDateFilter.thisWeek());
            },
          ),
          chip(
            selected: filter.kind == SalesDateFilterKind.custom,
            label: l10n.teamMemberSalesFilterCustom,
            onSelected: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                initialDateRange: DateTimeRange(
                  start: filter.startInclusive,
                  end: filter.endExclusive.subtract(const Duration(days: 1)),
                ),
              );
              if (picked == null || !context.mounted) {
                return;
              }
              ref
                  .read(teamSalesDateFilterProvider.notifier)
                  .setFilter(
                    SalesDateFilter.custom(
                      rangeStartDay: picked.start,
                      rangeEndDay: picked.end,
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}
