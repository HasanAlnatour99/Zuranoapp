import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_select_field.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../../../../core/widgets/keyboard_safe_form_scaffold.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/salon_streams_provider.dart';
import '../../data/payroll_constants.dart';
import '../../logic/quickpay_controller.dart';
import '../widgets/payroll_result_line_tile.dart';
import '../widgets/payroll_section_card.dart';
import '../widgets/payroll_summary_card.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class QuickPayScreen extends ConsumerWidget {
  const QuickPayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(quickPayControllerProvider);
    final controller = ref.read(quickPayControllerProvider.notifier);
    final employeesAsync = ref.watch(employeesStreamProvider);
    final currencyCode =
        ref.watch(sessionSalonStreamProvider).asData?.value?.currencyCode ??
        'USD';

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppPageHeader(title: Text(l10n.payrollQuickPayTitle)),
      body: employeesAsync.when(
        loading: () => const Center(child: AppLoadingIndicator(size: 36)),
        error: (_, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: AppEmptyState(
              title: l10n.payrollQuickPayTitle,
              message: l10n.payrollGenericError,
              icon: AppIcons.flash_on_rounded,
            ),
          ),
        ),
        data: (employees) {
          final eligibleEmployees = employees
              .where(
                (employee) => employee.role != 'owner' && employee.isActive,
              )
              .toList(growable: false);

          return ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(
              AppSpacing.large,
              AppSpacing.large,
              AppSpacing.large,
              MediaQuery.viewInsetsOf(context).bottom +
                  AppSpacing.large +
                  kKeyboardSafePaddingExtra,
            ),
            children: [
              AppSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSelectField<String>(
                      label: l10n.payrollFieldEmployee,
                      value: state.selectedEmployeeId,
                      onChanged: controller.selectEmployee,
                      options: eligibleEmployees
                          .map(
                            (employee) => AppSelectOption(
                              value: employee.id,
                              label: employee.name,
                            ),
                          )
                          .toList(growable: false),
                    ),
                    const SizedBox(height: AppSpacing.medium),
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
                    if (state.error != null) ...[
                      const SizedBox(height: AppSpacing.small),
                      Text(
                        state.error == 'missing'
                            ? l10n.payrollQuickPayValidation
                            : state.error!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
              const SizedBox(height: AppSpacing.large),
              if (state.bundle == null)
                AppEmptyState(
                  title: l10n.payrollQuickPayStatementEmptyTitle,
                  message: l10n.payrollQuickPayStatementEmptySubtitle,
                  icon: AppIcons.calculate_outlined,
                )
              else
                _QuickPayStatement(
                  currencyCode: currencyCode,
                  onSaveDraft: controller.saveDraft,
                  onApprove: controller.approve,
                  onPay: controller.pay,
                  onRollback: state.savedRunId == null
                      ? null
                      : controller.rollback,
                  onOpenPayslip: state.savedRunId == null
                      ? null
                      : () {
                          context.push(
                            AppRoutes.payrollPayslip(
                              state.savedRunId!,
                              state
                                  .bundle!
                                  .employeeStatements
                                  .first
                                  .employee
                                  .id,
                            ),
                          );
                        },
                  state: state,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _QuickPayStatement extends StatelessWidget {
  const _QuickPayStatement({
    required this.currencyCode,
    required this.onSaveDraft,
    required this.onApprove,
    required this.onPay,
    required this.state,
    this.onRollback,
    this.onOpenPayslip,
  });

  final String currencyCode;
  final Future<String?> Function() onSaveDraft;
  final Future<String?> Function() onApprove;
  final Future<String?> Function() onPay;
  final Future<bool> Function()? onRollback;
  final VoidCallback? onOpenPayslip;
  final QuickPayState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statement = state.bundle!.employeeStatements.first;
    final earnings = statement.results
        .where(
          (result) =>
              result.classification == PayrollElementClassifications.earning,
        )
        .toList(growable: false);
    final deductions = statement.results
        .where(
          (result) =>
              result.classification == PayrollElementClassifications.deduction,
        )
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: PayrollSummaryCard(
                label: l10n.payrollSummaryEarnings,
                value: statement.totalEarnings,
                currencyCode: currencyCode,
              ),
            ),
            const SizedBox(width: AppSpacing.medium),
            Expanded(
              child: PayrollSummaryCard(
                label: l10n.payrollSummaryDeductions,
                value: statement.totalDeductions,
                currencyCode: currencyCode,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        PayrollSummaryCard(
          label: l10n.payrollSummaryNetPay,
          value: statement.netPay,
          currencyCode: currencyCode,
        ),
        const SizedBox(height: AppSpacing.large),
        PayrollSectionCard(
          title: l10n.payrollSectionEarnings,
          child: Column(
            children: [
              for (final result in earnings)
                PayrollResultLineTile(
                  result: result,
                  currencyCode: currencyCode,
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        PayrollSectionCard(
          title: l10n.payrollSectionDeductions,
          child: deductions.isEmpty
              ? Text(l10n.payrollSectionEmpty)
              : Column(
                  children: [
                    for (final result in deductions)
                      PayrollResultLineTile(
                        result: result,
                        currencyCode: currencyCode,
                      ),
                  ],
                ),
        ),
        const SizedBox(height: AppSpacing.large),
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
        if (onOpenPayslip != null) ...[
          const SizedBox(height: AppSpacing.medium),
          OutlinedButton(
            onPressed: state.isBusy ? null : onOpenPayslip,
            child: Text(l10n.payrollPayslipTitle),
          ),
        ],
      ],
    );
  }
}
