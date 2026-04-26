import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/payroll_statuses.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/payslip_model.dart';

class RecentPayslipTile extends StatelessWidget {
  const RecentPayslipTile({
    super.key,
    required this.payslip,
    required this.currency,
    required this.onTap,
  });

  final PayslipModel payslip;
  final String currency;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final month = DateFormat.yMMMM(
      locale.toString(),
    ).format(DateTime(payslip.year, payslip.month));
    final range = l10n.employeePayrollPeriod(
      DateFormat.MMMd(locale.toString()).format(payslip.periodStart),
      DateFormat.MMMd(locale.toString()).format(payslip.periodEnd),
    );
    final paid = payslip.status == PayrollStatuses.paid;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ZuranoPremiumUiColors.primaryPurple.withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.calendar_month_outlined,
                  color: ZuranoPremiumUiColors.primaryPurple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      month,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      range,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ZuranoPremiumUiColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${payslip.netPay.toStringAsFixed(0)} $currency',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      paid
                          ? l10n.employeePayrollStatusPaid
                          : l10n.employeePayrollStatusApproved,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: ZuranoPremiumUiColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
