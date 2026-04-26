import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../core/constants/violation_types.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_select_field.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/repository_providers.dart';
import '../../../../providers/salon_streams_provider.dart';
import '../../../../providers/session_provider.dart';
import '../../../salon/data/models/penalty_settings.dart';
import '../../../salon/data/models/salon.dart';
import '../../../settings/presentation/widgets/zurano/zurano_page_scaffold.dart';
import '../../../settings/presentation/widgets/zurano/zurano_top_bar.dart';
import '../../../violations/data/models/violation.dart';
import '../providers/hr_violations_summary_provider.dart';
import '../widgets/hr/hr_empty_state_card.dart';
import '../widgets/hr/hr_intro_card.dart';
import '../widgets/hr/hr_penalty_rule_card.dart';
import '../widgets/hr/hr_section_header.dart';
import '../widgets/hr/hr_summary_card.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

String _hrFormatLateValue(AppLocalizations l10n, PenaltySettings p) {
  final n = p.barberLateValue;
  if (p.barberLateCalculationType == PenaltyCalculationTypes.percent) {
    return '${n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1)}%';
  }
  return n.toStringAsFixed(2);
}

String _hrFormatNoShowValue(PenaltySettings p) {
  final n = p.barberNoShowValue;
  if (p.barberNoShowCalculationType == PenaltyCalculationTypes.percent) {
    return '${n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1)}%';
  }
  return n.toStringAsFixed(2);
}

String _hrNoShowCalcLabel(AppLocalizations l10n, PenaltySettings p) {
  return p.barberNoShowCalculationType == PenaltyCalculationTypes.flat
      ? l10n.ownerPenaltyCalcFlat
      : l10n.ownerPenaltyCalcPercent;
}

Future<bool> _hrConfirmPenaltyToggle(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context);
  final r = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        l10n.hrViolationsToggleConfirmTitle,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Text(
        l10n.hrViolationsToggleConfirmBody,
        style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(l10n.hrViolationsToggleConfirmAction),
        ),
      ],
    ),
  );
  return r ?? false;
}

Future<void> _hrPersistSalonPenalty(
  BuildContext context,
  WidgetRef ref,
  Salon salon,
  PenaltySettings next,
) async {
  final l10n = AppLocalizations.of(context)!;
  try {
    await ref
        .read(salonRepositoryProvider)
        .updateSalon(salon.copyWith(penaltySettings: next));
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.ownerPenaltySettingsSaved)));
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.genericError)));
    }
  }
}

Future<void> _hrReviewViolation(
  BuildContext context,
  WidgetRef ref, {
  required String salonId,
  required String violationId,
  required bool approve,
}) async {
  final l10n = AppLocalizations.of(context)!;
  try {
    await ref
        .read(violationRepositoryProvider)
        .reviewViolation(
          salonId: salonId,
          violationId: violationId,
          approve: approve,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.ownerViolationReviewSaved)));
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.genericError)));
    }
  }
}

Future<void> _hrOpenLateRuleSheet(
  BuildContext context,
  WidgetRef ref,
  Salon salon,
  PenaltySettings initial,
) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) {
      return _LateRuleEditorSheet(
        salon: salon,
        initial: initial,
        onSave: (next) async {
          await _hrPersistSalonPenalty(ctx, ref, salon, next);
          if (ctx.mounted) Navigator.of(ctx).pop();
        },
      );
    },
  );
}

Future<void> _hrOpenNoShowRuleSheet(
  BuildContext context,
  WidgetRef ref,
  Salon salon,
  PenaltySettings initial,
) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) {
      return _NoShowRuleEditorSheet(
        salon: salon,
        initial: initial,
        onSave: (next) async {
          await _hrPersistSalonPenalty(ctx, ref, salon, next);
          if (ctx.mounted) Navigator.of(ctx).pop();
        },
      );
    },
  );
}

