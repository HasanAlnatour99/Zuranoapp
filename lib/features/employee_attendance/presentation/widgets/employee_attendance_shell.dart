import 'package:flutter/material.dart';

import '../../../employee_today/presentation/employee_today_theme.dart';

BoxDecoration zuranoAttendanceCardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: EmployeeTodayColors.primaryPurple.withValues(alpha: 0.08),
        blurRadius: 24,
        offset: const Offset(0, 12),
      ),
    ],
    border: Border.all(
      color: EmployeeTodayColors.cardBorder.withValues(alpha: 0.65),
    ),
  );
}

LinearGradient zuranoAttendanceScreenGradient() {
  return const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF4EEFF), Color(0xFFFFFFFF)],
  );
}
