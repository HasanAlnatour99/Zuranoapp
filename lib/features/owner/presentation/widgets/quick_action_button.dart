import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_surface_card.dart';

/// Accent tone for [QuickActionButton]. Only [primary] tone is rendered with
/// the bold filled surface; the rest use the neutral surface card.
enum QuickActionTone { primary, neutral }

/// Square tap target used in the Owner overview quick actions row.
///
/// Owner overview uses the `primary` variant for `Add sale` (the core
/// operational action) to establish a clear visual hierarchy and leaves the
/// rest as neutral cards. Style-only widget — business logic must stay in the
/// caller's `onTap` callback.
class QuickActionButton extends StatelessWidget {
  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.tone = QuickActionTone.neutral,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final QuickActionTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isPrimary = tone == QuickActionTone.primary;

    if (isPrimary) {
      return _PrimaryQuickAction(
        icon: icon,
        label: label,
        onTap: onTap,
        scheme: scheme,
        textTheme: theme.textTheme,
      );
    }

    return AppSurfaceCard(
      borderRadius: AppRadius.large,
      padding: EdgeInsets.zero,
      showShadow: false,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.medium,
          horizontal: AppSpacing.small,
        ),
        child: _QuickActionContent(
          icon: icon,
          label: label,
          iconColor: scheme.primary,
          labelColor: scheme.onSurface,
        ),
      ),
    );
  }
}

class _PrimaryQuickAction extends StatelessWidget {
  const _PrimaryQuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.scheme,
    required this.textTheme,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final ColorScheme scheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.large);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.primary,
                Color.alphaBlend(
                  scheme.primary.withValues(alpha: 0.65),
                  scheme.surfaceContainerHighest,
                ),
              ],
            ),
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.28),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.medium,
            horizontal: AppSpacing.small,
          ),
          child: _QuickActionContent(
            icon: icon,
            label: label,
            iconColor: scheme.onPrimary,
            labelColor: scheme.onPrimary,
            bold: true,
          ),
        ),
      ),
    );
  }
}

class _QuickActionContent extends StatelessWidget {
  const _QuickActionContent({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.labelColor,
    this.bold = false,
  });

  final IconData icon;
  final String label;
  final Color iconColor;
  final Color labelColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(height: AppSpacing.small),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelMedium?.copyWith(
            color: labelColor,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            height: 1.15,
          ),
        ),
      ],
    );
  }
}
