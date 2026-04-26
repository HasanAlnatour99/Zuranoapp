import 'package:flutter/material.dart';

import '../theme/auth_premium_tokens.dart';

/// Full-width OAuth row: white surface, light border, subtle elevation.
///
/// Matches auth/signup outlined fields via [AuthPremiumLayout.fieldRadius].
class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.icon,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
  });

  static const double height = 56;

  final Widget icon;
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;

  bool get _interactive => enabled && !isLoading && onPressed != null;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AuthPremiumLayout.fieldRadius);

    Widget child = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _interactive ? onPressed : null,
        borderRadius: radius,
        child: Ink(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: radius,
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: Offset.zero,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: isLoading
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: scheme.primary,
                            ),
                          )
                        : icon,
                  ),
                ),
                Expanded(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 22,
                  child: _interactive
                      ? Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.black.withValues(alpha: 0.38),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!enabled && !isLoading) {
      child = Opacity(opacity: 0.55, child: child);
    }

    return Semantics(
      button: true,
      enabled: _interactive,
      label: text,
      child: child,
    );
  }
}
