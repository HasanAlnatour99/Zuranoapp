import 'package:flutter/material.dart';

import '../employee_today_theme.dart';

/// One policy rule row: leading icon, title, optional subtitle, optional trailing chip.
class AttendancePolicyRuleTile extends StatelessWidget {
  const AttendancePolicyRuleTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailingChipLabel,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? trailingChipLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: EmployeeTodayColors.primaryPurple),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    height: 1.35,
                    color: EmployeeTodayColors.deepText,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: EmployeeTodayColors.mutedText,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailingChipLabel != null) ...[
            const SizedBox(width: 8),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Chip(
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                label: Text(
                  trailingChipLabel!,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
