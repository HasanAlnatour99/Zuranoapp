import 'package:flutter/material.dart';

import '../employee_today_theme.dart';

class EtPremiumCard extends StatelessWidget {
  const EtPremiumCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 28,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: EmployeeTodayColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class EtPrimaryGradientButton extends StatelessWidget {
  const EtPrimaryGradientButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.loading = false,
    this.expandWidth = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool loading;

  /// When true, the gradient fills the horizontal space (e.g. stacked punch CTAs).
  final bool expandWidth;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    final radius = BorderRadius.circular(20);

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: ExcludeSemantics(
        child: Opacity(
          opacity: enabled ? 1 : 0.55,
          child: ClipRRect(
            borderRadius: radius,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: enabled ? onPressed : null,
                borderRadius: radius,
                splashColor: Colors.white.withValues(alpha: 0.18),
                highlightColor: Colors.white.withValues(alpha: 0.08),
                child: Ink(
                  width: expandWidth ? double.infinity : null,
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        EmployeeTodayColors.heroGradientStart,
                        EmployeeTodayColors.heroGradientEnd,
                      ],
                    ),
                    borderRadius: radius,
                    boxShadow: [
                      BoxShadow(
                        color: EmployeeTodayColors.primaryPurple.withValues(
                          alpha: 0.25,
                        ),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            textDirection: Directionality.of(context),
                            children: [
                              if (icon != null) ...[
                                Icon(icon, color: Colors.white),
                                const SizedBox(width: 10),
                              ],
                              Text(
                                label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ],
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
