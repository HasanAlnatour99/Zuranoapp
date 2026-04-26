import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/sales_filter.dart';

class SalesPeriodChips extends StatelessWidget {
  const SalesPeriodChips({
    super.key,
    required this.selected,
    required this.labels,
    required this.onChanged,
  });

  final SalesFilter selected;
  final Map<SalesFilter, String> labels;
  final ValueChanged<SalesFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Row(
        children: [
          for (final filter in SalesFilter.values) ...[
            if (filter != SalesFilter.values.first) const SizedBox(width: 10),
            ChoiceChip(
              showCheckmark: false,
              avatar: selected == filter
                  ? Icon(
                      Icons.calendar_month_rounded,
                      size: 18,
                      color: scheme.onPrimary,
                    )
                  : null,
              label: Text(labels[filter] ?? filter.name),
              selected: selected == filter,
              onSelected: (_) => onChanged(filter),
              selectedColor: FinanceDashboardColors.primaryPurple,
              backgroundColor: FinanceDashboardColors.lightPurple.withValues(
                alpha: 0.45,
              ),
              labelStyle: TextStyle(
                color: selected == filter
                    ? Colors.white
                    : FinanceDashboardColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: selected == filter
                      ? FinanceDashboardColors.primaryPurple
                      : FinanceDashboardColors.border,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