class HrViolationsScreen extends ConsumerWidget {
  const HrViolationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sessionAsync = ref.watch(sessionUserProvider);
    final summaryAsync = ref.watch(hrViolationsSummaryProvider);
    final violationsAsync = ref.watch(violationsStreamProvider);
    final salonAsync = ref.watch(sessionSalonStreamProvider);

    return ZuranoPageScaffold(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ZuranoTopBar(
              title: l10n.ownerHrSettingsTitle,
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.ownerOverview);
                }
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            sliver: SliverToBoxAdapter(
              child: sessionAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (_, _) => Text(
                  l10n.genericError,
                  style: const TextStyle(color: ZuranoPremiumUiColors.danger),
                ),
                data: (user) {
                  if (user == null) {
                    return const SizedBox.shrink();
                  }
                  final allowed =
                      user.role == UserRoles.owner ||
                      user.role == UserRoles.admin;
                  final salonId = user.salonId?.trim() ?? '';
                  if (!allowed || salonId.isEmpty) {
                    return Text(
                      l10n.genericError,
                      style: const TextStyle(
                        color: ZuranoPremiumUiColors.danger,
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HrIntroCard(message: l10n.ownerHrSettingsSubtitle),
                      const SizedBox(height: 20),
                      summaryAsync.when(
                        data: (s) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: HrSummaryCard(
                                icon: Icons.assignment_late_outlined,
                                title: l10n.ownerViolationsMetricPending,
                                value: '${s.pendingReviews}',
                                subtitle:
                                    l10n.hrViolationsSummaryAwaitingApproval,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: HrSummaryCard(
                                icon: Icons.tune_outlined,
                                title: l10n.ownerViolationsMetricRulesOn,
                                value: '${s.activeRules}',
                                subtitle:
                                    l10n.hrViolationsSummaryActiveRulesSubtitle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: HrSummaryCard(
                                icon: Icons.groups_outlined,
                                title:
                                    l10n.hrViolationsSummaryStaffFlaggedTitle,
                                value: '${s.staffFlagged}',
                                subtitle: l10n.ownerMoneyPeriodMonth,
                              ),
                            ),
                          ],
                        ),
                        loading: () => const HrSummaryRowSkeleton(),
                        error: (_, _) => Text(
                          l10n.hrViolationsSummaryLoadError,
                          style: const TextStyle(
                            color: ZuranoPremiumUiColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      HrSectionHeader(title: l10n.ownerViolationsMetricPending),
                      const SizedBox(height: 12),
                      violationsAsync.when(
                        loading: () => const LinearProgressIndicator(),
                        error: (_, _) => Text(l10n.genericError),
                        data: (all) {
                          final pending = all
                              .where(
                                (v) => v.status == ViolationStatuses.pending,
                              )
                              .take(24)
                              .toList(growable: false);
                          if (pending.isEmpty) {
                            return HrEmptyStateCard(
                              icon: Icons.assignment_turned_in_outlined,
                              title: l10n.hrViolationsPendingEmptyTitle,
                              subtitle: l10n.hrViolationsPendingEmptyBody,
                            );
                          }
                          return Column(
                            children: pending
                                .map(
                                  (v) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _HrPendingViolationCard(
                                      violation: v,
                                      l10n: l10n,
                                      onApprove: () => _hrReviewViolation(
                                        context,
                                        ref,
                                        salonId: salonId,
                                        violationId: v.id,
                                        approve: true,
                                      ),
                                      onReject: () => _hrReviewViolation(
                                        context,
                                        ref,
                                        salonId: salonId,
                                        violationId: v.id,
                                        approve: false,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 28),
                      HrSectionHeader(
                        title: l10n.ownerPenaltySettingsTitle,
                        actionLabel: l10n.hrViolationsAddRule,
                        actionIcon: Icons.add_rounded,
                        onActionTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.hrViolationsAddRuleComingSoon),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      salonAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => Text(l10n.genericError),
                        data: (salon) {
                          if (salon == null) {
                            return const SizedBox.shrink();
                          }
                          final p = salon.penaltySettings;
                          return Column(
                            children: [
                              HrPenaltyRuleCard(
                                title: l10n.hrViolationsLateRuleTitle,
                                icon: Icons.schedule_rounded,
                                enabledChipOnLabel:
                                    l10n.hrViolationsEnabledChip,
                                enabledChipOffLabel:
                                    l10n.hrViolationsDisabledChip,
                                enabled: p.barberLateEnabled,
                                firstLabel: l10n.hrViolationsGraceTimeLabel,
                                firstValue: '${p.barberLateGraceMinutes} min',
                                secondLabel: l10n.ownerPenaltyLateValue,
                                secondValue: _hrFormatLateValue(l10n, p),
                                appliesWhenLabel:
                                    l10n.ownerPenaltyAppliesWhenLabel,
                                appliesWhenBody: l10n.ownerPenaltyLateWhenBody,
                                onToggle: (v) async {
                                  if (!await _hrConfirmPenaltyToggle(context)) {
                                    return;
                                  }
                                  if (!context.mounted) {
                                    return;
                                  }
                                  await _hrPersistSalonPenalty(
                                    context,
                                    ref,
                                    salon,
                                    p.copyWith(barberLateEnabled: v),
                                  );
                                },
                                onTap: () => _hrOpenLateRuleSheet(
                                  context,
                                  ref,
                                  salon,
                                  p,
                                ),
                              ),
                              const SizedBox(height: 14),
                              HrPenaltyRuleCard(
                                title: l10n.hrViolationsNoShowRuleTitle,
                                icon: Icons.event_busy_outlined,
                                enabledChipOnLabel:
                                    l10n.hrViolationsEnabledChip,
                                enabledChipOffLabel:
                                    l10n.hrViolationsDisabledChip,
                                enabled: p.barberNoShowEnabled,
                                firstLabel: l10n.ownerPenaltyMetricCalculation,
                                firstValue: _hrNoShowCalcLabel(l10n, p),
                                secondLabel: l10n.ownerPenaltyNoShowValue,
                                secondValue: _hrFormatNoShowValue(p),
                                appliesWhenLabel:
                                    l10n.ownerPenaltyAppliesWhenLabel,
                                appliesWhenBody:
                                    l10n.ownerPenaltyNoShowWhenBody,
                                onToggle: (v) async {
                                  if (!await _hrConfirmPenaltyToggle(context)) {
                                    return;
                                  }
                                  if (!context.mounted) {
                                    return;
                                  }
                                  await _hrPersistSalonPenalty(
                                    context,
                                    ref,
                                    salon,
                                    p.copyWith(barberNoShowEnabled: v),
                                  );
                                },
                                onTap: () => _hrOpenNoShowRuleSheet(
                                  context,
                                  ref,
                                  salon,
                                  p,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HrPendingViolationCard extends StatelessWidget {
  const _HrPendingViolationCard({
    required this.violation,
    required this.l10n,
    required this.onApprove,
    required this.onReject,
  });

  final Violation violation;
  final AppLocalizations l10n;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final v = violation;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ZuranoPremiumUiColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ZuranoPremiumUiColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                AppIcons.report_gmailerrorred_outlined,
                color: ZuranoPremiumUiColors.primaryPurple,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${v.employeeName ?? v.employeeId} · ${v.violationType}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: ZuranoPremiumUiColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.ownerViolationBooking}: ${v.bookingId ?? '—'} · ${l10n.ownerViolationAmount}: ${v.amount.toStringAsFixed(2)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: ZuranoPremiumUiColors.textSecondary,
            ),
          ),
          if (v.notes != null && v.notes!.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              v.notes!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: ZuranoPremiumUiColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onReject,
                child: Text(l10n.ownerViolationReject),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: onApprove,
                child: Text(l10n.ownerViolationApprove),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LateRuleEditorSheet extends StatefulWidget {
  const _LateRuleEditorSheet({
    required this.salon,
    required this.initial,
    required this.onSave,
  });

  final Salon salon;
  final PenaltySettings initial;
  final Future<void> Function(PenaltySettings next) onSave;

  @override
  State<_LateRuleEditorSheet> createState() => _LateRuleEditorSheetState();
}

class _LateRuleEditorSheetState extends State<_LateRuleEditorSheet> {
  late final TextEditingController _grace;
  late final TextEditingController _lateVal;
  late String _lateType;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    _lateType = p.barberLateCalculationType;
    _grace = TextEditingController(text: '${p.barberLateGraceMinutes}');
    _lateVal = TextEditingController(text: '${p.barberLateValue}');
  }

  @override
  void dispose() {
    _grace.dispose();
    _lateVal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.hrViolationsLateRuleTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.ownerPenaltyGraceMinutes,
            controller: _grace,
            keyboardType: TextInputType.number,
          ),
          AppSelectField<String>(
            key: ValueKey<String>('late_calc_$_lateType'),
            label: l10n.ownerPenaltyMetricCalculation,
            value: _lateType,
            options: [
              AppSelectOption(
                value: PenaltyCalculationTypes.flat,
                label: l10n.ownerPenaltyCalcFlat,
              ),
              AppSelectOption(
                value: PenaltyCalculationTypes.percent,
                label: l10n.ownerPenaltyCalcPercent,
              ),
              AppSelectOption(
                value: PenaltyCalculationTypes.perMinute,
                label: l10n.ownerPenaltyCalcPerMinute,
              ),
            ],
            onChanged: (v) => setState(() => _lateType = v ?? _lateType),
          ),
          AppTextField(
            label: l10n.ownerPenaltyLateValue,
            controller: _lateVal,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          AppPrimaryButton(
            label: l10n.ownerSave,
            onPressed: () async {
              final next = widget.initial.copyWith(
                barberLateGraceMinutes: int.tryParse(_grace.text.trim()) ?? 5,
                barberLateCalculationType: _lateType,
                barberLateValue: double.tryParse(_lateVal.text.trim()) ?? 0,
              );
              await widget.onSave(next);
            },
          ),
        ],
      ),
    );
  }
}

class _NoShowRuleEditorSheet extends StatefulWidget {
  const _NoShowRuleEditorSheet({
    required this.salon,
    required this.initial,
    required this.onSave,
  });

  final Salon salon;
  final PenaltySettings initial;
  final Future<void> Function(PenaltySettings next) onSave;

  @override
  State<_NoShowRuleEditorSheet> createState() => _NoShowRuleEditorSheetState();
}

class _NoShowRuleEditorSheetState extends State<_NoShowRuleEditorSheet> {
  late final TextEditingController _nsVal;
  late String _nsType;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    _nsType = p.barberNoShowCalculationType;
    _nsVal = TextEditingController(text: '${p.barberNoShowValue}');
  }

  @override
  void dispose() {
    _nsVal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.hrViolationsNoShowRuleTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          AppSelectField<String>(
            key: ValueKey<String>('noshow_calc_$_nsType'),
            label: l10n.ownerPenaltyMetricCalculation,
            value: _nsType,
            options: [
              AppSelectOption(
                value: PenaltyCalculationTypes.flat,
                label: l10n.ownerPenaltyCalcFlat,
              ),
              AppSelectOption(
                value: PenaltyCalculationTypes.percent,
                label: l10n.ownerPenaltyCalcPercent,
              ),
            ],
            onChanged: (v) => setState(() => _nsType = v ?? _nsType),
          ),
          AppTextField(
            label: l10n.ownerPenaltyNoShowValue,
            controller: _nsVal,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          AppPrimaryButton(
            label: l10n.ownerSave,
            onPressed: () async {
              final next = widget.initial.copyWith(
                barberNoShowCalculationType: _nsType,
                barberNoShowValue: double.tryParse(_nsVal.text.trim()) ?? 0,
              );
              await widget.onSave(next);
            },
          ),
        ],
      ),
    );
  }
}
