import 'package:flutter/material.dart';

import '../../../../shared/widgets/zurano_status_chip.dart';

class AttendanceStatusChip extends StatelessWidget {
  const AttendanceStatusChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final Color color;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return ZuranoStatusChip(
      icon: icon,
      label: label,
      color: color,
      trailing: trailing,
      backgroundColor: Colors.white.withValues(alpha: 0.18),
    );
  }
}
