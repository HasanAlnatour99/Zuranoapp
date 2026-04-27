import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/zurano_error_state.dart';
import '../../../employee_today/presentation/employee_today_theme.dart';
import '../../../employee_today/presentation/widgets/attendance_policy_sheet.dart';
import '../../../employee_today/presentation/widgets/employee_today_skeletons.dart';
import '../../application/employee_punch_controller.dart';
import '../../application/employee_today_attendance_ui_provider.dart';
import '../../application/employee_today_attendance_vm.dart';
import '../../domain/enums/attendance_punch_type.dart';
import 'attendance_split_action_panel.dart';
import 'attendance_status_chip.dart';

/// White attendance card with a single primary punch CTA.
class TodayAttendanceCard extends ConsumerWidget {
  const TodayAttendanceCard({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(employeeTodayAttendanceProvider);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return attendanceAsync.when(
      loading: () => const Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
        child: EtTodayAttendanceCardSkeleton(),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
        child: ZuranoErrorState(
          title: l10n.employeeTodayAttendanceLoadErrorTitle,
          message: error.toString(),
          onRetry: onRetry,
          retryLabel: l10n.employeeTodayTryAgain,
        ),
      ),
      data: (vm) {
        if (vm.salonId.isEmpty) {
          return const SizedBox.shrink();
        }
        return _TodayAttendanceCardBody(vm: vm, locale: locale);
      },
    );
  }
}

class _TodayAttendanceCardBody extends ConsumerWidget {
  const _TodayAttendanceCardBody({required this.vm, required this.locale});

  final EmployeeTodayAttendanceVm vm;
  final Locale locale;

  Color _primaryStatusColor() {
    switch (vm.dayStatusKey) {
      case 'incomplete':
      case 'notStarted':
      case 'onBreak':
        return EmployeeTodayColors.amber;
      case 'checkedOut':
        return EmployeeTodayColors.success;
      case 'checkedIn':
      default:
        return EmployeeTodayColors.success;
    }
  }

  IconData _primaryStatusIcon() {
    switch (vm.dayStatusKey) {
      case 'checkedOut':
        return Icons.check_circle_rounded;
      case 'onBreak':
        return Icons.free_breakfast_rounded;
      case 'incomplete':
        return Icons.warning_amber_rounded;
      case 'notStarted':
        return Icons.schedule_rounded;
      case 'checkedIn':
      default:
        return Icons.fact_check_rounded;
    }
  }

  String? _lastPunchTimeTrailing() {
    final t = vm.lastPunchAt;
    if (t == null) {
      return null;
    }
    return DateFormat.jm(locale.toString()).format(t);
  }

