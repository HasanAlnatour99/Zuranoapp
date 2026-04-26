import 'package:flutter/material.dart';

import '../../../../core/theme/auth_premium_tokens.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.illustration,
    this.centered = false,
  });

  final String title;
  final String? subtitle;
  final Widget? illustration;

  /// When true, logo and titles align to the center (luxury login hero).
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final align = centered
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;
    final textAlign = centered ? TextAlign.center : TextAlign.start;

    return Column(
      crossAxisAlignment: align,
      children: [
        if (illustration != null) ...[
          if (centered) Center(child: illustration!) else illustration!,
          SizedBox(height: centered ? 14 : AuthPremiumLayout.sectionGap),
        ],
        Text(
          title,
          textAlign: textAlign,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AuthPremiumColors.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
        if (subtitle != null && subtitle!.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            subtitle!,
            textAlign: textAlign,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AuthPremiumColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ],
    );
  }
}
