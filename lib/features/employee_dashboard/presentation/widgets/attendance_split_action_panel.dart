import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/employee_today_attendance_vm.dart';
import 'attendance_primary_action_button.dart';

class AttendanceSplitActionPanel extends StatelessWidget {
  const AttendanceSplitActionPanel({
    super.key,
    required this.vm,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
    required this.primarySubtitleOverride,
    this.primaryLoading = false,
  });

  final EmployeeTodayAttendanceVm vm;
  final VoidCallback? onPrimaryTap;
  final VoidCallback? onSecondaryTap;
  final String? primarySubtitleOverride;
  final bool primaryLoading;

  @override
  Widget build(BuildContext context) {
    final actions = vm.splitActions;
    final l10n = AppLocalizations.of(context)!;

    return AnimatedSize(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1F1147).withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            if (actions.primaryAction != EmployeePunchActionType.none)
              AttendancePrimaryActionButton(
                actionType: actions.primaryAction,
                enabled: actions.primaryEnabled,
                subtitleOverride: primarySubtitleOverride,
                onTap: onPrimaryTap,
                loading: primaryLoading,
              ),
            if (actions.showCorrectionAction) ...[
              if (actions.primaryAction != EmployeePunchActionType.none)
                const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.push(
                    AppRoutes.employeeAttendanceCorrectionNested,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4C1D95),
                    side: BorderSide(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.45),
                    ),
                    backgroundColor: const Color(0xFFF5F3FF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    l10n.employeeTodaySubmitCorrection,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
