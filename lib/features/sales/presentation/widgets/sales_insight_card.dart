import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart' show FinanceDashboardColors;

class SalesInsightCard extends StatelessWidget {
  const SalesInsightCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.helperText,
    this.actionText,
    this.onAction,
    this.child,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String helperText;
  final String? actionText;
  final VoidCallback? onAction;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FinanceDashboardColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: FinanceDashboardColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: FinanceDashboardColors.lightPurple,
            child: Icon(icon, color: FinanceDashboardColors.primaryPurple),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: FinanceDashboardColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: FinanceDashboardColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          if (child != null)
            SizedBox(
              height: 36,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: child!,
                ),
              ),
            ),
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                helperText,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: FinanceDashboardColors.textSecondary,
                ),
              ),
            ),
          ),
          if (actionText != null && onAction != null)
            TextButton(
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft,
              ),
              onPressed: onAction,
              child: Text(actionText!),
            ),
        ],
      ),
    );
  }
}
