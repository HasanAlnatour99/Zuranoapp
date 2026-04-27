import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../l10n/app_localizations.dart';

/// Notched bottom app bar for the employee shell (2 + FAB + 2).
class EmployeeBottomNavBar extends StatelessWidget {
  const EmployeeBottomNavBar({super.key, required this.currentPath});

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
    if (currentPath == AppRoutes.settings) {
      return 3;
    }
    if (AppRoutes.isEmployeePayrollPath(currentPath)) {
      return 4;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return BottomAppBar(
      height: 86,
      elevation: 0,
      color: scheme.surfaceContainer,
      surfaceTintColor: scheme.surfaceContainer,
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 4, 10, 6),
          child: Row(
            children: [
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.calendar_today_rounded,
                  label: l10n.employeeBottomNavToday,
                  selected: _index == 0,
                  onTap: () => context.go(AppRoutes.employeeToday),
                ),
              ),
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.payments_outlined,
                  label: l10n.employeeBottomNavSales,
                  selected: _index == 1,
                  onTap: () => context.go(AppRoutes.employeeSales),
                ),
              ),
              const SizedBox(width: 72),
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.schedule_rounded,
                  label: l10n.employeeBottomNavAttendance,
                  selected: _index == 2,
                  onTap: () => context.go(AppRoutes.employeeAttendance),
                ),
              ),
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.person_outline_rounded,
                  label: l10n.employeeBottomNavProfile,
                  selected: _index == 3,
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

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    final muted = scheme.onSurfaceVariant;
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: selected
              ? primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 46;
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: selected ? primary : muted, size: 20),
                if (!compact) ...[
                  const SizedBox(height: 2),
                  Flexible(
                    child: FittedBox(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: selected ? primary : muted,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
