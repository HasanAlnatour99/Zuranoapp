import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_surface_card.dart';

class CustomerStatStripItem {
  const CustomerStatStripItem({required this.value, required this.label});

  final String value;
  final String label;
}

/// Dark KPI strip (three columns) using inverse surfaces + primary accents.
class CustomerStatsStripCard extends StatelessWidget {
  const CustomerStatsStripCard({super.key, required this.items})
    : assert(items.length == 3);

  final List<CustomerStatStripItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bg = scheme.inverseSurface;
    final onBg = scheme.onInverseSurface;

    return AppSurfaceCard(
      margin: EdgeInsets.zero,
      color: bg,
      showBorder: false,
      showShadow: false,
      borderRadius: AppRadius.xlarge,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.large,
        horizontal: AppSpacing.small,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: SizedBox(
                    width: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: onBg.withValues(alpha: 0.14),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: _StatCell(
                  value: items[i].value,
                  label: items[i].label,
                  valueStyle: theme.textTheme.headlineSmall?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                  labelStyle: theme.textTheme.labelMedium?.copyWith(
                    color: onBg.withValues(alpha: 0.72),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.value,
    required this.label,
    required this.valueStyle,
    required this.labelStyle,
  });

  final String value;
  final String label;
  final TextStyle? valueStyle;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: valueStyle, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.small),
        Text(
          label,
          style: labelStyle,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
