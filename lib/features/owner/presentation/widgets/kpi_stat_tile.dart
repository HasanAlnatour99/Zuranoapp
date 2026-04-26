import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_surface_card.dart';

/// Single glanceable KPI for the owner dashboard grid.
class KpiStatTile extends StatelessWidget {
  const KpiStatTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.emphasize = false,
    this.deltaLabel,
    this.deltaPositive,
    this.statusBadgeLabel,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool emphasize;

  /// Short comparison line, e.g. "+2 vs yesterday".
  final String? deltaLabel;

  /// When non-null, tints [deltaLabel] green/red.
  final bool? deltaPositive;

  /// Compact chip (e.g. Live / Quiet).
  final String? statusBadgeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fill = emphasize
        ? Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.12),
            scheme.surfaceContainer,
          )
        : null;
    final iconFill = emphasize
        ? scheme.primary.withValues(alpha: 0.18)
        : scheme.primary.withValues(alpha: 0.10);
    final iconColor = emphasize
        ? scheme.onPrimaryContainer
        : scheme.primary.withValues(alpha: 0.92);
    final valueColor = emphasize ? scheme.onPrimaryContainer : null;

    return AppSurfaceCard(
      borderRadius: AppRadius.medium,
      padding: const EdgeInsets.all(18),
      showShadow: false,
      outlineOpacity: 0.2,
      color: fill,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 104),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconFill,
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                const SizedBox(width: AppSpacing.small),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.92),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if ((statusBadgeLabel ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: AppSpacing.small / 2,
                    ),
                    child: _KpiStatusBadge(label: statusBadgeLabel!),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
                height: 1.0,
                color: valueColor,
              ),
            ),
            if ((deltaLabel ?? '').isNotEmpty) ...[
              const SizedBox(height: AppSpacing.small / 2),
              Text(
                deltaLabel!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 12,
                  color: _deltaColor(scheme, deltaPositive),
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _deltaColor(ColorScheme scheme, bool? positive) {
    if (positive == null) {
      return scheme.onSurfaceVariant.withValues(alpha: 0.85);
    }
    return positive ? scheme.primary : scheme.error;
  }
}

class _KpiStatusBadge extends StatelessWidget {
  const _KpiStatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: AppSpacing.small / 2,
      ),
      decoration: BoxDecoration(
        color: scheme.outlineVariant.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(AppRadius.small),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

/// Four equal-size KPI tiles in a 2x2 dashboard grid.
class OwnerKpiGrid extends StatelessWidget {
  const OwnerKpiGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 720 ? 4 : 2;
        return StaggeredGrid.count(
          crossAxisCount: columns,
          mainAxisSpacing: AppSpacing.small,
          crossAxisSpacing: AppSpacing.small,
          children: [
            for (final child in children)
              StaggeredGridTile.fit(crossAxisCellCount: 1, child: child),
          ],
        );
      },
    );
  }
}
