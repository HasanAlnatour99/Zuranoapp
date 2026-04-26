import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_modal_sheet.dart';
import '../../../../core/widgets/keyboard_safe_form_scaffold.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_select_field.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/repository_providers.dart';
import '../../../../providers/session_provider.dart';
import '../../data/models/payroll_element_model.dart';
import '../../data/payroll_constants.dart';
import '../../logic/payroll_dashboard_providers.dart';
import '../widgets/payroll_recurrence_badge.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class PayrollElementsScreen extends ConsumerWidget {
  const PayrollElementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final elementsAsync = ref.watch(payrollElementsStreamProvider);

    return Scaffold(
      appBar: AppPageHeader(
        title: Text(l10n.payrollElementsTitle),
        actions: [
          IconButton(
            onPressed: () async {
              final salonId = ref
                  .read(sessionUserProvider)
                  .asData
                  ?.value
                  ?.salonId
                  ?.trim();
              if (salonId == null || salonId.isEmpty) {
                return;
              }
              await ref
                  .read(payrollElementRepositoryProvider)
                  .seedDefaultElements(salonId);
            },
            icon: const Icon(AppIcons.auto_fix_high_rounded),
            tooltip: l10n.payrollElementsSeedDefaults,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'payroll_elements_add_fab',
        onPressed: () => _showElementSheet(context, ref),
        icon: const Icon(AppIcons.add_rounded),
        label: Text(l10n.payrollElementsAdd),
      ),
      body: elementsAsync.when(
        loading: () => const Center(child: AppLoadingIndicator(size: 36)),
        error: (_, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: AppEmptyState(
              title: l10n.payrollElementsTitle,
              message: l10n.payrollGenericError,
              icon: AppIcons.tune_rounded,
            ),
          ),
        ),
        data: (elements) {
          if (elements.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.large),
              child: AppEmptyState(
                title: l10n.payrollElementsEmptyTitle,
                message: l10n.payrollElementsEmptySubtitle,
                icon: AppIcons.tune_rounded,
                primaryActionLabel: l10n.payrollElementsSeedDefaults,
                onPrimaryAction: () async {
                  final salonId = ref
                      .read(sessionUserProvider)
                      .asData
                      ?.value
                      ?.salonId
                      ?.trim();
                  if (salonId == null || salonId.isEmpty) {
                    return;
                  }
                  await ref
                      .read(payrollElementRepositoryProvider)
                      .seedDefaultElements(salonId);
                },
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.large),
            itemBuilder: (context, index) {
              final element = elements[index];
              return _PayrollElementCard(
                element: element,
                onToggleActive: (value) async {
                  final salonId = ref
                      .read(sessionUserProvider)
                      .asData
                      ?.value
                      ?.salonId
                      ?.trim();
                  if (salonId == null || salonId.isEmpty) {
                    return;
                  }
                  await ref
                      .read(payrollElementRepositoryProvider)
                      .updateElement(
                        salonId,
                        element.copyWith(isActive: value),
                      );
                },
              );
            },
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppSpacing.medium),
            itemCount: elements.length,
          );
        },
      ),
    );
  }

  Future<void> _showElementSheet(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final salonId = ref
        .read(sessionUserProvider)
        .asData
        ?.value
        ?.salonId
        ?.trim();
    if (salonId == null || salonId.isEmpty) {
      return;
    }

    final codeController = TextEditingController();
    final nameController = TextEditingController();
    final amountController = TextEditingController(text: '0');
    var classification = PayrollElementClassifications.earning;
    var recurrenceType = PayrollRecurrenceTypes.nonrecurring;
    var calculationMethod = PayrollCalculationMethods.fixed;
    var visibleOnPayslip = true;
    var affectsNetPay = true;

    await showAppModalBottomSheet<void>(
      context: context,
      expand: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return KeyboardSafeModalFormScroll(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.payrollElementsAdd,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  AppTextField(
                    label: l10n.payrollFieldCode,
                    controller: codeController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9_]+')),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  AppTextField(
                    label: l10n.payrollFieldName,
                    controller: nameController,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  AppSelectField<String>(
                    label: l10n.payrollFieldClassification,
                    value: classification,
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() => classification = value);
                      }
                    },
                    options: [
                      AppSelectOption(
                        value: PayrollElementClassifications.earning,
                        label: l10n.payrollClassificationEarning,
                      ),
                      AppSelectOption(
                        value: PayrollElementClassifications.deduction,
                        label: l10n.payrollClassificationDeduction,
                      ),
                      AppSelectOption(
                        value: PayrollElementClassifications.information,
                        label: l10n.payrollClassificationInformation,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  AppSelectField<String>(
                    label: l10n.payrollFieldRecurrence,
                    value: recurrenceType,
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() => recurrenceType = value);
                      }
                    },
                    options: [
                      AppSelectOption(
                        value: PayrollRecurrenceTypes.recurring,
                        label: l10n.payrollBadgeRecurring,
                      ),
                      AppSelectOption(
                        value: PayrollRecurrenceTypes.nonrecurring,
                        label: l10n.payrollBadgeNonRecurring,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  AppSelectField<String>(
                    label: l10n.payrollFieldCalculationMethod,
                    value: calculationMethod,
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() => calculationMethod = value);
                      }
                    },
                    options: [
                      AppSelectOption(
                        value: PayrollCalculationMethods.fixed,
                        label: l10n.payrollCalculationFixed,
                      ),
                      AppSelectOption(
                        value: PayrollCalculationMethods.percentage,
                        label: l10n.payrollCalculationPercentage,
                      ),
                      AppSelectOption(
                        value: PayrollCalculationMethods.derived,
                        label: l10n.payrollCalculationDerived,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  AppTextField(
                    label: l10n.payrollFieldDefaultAmount,
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  SwitchListTile.adaptive(
                    value: visibleOnPayslip,
                    onChanged: (value) {
                      setModalState(() => visibleOnPayslip = value);
                    },
                    title: Text(l10n.payrollFieldVisibleOnPayslip),
                  ),
                  SwitchListTile.adaptive(
                    value: affectsNetPay,
                    onChanged: (value) {
                      setModalState(() => affectsNetPay = value);
                    },
                    title: Text(l10n.payrollFieldAffectsNetPay),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  AppPrimaryButton(
                    label: l10n.payrollActionSave,
                    onPressed: () async {
                      final code = codeController.text.trim();
                      final name = nameController.text.trim();
                      if (code.isEmpty || name.isEmpty) {
                        return;
                      }
                      await ref
                          .read(payrollElementRepositoryProvider)
                          .createElement(
                            salonId,
                            PayrollElementModel(
                              id: '',
                              code: code,
                              name: name,
                              classification: classification,
                              recurrenceType: recurrenceType,
                              calculationMethod: calculationMethod,
                              defaultAmount:
                                  double.tryParse(amountController.text) ?? 0,
                              isSystemElement: false,
                              isActive: true,
                              affectsNetPay: affectsNetPay,
                              visibleOnPayslip: visibleOnPayslip,
                              displayOrder: 500,
                            ),
                          );
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _PayrollElementCard extends StatelessWidget {
  const _PayrollElementCard({
    required this.element,
    required this.onToggleActive,
  });

  final PayrollElementModel element;
  final ValueChanged<bool> onToggleActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        element.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        element.code,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: element.isActive,
                  onChanged: onToggleActive,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.medium),
            Wrap(
              spacing: AppSpacing.small,
              runSpacing: AppSpacing.small,
              children: [
                _Tag(
                  label: switch (element.classification) {
                    PayrollElementClassifications.earning =>
                      l10n.payrollClassificationEarning,
                    PayrollElementClassifications.deduction =>
                      l10n.payrollClassificationDeduction,
                    _ => l10n.payrollClassificationInformation,
                  },
                ),
                PayrollRecurrenceBadge(recurrenceType: element.recurrenceType),
                _Tag(
                  label: switch (element.calculationMethod) {
                    PayrollCalculationMethods.percentage =>
                      l10n.payrollCalculationPercentage,
                    PayrollCalculationMethods.derived =>
                      l10n.payrollCalculationDerived,
                    _ => l10n.payrollCalculationFixed,
                  },
                ),
                if (element.isSystemElement)
                  _Tag(label: l10n.payrollElementsSystemTag),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