  void _openPolicySheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AttendancePolicySheet(),
    );
  }

  Future<void> _onPunch(
    BuildContext context,
    WidgetRef ref,
    EmployeePunchActionType action,
  ) async {
    final type = action.toAttendancePunchType();
    if (type == null || !vm.splitActions.primaryEnabled) {
      final msg = vm.validationMessage(AppLocalizations.of(context)!);
      if (msg != null && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    await ref
        .read(employeePunchControllerProvider.notifier)
        .submitPunch(
          type,
          l10n,
          onMessage: (m) {
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(m)));
            }
          },
          onSuccess: () {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.employeeTodayPunchRecorded(_punchLabel(l10n, type)),
                  ),
                ),
              );
            }
          },
        );
  }

  String _punchLabel(AppLocalizations l10n, AttendancePunchType t) {
    switch (t) {
      case AttendancePunchType.punchIn:
        return l10n.employeeTodayPunchIn;
      case AttendancePunchType.punchOut:
        return l10n.employeeTodayPunchOut;
      case AttendancePunchType.breakOut:
        return l10n.employeeTodayBreakOut;
      case AttendancePunchType.breakIn:
        return l10n.employeeTodayBreakIn;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final busy = ref.watch(employeePunchControllerProvider).type;

    final chips = <Widget>[
      AttendanceStatusChip(
        icon: _primaryStatusIcon(),
        label: vm.primaryStatusTitle(l10n),
        color: _primaryStatusColor(),
        trailing: _lastPunchTimeTrailing(),
      ),
    ];

    if (vm.showMissingPunchChip) {
      chips.add(
        AttendanceStatusChip(
          icon: Icons.warning_amber_rounded,
          label: l10n.employeeTodayStatusMissingPunch,
          color: EmployeeTodayColors.amber,
        ),
      );
    }

    if (vm.showOutsideZoneChip) {
      chips.add(
        AttendanceStatusChip(
          icon: Icons.location_off_outlined,
          label: vm.locationStatusText(l10n),
          color: vm.locationStatusColor(
            EmployeeTodayColors.success,
            EmployeeTodayColors.amber,
          ),
        ),
      );
    }

    final lastPunchAt = vm.lastPunchAt;
    final lastTime = lastPunchAt != null
        ? DateFormat.jm(locale.toString()).format(lastPunchAt)
        : '—';
    final lastDate = lastPunchAt != null
        ? DateFormat.yMMMEd(locale.toString()).format(lastPunchAt)
        : '—';

    final salonLabel = vm.salonName.isNotEmpty
        ? vm.salonName
        : l10n.employeeTodaySalonLabel;

    return Container(
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      padding: const EdgeInsetsDirectional.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: EmployeeTodayColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.employeeTodayAttendanceTitle,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.45,
                        height: 1.15,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.employeeTodayAttendanceTagline,
                      style: TextStyle(
                        color: const Color(0xFF334155).withValues(alpha: 0.9),
                        fontSize: 14,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(999),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _openPolicySheet(context),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 14, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: const Color(0xFF4C1D95),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.employeeTodayViewPolicy,
                          style: TextStyle(
                            color: const Color(0xFF4C1D95),
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F5FF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE9D5FF)),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(14, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.employeeTodayAttendanceStatusLabel,
                    style: TextStyle(
                      color: const Color(0xFF334155),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(spacing: 8, runSpacing: 8, children: chips),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ContextColumn(
                  icon: Icons.schedule_rounded,
                  title: l10n.employeeTodayLastPunchLabel,
                  line1: lastTime,
                  line2: lastDate,
                  iconColor: const Color(0xFF334155),
                  line1Color: const Color(0xFF0F172A),
                  line2Color: const Color(0xFF475569),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ContextColumn(
                  icon: Icons.location_on_outlined,
                  title: l10n.employeeTodayLocationContextLabel,
                  line1: vm.locationStatusText(l10n),
                  line2: salonLabel,
                  iconColor: const Color(0xFF334155),
                  line1Color: vm.locationStatusColor(
                    EmployeeTodayColors.success,
                    EmployeeTodayColors.amber,
                  ),
                  line2Color: const Color(0xFF475569),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AttendanceSplitActionPanel(
            vm: vm,
            primarySubtitleOverride: vm.validationMessage(l10n),
            primaryLoading:
                busy == vm.splitActions.primaryAction.toAttendancePunchType(),
            onPrimaryTap: busy != null
                ? null
                : () => _onPunch(context, ref, vm.splitActions.primaryAction),
            onSecondaryTap: null,
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 240),
            opacity: vm.validationMessage(l10n) == null ? 0 : 1,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                top: 10,
                start: 4,
                end: 4,
              ),
              child: Text(
                vm.validationMessage(l10n) ?? '',
                style: TextStyle(
                  color: const Color(0xFF7C2D12),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContextColumn extends StatelessWidget {
  const _ContextColumn({
    required this.icon,
    required this.title,
    required this.line1,
    required this.line2,
    required this.iconColor,
    required this.line1Color,
    required this.line2Color,
  });

  final IconData icon;
  final String title;
  final String line1;
  final String line2;
  final Color iconColor;
  final Color line1Color;
  final Color line2Color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          line1,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: line1Color,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          line2,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: line2Color,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
