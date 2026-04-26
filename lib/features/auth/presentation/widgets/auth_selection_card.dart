import 'package:flutter/material.dart';

import '../../../../core/theme/auth_premium_tokens.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class AuthSelectionCard extends StatelessWidget {
  const AuthSelectionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.selected,
    required this.onTap,
    this.leading,
  });

  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AuthPremiumLayout.cardRadius),
        border: Border.all(
          width: selected ? 2 : 1,
          color: selected ? AuthPremiumColors.accent : AuthPremiumColors.border,
        ),
        color: selected
            ? AuthPremiumColors.accent.withValues(alpha: 0.12)
            : AuthPremiumColors.surfaceElevated.withValues(alpha: 0.5),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AuthPremiumColors.accent.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AuthPremiumLayout.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 14)],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AuthPremiumColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AuthPremiumColors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                AnimatedScale(
                  scale: selected ? 1 : 0.85,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    selected ? AppIcons.check_circle : AppIcons.circle_outlined,
                    color: selected
                        ? AuthPremiumColors.accent
                        : AuthPremiumColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
