import 'package:flutter/material.dart';

import '../../../../../core/theme/signup_premium_tokens.dart';

/// Purple gradient primary CTA with soft shadow and press scale (signup light shell).
class AuthSignupPrimaryButton extends StatefulWidget {
  const AuthSignupPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  State<AuthSignupPrimaryButton> createState() =>
      _AuthSignupPrimaryButtonState();
}

class _AuthSignupPrimaryButtonState extends State<AuthSignupPrimaryButton> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    final hasAction = widget.onPressed != null;
    final canTap = hasAction && !widget.isLoading;
    final disabledIdle = widget.onPressed == null && !widget.isLoading;

    return Opacity(
      opacity: disabledIdle ? 0.55 : 1,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 90),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: SignupPremiumGradients.primaryCta,
            borderRadius: BorderRadius.circular(
              SignupPremiumLayout.fieldRadius,
            ),
            border: Border.all(color: Colors.transparent),
            boxShadow: !disabledIdle
                ? [
                    BoxShadow(
                      color: SignupPremiumColors.purpleDeep.withValues(
                        alpha: 0.35,
                      ),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(
                SignupPremiumLayout.fieldRadius,
              ),
              onHighlightChanged: (pressed) {
                setState(() => _scale = pressed ? 0.985 : 1);
              },
              onTap: canTap ? widget.onPressed : null,
              child: SizedBox(
                width: double.infinity,
                height: SignupPremiumLayout.buttonHeight,
                child: Center(
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.label,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: canTap
                                    ? Colors.white
                                    : SignupPremiumColors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
