import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/auth_premium_tokens.dart';

/// Primary form submit action — uses the premium purple brand direction.
/// Only used in onboarding and auth-adjacent screens.
class AppSubmitButton extends StatelessWidget {
  const AppSubmitButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final disabled = onPressed == null || isLoading;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: disabled ? null : AppPremiumGradients.accent,
        borderRadius: BorderRadius.circular(AuthPremiumLayout.fieldRadius),
        color: disabled ? scheme.surfaceContainerHighest : null,
        border: Border.all(
          color: scheme.outline.withValues(alpha: disabled ? 0.65 : 0),
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: disabled ? null : onPressed,
          borderRadius: BorderRadius.circular(AuthPremiumLayout.fieldRadius),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: double.infinity,
              minHeight: AuthPremiumLayout.buttonHeightMin,
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: disabled
                            ? scheme.onSurfaceVariant
                            : Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
