import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/models/et_attendance_day.dart';
import '../employee_today_theme.dart';
import '../../../../shared/widgets/zurano_status_chip.dart';

Color _primaryStatusColor(String status) {
  switch (status) {
    case 'incomplete':
      return EmployeeTodayColors.amber;
    case 'notStarted':
      return EmployeeTodayColors.mutedText;
    case 'onBreak':
      return EmployeeTodayColors.amber;
    case 'checkedOut':
      return EmployeeTodayColors.success;
    case 'checkedIn':
    default:
      return EmployeeTodayColors.success;
  }
}

String _primaryStatusKey(EtAttendanceDay? day) {
  if (day == null) {
    return 'notStarted';
  }
  return day.status;
}

class EmployeeAttendanceStatusCard extends StatelessWidget {
  const EmployeeAttendanceStatusCard({
    super.key,
    required this.day,
    required this.showOutsideZoneChip,
    this.outsideZoneChipLabel,
    this.outsideZoneChipColor,
    required this.showMissingPunchChip,
    required this.lastPunchLabel,
    required this.onViewPolicy,
    required this.footer,
  });

  final EtAttendanceDay? day;
  final bool showOutsideZoneChip;

  /// When [showOutsideZoneChip] is true, localized label (historical or live).
  final String? outsideZoneChipLabel;
  final Color? outsideZoneChipColor;
  final bool showMissingPunchChip;
  final String? lastPunchLabel;
  final VoidCallback onViewPolicy;
  final Widget footer;

  String _statusTitle(AppLocalizations l10n) {
    if (day == null) {
      return l10n.employeeTodayStatusNotCheckedIn;
    }
    switch (day!.status) {
      case 'checkedOut':
        return l10n.employeeTodayStatusCheckedOut;
      case 'onBreak':
        return l10n.employeeTodayStatusOnBreak;
      case 'notStarted':
        return l10n.employeeTodayStatusNotCheckedIn;
      case 'incomplete':
        return l10n.employeeTodayStatusMissingPunch;
      case 'checkedIn':
      default:
        return l10n.employeeTodayStatusCheckedIn;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusKey = _primaryStatusKey(day);
    final statusColor = _primaryStatusColor(statusKey);

    final chips = <Widget>[
      ZuranoStatusChip(
        icon: Icons.fact_check_rounded,
        label: _statusTitle(l10n),
        color: statusColor,
      ),
    ];

    if (showMissingPunchChip) {
      chips.add(
        ZuranoStatusChip(
          icon: Icons.warning_amber_rounded,
          label: l10n.employeeTodayStatusMissingPunch,
          color: EmployeeTodayColors.amber,
        ),
      );
    }

    if (showOutsideZoneChip) {
      final label = outsideZoneChipLabel ?? l10n.employeeTodayZoneOutside;
      final color = outsideZoneChipColor ?? EmployeeTodayColors.amber;
      chips.add(
        ZuranoStatusChip(
          icon: Icons.location_off_outlined,
          label: label,
          color: color,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            EmployeeTodayColors.heroGradientStart,
            EmployeeTodayColors.heroGradientEnd,
          ],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: EmployeeTodayColors.primaryPurple.withValues(alpha: 0.22),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: EmployeeTodayColors.cardBorder),
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
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
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.45,
                        height: 1.15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.employeeTodayAttendanceTagline,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.26),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          12,
                          10,
                          12,
                          10,
                        ),
                        child: Wrap(spacing: 8, runSpacing: 8, children: chips),
                      ),
                    ),
                    if (lastPunchLabel != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        lastPunchLabel!,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.94),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Material(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(999),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onViewPolicy,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 14, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.policy_outlined,
                          color: Colors.white.withValues(alpha: 0.98),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.employeeTodayViewPolicy,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.98),
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                            letterSpacing: -0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: AlignmentDirectional.topCenter,
                end: AlignmentDirectional.bottomCenter,
                colors: [
                  EmployeeTodayColors.statusCardFooterStart,
                  EmployeeTodayColors.statusCardFooterEnd,
                ],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: EmployeeTodayColors.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: EmployeeTodayColors.primaryPurple.withValues(
                    alpha: 0.08,
                  ),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: footer,
          ),
        ],
      ),
    );
  }
}
