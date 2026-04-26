import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/motion/app_motion_widgets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/salon_streams_provider.dart';
import '../../data/payroll_calculation_service.dart';
import '../../logic/payroll_run_review_controller.dart';
import 'payslip_screen.dart';
import '../widgets/payroll_status_chip.dart';
import '../widgets/payroll_summary_card.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class PayrollRunReviewScreen extends ConsumerWidget {
  const PayrollRunReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(payrollRunReviewControllerProvider);
    final controller = ref.read(payrollRunReviewControllerProvider.notifier);
    final employeesAsync = ref.watch(employeesStreamProvider);
    final currencyCode =
        ref.watch(sessionSalonStreamProvider).asData?.value?.currencyCode ??
        'USD';

    return Scaffold(
      appBar: AppPageHeader(title: Text(l10n.payrollRunReviewTitle)),
      body: employeesAsync.when(
        loading: () => const Center(child: AppLoadingIndicator(size: 36)),
        error: (_, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: AppEmptyState(
              title: l10n.payrollRunReviewTitle,
              message: l10n.payrollGenericError,
              icon: AppIcons.event_note_rounded,
              centerContent: true,
            ),
          ),
        ),
        data: (employees) {
          final eligible = employees
              .where(
                (employee) => employee.role != 'owner' && employee.isActive,
              )
              .toList(growable: false);

          return AppMotionPlayback(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.large),
              children: [
                AppEntranceMotion(
                  motionId: 'payroll-run-config',
                  child: AppSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.payrollFieldPayrollPeriod),
                          subtitle: Text(
                            DateFormat.yMMMM(
                              Localizations.localeOf(context).toString(),
                            ).format(state.period),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: state.period,
                                firstDate: DateTime(2024),
                                lastDate: DateTime(2100),
                                initialDatePickerMode: DatePickerMode.year,
                              );
                              if (picked != null) {
                                controller.selectPeriod(
                                  DateTime(picked.year, picked.month),
                                );
                              }
                            },
                            icon: const Icon(AppIcons.calendar_month_rounded),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.small),
                        Text(
                          l10n.payrollRunEmployeesLabel,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: AppSpacing.small),
                        Wrap(
                          spacing: AppSpacing.small,
                          runSpacing: AppSpacing.small,
                          children: [
                            FilterChip(
                              label: Text(l10n.payrollRunAllEmployees),
                              selected: state.selectedEmployeeIds.isEmpty,
                              onSelected: (_) =>
                                  controller.clearEmployeeFilter(),
                            ),
                            for (final employee in eligible)
                              FilterChip(
                                label: Text(employee.name),
                                selected: state.selectedEmployeeIds.contains(
                                  employee.id,
                                ),
                                onSelected: (_) =>
                                    controller.toggleEmployee(employee.id),
                              ),
                          ],
                        ),
                        if (state.error != null) ...[
                          const SizedBox(height: AppSpacing.medium),
                          Text(
                            state.error == 'missing'
                                ? l10n.payrollRunValidation
                                : state.error!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.medium),
                        AppPrimaryButton(
                          label: l10n.payrollActionCalculate,
                          isLoading: state.isBusy,
                          onPressed: controller.calculate,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.large),
                AppFadeThroughSwitcher(
                  transitionKey: state.bundle == null
                      ? 'run-review-empty'
                      : 'run-review-content',
                  child: state.bundle == null
                      ? AppEmptyState(
                          key: const ValueKey<String>('run-review-empty'),
                          title: l10n.payrollRunReviewEmptyTitle,
                          message: l10n.payrollRunReviewEmptySubtitle,
                          icon: AppIcons.calculate_outlined,
                          centerContent: true,
                        )
                      : _RunReviewContent(
                          key: const ValueKey<String>('run-review-content'),
                          currencyCode: currencyCode,
                          state: state,
                          onSaveDraft: controller.saveDraft,
                          onApprove: controller.approve,
                          onPay: controller.pay,
                          onRollback: state.savedRunId == null
                              ? null
                              : controller.rollback,
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

class _RunReviewContent extends StatelessWidget {
  const _RunReviewContent({
    super.key,
    required this.currencyCode,
    required this.state,
    required this.onSaveDraft,
    required this.onApprove,
    required this.onPay,
    this.onRollback,
  });

  final String currencyCode;
  final PayrollRunReviewState state;
  final Future<String?> Function() onSaveDraft;
  final Future<String?> Function() onApprove;
  final Future<String?> Function() onPay;
  final Future<bool> Function()? onRollback;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bundle = state.bundle!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.savedRunId != null) ...[
          PayrollStatusChip(status: bundle.run.status),
          const SizedBox(height: AppSpacing.medium),
        ],
        Row(
          children: [
            Expanded(
              child: AppEntranceMotion(
                motionId: 'run-review-net-pay',
                child: PayrollSummaryCard(
                  label: l10n.payrollSummaryNetPay,
                  value: bundle.run.netPay,
                  currencyCode: currencyCode,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.medium),
            Expanded(
              child: AppEntranceMotion(
                motionId: 'run-review-employee-count',
                index: 1,
                child: PayrollSummaryCard(
                  label: l10n.payrollRunEmployeesLabel,
                  value: bundle.run.employeeCount.toDouble(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.large),
        for (final statement in bundle.employeeStatements) ...[
          AppEntranceMotion(
            motionId: 'run-review-statement-${statement.employee.id}',
            index: bundle.employeeStatements.indexOf(statement),
            slideOffset: 8,
            child: _StatementReviewCard(
              statement: statement,
              savedRunId: state.savedRunId,
              title: l10n.payrollPayslipTitle,
              summaryLabel: l10n.payrollRunEmployeeSummary(
                statement.results.length,
                statement.netPay.toStringAsFixed(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
        ],
        AppPrimaryButton(
          label: l10n.payrollActionSaveDraft,
          isLoading: state.isBusy,
          onPressed: () async {
            await onSaveDraft();
          },
        ),
        const SizedBox(height: AppSpacing.medium),
        AppPrimaryButton(
          label: l10n.payrollActionApprove,
          isLoading: state.isBusy,
          onPressed: () async {
            await onApprove();
          },
        ),
        const SizedBox(height: AppSpacing.medium),
        AppPrimaryButton(
          label: l10n.payrollActionPay,
          isLoading: state.isBusy,
          onPressed: () async {
            await onPay();
          },
        ),
        if (onRollback != null) ...[
          const SizedBox(height: AppSpacing.medium),
          OutlinedButton(
            onPressed: state.isBusy
                ? null
                : () async {
                    await onRollback!();
                  },
            child: Text(l10n.payrollActionRollback),
          ),
        ],
      ],
    );
  }
}

class _StatementReviewCard extends StatelessWidget {
  const _StatementReviewCard({
    required this.statement,
    required this.savedRunId,
    required this.title,
    required this.summaryLabel,
  });

  final PayrollEmployeeStatement statement;
  final String? savedRunId;
  final String title;
  final String summaryLabel;

  @override
  Widget build(BuildContext context) {
    final cardChild = AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            statement.employee.name,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.small / 2),
          Text(summaryLabel),
          if (savedRunId != null) ...[
            const SizedBox(height: AppSpacing.small),
            TextButton(onPressed: null, child: Text(title)),
          ],
        ],
      ),
    );

    if (savedRunId == null) {
      return cardChild;
    }

    return AppOpenContainerRoute(
      closedBuilder: (context, openContainer) => AppSurfaceCard(
        onTap: openContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              statement.employee.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.small / 2),
            Text(summaryLabel),
            const SizedBox(height: AppSpacing.small),
            TextButton(onPressed: openContainer, child: Text(title)),
          ],
        ),
      ),
      openBuilder: (context, _) => PayslipScreen(
        runId: savedRunId!,
        employeeId: statement.employee.id,
        employeeName: statement.employee.name,
      ),
    );
  }
}
