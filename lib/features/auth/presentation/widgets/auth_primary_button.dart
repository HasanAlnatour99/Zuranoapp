import 'package:flutter/material.dart';

import '../../../../core/theme/auth_premium_tokens.dart';

class AuthPrimaryButton extends StatefulWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.minHeight,
    this.borderRadius,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? minHeight;
  final double? borderRadius;

  @override
  State<AuthPrimaryButton> createState() => _AuthPrimaryButtonState();
}

class _AuthPrimaryButtonState extends State<AuthPrimaryButton> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasAction = widget.onPressed != null;
    final canTap = hasAction && !widget.isLoading;
    final elevated = hasAction || widget.isLoading;
    final disabledIdle = widget.onPressed == null && !widget.isLoading;
    final radius = widget.borderRadius ?? AuthPremiumLayout.fieldRadius;
    final minH = widget.minHeight ?? AuthPremiumLayout.buttonHeightMin;

    return Opacity(
      opacity: disabledIdle ? 0.55 : 1,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 90),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AuthPremiumColors.gradientAccent,
            borderRadius: BorderRadius.circular(radius),
            color: elevated ? null : scheme.surfaceContainerHighest,
            border: Border.all(color: scheme.outline.withValues(alpha: 0.12)),
            boxShadow: elevated
                ? [
                    BoxShadow(
                      color: AuthPremiumColors.accent.withValues(alpha: 0.38),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: canTap
                  ? () {
                      widget.onPressed?.call();
                    }
                  : null,
              onHighlightChanged: (v) {
                setState(() => _scale = v ? 0.985 : 1);
              },
              borderRadius: BorderRadius.circular(radius),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: double.infinity,
                  minHeight: minH,
                ),
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: scheme.onPrimary,
                          ),
                        )
                      : Text(
                          widget.label,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: canTap
                                    ? scheme.onPrimary
                                    : scheme.onSurfaceVariant,
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
