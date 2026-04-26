import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/payroll_ai_summary_model.dart';

class EmployeeSalaryNotesCard extends StatelessWidget {
  const EmployeeSalaryNotesCard({super.key, required this.summary});

  final PayrollAiSummaryModel summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final p = ZuranoPremiumUiColors.primaryPurple;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: p.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: p.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notes_rounded, color: p, size: 22),
              const SizedBox(width: 8),
              Text(
                l10n.employeePayrollSalaryNotesTitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: ZuranoPremiumUiColors.textPrimary,
                ),
              ),
            ],
          ),
          if (summary.summary.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              summary.summary.trim(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.4,
                color: ZuranoPremiumUiColors.textPrimary,
              ),
            ),
          ],
          if (summary.highlights.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...summary.highlights.map(
              (h) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline, size: 18, color: p),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        h,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(height: 1.35),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (summary.warnings.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...summary.warnings.map(
              (w) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Colors.orange.shade800,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        w,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.35,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
