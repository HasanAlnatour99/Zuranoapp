import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class HrSectionHeader extends StatelessWidget {
  const HrSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.actionIcon,
    this.onActionTap,
  });

  final String title;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: ZuranoPremiumUiColors.textPrimary,
            ),
          ),
        ),
        if (actionLabel != null && onActionTap != null)
          TextButton.icon(
            onPressed: onActionTap,
            icon: Icon(
              actionIcon ?? Icons.add_rounded,
              size: 20,
              color: ZuranoPremiumUiColors.primaryPurple,
            ),
            label: Text(
              actionLabel!,
              style: theme.textTheme.labelLarge?.copyWith(
                color: ZuranoPremiumUiColors.primaryPurple,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: TextButton.styleFrom(
              minimumSize: const Size(44, 44),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
      ],
    );
  }
}
