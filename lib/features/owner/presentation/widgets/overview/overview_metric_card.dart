import 'package:flutter/material.dart';

import 'overview_design_tokens.dart';

/// KPI tile with bounded height-friendly layout (no bottom overflow).
class OverviewMetricCard extends StatelessWidget {
  const OverviewMetricCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.comparison,
    this.comparisonPositive,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final String? comparison;
  final bool? comparisonPositive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final deltaColor = comparisonPositive == null
        ? scheme.onSurfaceVariant
        : (comparisonPositive! ? const Color(0xFF059669) : scheme.error);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        splashColor: color.withValues(alpha: 0.08),
        highlightColor: color.withValues(alpha: 0.04),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.trending_up_rounded,
                        color: color,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: OwnerOverviewTypography.kpiTitle,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: OwnerOverviewTypography.kpiValue,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      height: 1.0,
                    ),
                  ),
                ),
                if ((comparison ?? '').isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    comparison!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: OwnerOverviewTypography.kpiDelta,
                      fontWeight: FontWeight.w600,
                      color: deltaColor,
                      height: 1.2,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
