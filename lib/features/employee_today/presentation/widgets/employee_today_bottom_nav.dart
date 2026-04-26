import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../employee_today_theme.dart';

/// Shared employee shell bottom navigation: Today, Sales, Attendance, Payroll, Profile.
///
/// Order matches [TextDirection] so RTL/LTR only mirrors the bar, not tab semantics.
class EmployeeTodayBottomNav extends StatelessWidget {
  const EmployeeTodayBottomNav({super.key, required this.currentPath});

  final String currentPath;

  int get _index {
    if (currentPath == AppRoutes.employeeToday ||
        currentPath == AppRoutes.employeeDashboard) {
      return 0;
    }
    if (currentPath.startsWith(AppRoutes.employeeSales)) {
      return 1;
    }
    if (AppRoutes.isEmployeeAttendancePath(currentPath) ||
        currentPath == AppRoutes.employeeAttendanceCorrection ||
        currentPath == AppRoutes.employeeAttendanceCorrectionNested) {
      return 2;
    }
    if (AppRoutes.isEmployeePayrollPath(currentPath)) {
      return 3;
    }
    if (currentPath == AppRoutes.settings) {
      return 4;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: EmployeeTodayColors.primaryPurple.withValues(alpha: 0.12),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
          border: Border.all(
            color: EmployeeTodayColors.cardBorder.withValues(alpha: 0.6),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: _Item(
                  label: l10n.employeeBottomNavToday,
                  icon: Icons.calendar_today_rounded,
                  selected: _index == 0,
                  onTap: () => context.go(AppRoutes.employeeToday),
                ),
              ),
              Expanded(
                child: _Item(
                  label: l10n.employeeBottomNavSales,
                  icon: Icons.payments_outlined,
                  selected: _index == 1,
                  onTap: () => context.go(AppRoutes.employeeSales),
                ),
              ),
              Expanded(
                child: _Item(
                  label: l10n.employeeBottomNavAttendance,
                  icon: Icons.schedule_rounded,
                  selected: _index == 2,
                  onTap: () => context.go(AppRoutes.employeeAttendance),
                ),
              ),
              Expanded(
                child: _Item(
                  label: l10n.employeeBottomNavPayroll,
                  icon: Icons.receipt_long_outlined,
                  selected: _index == 3,
                  onTap: () => context.go(AppRoutes.employeePayroll),
                ),
              ),
              Expanded(
                child: _Item(
                  label: l10n.employeeBottomNavProfile,
                  icon: Icons.person_outline_rounded,
                  selected: _index == 4,
                  onTap: () => context.push(AppRoutes.settings),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = EmployeeTodayColors.primaryPurple;
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? p.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? p : EmployeeTodayColors.mutedText,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? p : EmployeeTodayColors.mutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
