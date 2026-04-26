import 'package:flutter/material.dart';

import '../../../../../core/theme/signup_premium_tokens.dart';

class AuthSignupOrDivider extends StatelessWidget {
  const AuthSignupOrDivider({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: SignupPremiumColors.borderStrong)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: SignupPremiumColors.textSecondary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Expanded(child: Divider(color: SignupPremiumColors.borderStrong)),
      ],
    );
  }
}
