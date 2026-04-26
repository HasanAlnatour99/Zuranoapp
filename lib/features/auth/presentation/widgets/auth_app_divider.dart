import 'package:flutter/material.dart';

import '../../../../core/theme/auth_premium_tokens.dart';

class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AuthPremiumColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AuthPremiumColors.textSecondary,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AuthPremiumColors.border)),
      ],
    );
  }
}
