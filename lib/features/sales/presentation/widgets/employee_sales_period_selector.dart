import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/employee_sales_period.dart';
import '../providers/employee_sales_period_notifier.dart';

class EmployeeSalesPeriodSelector extends ConsumerWidget {
  const EmployeeSalesPeriodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selected = ref.watch(employeeSalesPeriodProvider);
    final notifier = ref.read(employeeSalesPeriodProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: SegmentedButton<EmployeeSalesPeriod>(
        segments: [
          ButtonSegment(
            value: EmployeeSalesPeriod.today,
            label: Text(l10n.salesDateToday),
          ),
          ButtonSegment(
            value: EmployeeSalesPeriod.week,
            label: Text(l10n.teamMemberSalesFilterThisWeek),
          ),
          ButtonSegment(
            value: EmployeeSalesPeriod.month,
            label: Text(l10n.teamMemberSalesFilterThisMonth),
          ),
        ],
        selected: {selected},
        onSelectionChanged: (s) => notifier.setPeriod(s.first),
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFF5B21B6);
            }
            return Colors.grey.shade600;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFFF4ECFF);
            }
            return Colors.white;
          }),
        ),
      ),
    );
  }
}
