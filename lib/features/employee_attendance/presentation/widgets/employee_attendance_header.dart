import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../employee_today/presentation/employee_today_theme.dart';

class EmployeeAttendanceHeader extends StatelessWidget {
  const EmployeeAttendanceHeader({super.key, required this.employeeName});

  final String employeeName;

  String get _initials {
    final p = employeeName.trim().split(RegExp(r'\s+'));
    if (p.isEmpty) {
      return '?';
    }
    if (p.length == 1) {
      return p.first.isNotEmpty ? p.first[0].toUpperCase() : '?';
    }
    return '${p.first[0]}${p.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.employeeAttendanceScreenTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: EmployeeTodayColors.deepText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.employeeAttendanceScreenSubtitle,
                  style: const TextStyle(
                    color: EmployeeTodayColors.mutedText,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: EmployeeTodayColors.primaryPurple.withValues(
                  alpha: 0.18,
                ),
                child: Text(
                  _initials,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: EmployeeTodayColors.primaryPurple,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: EmployeeTodayColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
