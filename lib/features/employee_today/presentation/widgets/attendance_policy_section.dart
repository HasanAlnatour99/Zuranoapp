import 'package:flutter/material.dart';

import '../employee_today_theme.dart';

class AttendancePolicySection extends StatelessWidget {
  const AttendancePolicySection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 8, top: 4),
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: EmployeeTodayColors.deepText,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}
