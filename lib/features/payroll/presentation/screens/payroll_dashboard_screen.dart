import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/motion/app_motion_widgets.dart';
import '../../../../core/formatting/app_money_format.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/salon_streams_provider.dart';
import '../../logic/payroll_dashboard_providers.dart';
import '../widgets/payroll_status_chip.dart';
import '../widgets/payroll_summary_card.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class PayrollDashboardScreen extends ConsumerWidget {
  const PayrollDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final currencyCode =
        ref.watch(sessionSalonStreamProvider).asData?.value?.currencyCode ??
        'USD';
    final summaryAsync = ref.watch(payrollDashboardSummaryProvider);
    final breakdownAsync = ref.watch(payrollStatusBreakdownProvider);
    final missingAsync = ref.watch(employeesMissingPayrollSetupProvider);

    return Scaffold(
      appBar: AppPageHeader(
        title: Text(l10n.payrollDashboardTitle),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.ownerPayrollElements),
            icon: const Icon(AppIcons.tune_rounded),
            tooltip: l10n.payrollElementsTitle,
          ),
        ],
      ),
      body: summaryAsync.when(
        loading: () => const Center(child: AppLoadingIndicator(size: 36)),
        error: (_, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: AppEmptyState(
              title: l10n.payrollDashboardTitle,
              message: l10n.payrollGenericError,
              icon: AppIcons.payments_outlined,
              centerContent: true,
            ),
          ),
        ),
        data: (summary) {
          final breakdown = breakdownAsync.asData?.value;
          final missing = missingAsync.asData?.value ?? const [];

          return AppMotionPlayback(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.large),
              children: [
                Text(
                  l10n.payrollDashboardSubtitle(
                    DateFormat.yMMMM(locale.toString()).format(summary.month),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.large),
                Wrap(
                  spacing: AppSpacing.medium,
                  runSpacing: AppSpacing.medium,
                  children: [
                    AppEntranceMotion(
                      motionId: 'payroll-summary-net',
                      child: SizedBox(
                        width: 172,
                        child: PayrollSummaryCard(
                          label: l10n.payrollSummaryNetPay,
                          value: summary.totalNetPay,
                          currencyCode: currencyCode,
                        ),
                      ),
                    ),
                    AppEntranceMotion(
                      motionId: 'payroll-summary-earnings',
                      index: 1,
                      child: SizedBox(
                        width: 172,
                        child: PayrollSummaryCard(
                          label: l10n.payrollSummaryEarnings,
                          value: summary.totalEarnings,
                          currencyCode: currencyCode,
                        ),
                      ),
                    ),
                    AppEntranceMotion(
                      motionId: 'payroll-summary-deductions',
                      index: 2,
                      child: SizedBox(
                        width: 172,
                        child: PayrollSummaryCard(
                          label: l10n.payrollSummaryDeductions,
                          value: summary.totalDeductions,
                          currencyCode: currencyCode,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.large),
                AppEntranceMotion(
                  motionId: 'payroll-actions',
                  index: 3,
                  child: Row(
                    children: [
                      Expanded(
                        child: _ActionCard(
                          icon: AppIcons.flash_on_rounded,
                          title: l10n.payrollQuickPayTitle,
                          subtitle: l10n.payrollQuickPayShortcutSubtitle,
                          onTap: () => context.push(AppRoutes.ownerQuickPay),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.medium),
                      Expanded(
                        child: _ActionCard(
                          icon: AppIcons.event_note_rounded,
                          title: l10n.payrollRunReviewTitle,
                          subtitle: l10n.payrollRunShortcutSubtitle,
                          onTap: () =>
                              context.push(AppRoutes.ownerPayrollRunReview),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.large),
                AppEntranceMotion(
                  motionId: 'payroll-breakdown-card',
                  index: 4,
                  child: AppSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.payrollStatusBreakdownTitle,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        if (breakdown == null)
                          const AppLoadingIndicator()
                        else
                          Wrap(
                            spacing: AppSpacing.small,
                            runSpacing: AppSpacing.small,
                            children: [
                              _CountChip(
                                label: l10n.payrollStatusDraft,
                                count: breakdown.draft,
                              ),
                              _CountChip(
                                label: l10n.payrollStatusApproved,
                                count: breakdown.approved,
                              ),
                              _CountChip(
                                label: l10n.payrollStatusPaid,
                                count: breakdown.paid,
                              ),
                              _CountChip(
                                label: l10n.payrollStatusRolledBack,
                                count: breakdown.rolledBack,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.large),
                AppEntranceMotion(
                  motionId: 'payroll-recent-runs-card',
                  index: 5,
                  child: AppSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.payrollRecentRunsTitle,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        if (summary.recentRuns.isEmpty)
                          Text(l10n.payrollRecentRunsEmpty)
                        else
                          for (
                            var i = 0;
                            i < summary.recentRuns.length;
                            i++
                          ) ...[
                            if (i > 0) const Divider(height: AppSpacing.large),
                            AppEntranceMotion(
                              motionId:
                                  'payroll-run-row-${summary.recentRuns[i].year}-${summary.recentRuns[i].month}-$i',
                              index: i,
                              duration: const Duration(milliseconds: 220),
                              slideOffset: 8,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          summary.recentRuns[i].employeeName
                                                      ?.trim()
                                                      .isNotEmpty ==
                                                  true
                                              ? summary
                                                    .recentRuns[i]
                                                    .employeeName!
                                              : l10n.payrollRunGroupLabel(
                                                  summary
                                                      .recentRuns[i]
                                                      .employeeCount,
                                                ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormat.yMMMM(
                                            locale.toString(),
                                          ).format(
                                            DateTime(
                                              summary.recentRuns[i].year,
                                              summary.recentRuns[i].month,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      PayrollStatusChip(
                                        status: summary.recentRuns[i].status,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        formatAppMoney(
                                          summary.recentRuns[i].netPay,
                                          currencyCode,
                                          locale,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.large),
                AppEntranceMotion(
                  motionId: 'payroll-missing-setup-card',
                  index: 6,
                  child: AppSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.payrollMissingSetupTitle,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        if (missingAsync.isLoading)
                          const AppLoadingIndicator()
                        else if (missing.isEmpty)
                          Text(l10n.payrollMissingSetupEmpty)
                        else
                          for (var i = 0; i < missing.length; i++) ...[
                            if (i > 0) const Divider(height: AppSpacing.large),
                            AppEntranceMotion(
                              motionId: 'payroll-missing-${missing[i].id}',
                              index: i,
                              duration: const Duration(milliseconds: 220),
                              slideOffset: 8,
                              child: Row(
                                children: [
                                  Expanded(child: Text(missing[i].name)),
                                  TextButton(
                                    onPressed: () {
                                      context.push(
                                        AppRoutes.ownerEmployeePayrollSetup(
                                          missing[i].id,
                                        ),
                                      );
                                    },
                                    child: Text(l10n.payrollActionSetUp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return AppSurfaceCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: scheme.primary),
          const SizedBox(height: AppSpacing.medium),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.small / 2),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          '$label · $count',
          style: theme.textTheme.labelLarge?.copyWith(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
