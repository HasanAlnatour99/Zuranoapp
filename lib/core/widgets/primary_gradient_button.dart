import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// CTA with Zurano purple gradient, disabled “soft” state, and shadow only when tappable.
class PrimaryGradientButton extends StatefulWidget {
  const PrimaryGradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.minHeight = 58,
    this.borderRadius = 19,
  });

  final String label;
  final VoidCallback? onPressed;
  final double minHeight;
  final double borderRadius;

  @override
  State<PrimaryGradientButton> createState() => _PrimaryGradientButtonState();
}

class _PrimaryGradientButtonState extends State<PrimaryGradientButton> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final r = widget.borderRadius;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 90),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(r),
            color: enabled
                ? null
                : AppBrandColorsPremium.secondary.withValues(alpha: 0.5),
            gradient: enabled ? AppPremiumGradients.accent : null,
            border: enabled
                ? null
                : Border.all(
                    color: AppBrandColorsPremium.primary.withValues(alpha: 0.2),
                  ),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: AppBrandColorsPremium.primary.withValues(
                        alpha: 0.35,
                      ),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: enabled
                  ? () {
                      widget.onPressed?.call();
                    }
                  : null,
              onHighlightChanged: (v) {
                if (enabled) {
                  setState(() => _scale = v ? 0.985 : 1);
                }
              },
              borderRadius: BorderRadius.circular(r),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: double.infinity,
                  minHeight: widget.minHeight,
                ),
                child: Center(
                  child: Text(
                    widget.label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: enabled
                          ? AppBrandColorsPremium.onPrimary
                          : AppBrandColorsPremium.primary.withValues(
                              alpha: 0.5,
                            ),
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
