import 'package:flutter/material.dart';

import '../../../../core/theme/auth_premium_tokens.dart';

class AuthSecondaryButton extends StatelessWidget {
  const AuthSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leading,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(
          double.infinity,
          AuthPremiumLayout.buttonHeightMin,
        ),
        foregroundColor: AuthPremiumColors.textPrimary,
        side: const BorderSide(color: AuthPremiumColors.border),
        backgroundColor: AuthPremiumColors.surfaceElevated.withValues(
          alpha: 0.35,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AuthPremiumLayout.fieldRadius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 10)],
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
