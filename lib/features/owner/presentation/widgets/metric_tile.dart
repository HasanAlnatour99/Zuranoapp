import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_surface_card.dart';

/// Accent tones for [MetricTile]. Each tone drives an icon bg + subtle border
/// stripe so the 2x2 grid scans quickly without turning every tile into a
/// loud chip.
enum MetricTileTone { success, info, positive, warning, neutral }

/// Rich stat card used across the Owner overview 2x2 grid. Receives already
/// formatted [value] / [label] / [helperText]; business logic stays outside.
class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.helperText,
    this.tone = MetricTileTone.neutral,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? helperText;
  final MetricTileTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = _accentColor(tone, scheme);

    return AppSurfaceCard(
      borderRadius: AppRadius.large,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.65),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.large),
                topRight: Radius.circular(AppRadius.large),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.small),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    border: Border.all(color: accent.withValues(alpha: 0.35)),
                  ),
                  child: Icon(icon, color: accent, size: 20),
                ),
                const SizedBox(height: AppSpacing.medium),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.small / 2),
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if ((helperText ?? '').isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.small / 2),
                  Text(
                    helperText!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _accentColor(MetricTileTone tone, ColorScheme scheme) {
    switch (tone) {
      case MetricTileTone.success:
        return const Color(0xFF39D6A3);
      case MetricTileTone.info:
        return const Color(0xFF4FB8D0);
      case MetricTileTone.positive:
        return const Color(0xFF7BD389);
      case MetricTileTone.warning:
        return const Color(0xFFE8B659);
      case MetricTileTone.neutral:
        return scheme.primary;
    }
  }
}
