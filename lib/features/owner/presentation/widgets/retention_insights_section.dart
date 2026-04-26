import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../features/insights/data/models/salon_insight.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/salon_streams_provider.dart';

class RetentionInsightsSection extends ConsumerWidget {
  const RetentionInsightsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context);
    final insightsAsync = ref.watch(insightsStreamProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.ownerRetentionTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        Text(
          l10n.ownerRetentionSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        insightsAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (_, _) => Text(l10n.ownerInsightsError),
          data: (insights) {
            final retention =
                insights
                    .where((e) => e.type == SalonInsightTypes.customerRetention)
                    .toList()
                  ..sort(
                    (a, b) => (b.weekKey ?? '').compareTo(a.weekKey ?? ''),
                  );
            final latest = retention.isEmpty ? null : retention.first;
            final p = latest?.retentionPayload;
            if (p == null) {
              return Text(
                l10n.ownerRetentionEmpty,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              );
            }

            String deltaLabel(int d) {
              if (d == 0) {
                return l10n.ownerRetentionDeltaFlat;
              }
              if (d > 0) {
                return l10n.ownerRetentionDeltaUp(d);
              }
              return l10n.ownerRetentionDeltaDown(-d);
            }

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.ownerRetentionMonthLabel(
                        p.calendarYear,
                        p.calendarMonth.toString().padLeft(2, '0'),
                      ),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    Text(
                      l10n.ownerRetentionTimeZoneUsed(p.timeZone),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.outline,
                      ),
                    ),
                    if (latest?.weekKey != null &&
                        latest!.weekKey!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        latest.weekKey!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.outline,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.medium),
                    _metricRow(
                      theme,
                      l10n.ownerRetentionRepeatCustomers,
                      '${p.repeatCustomersThisMonth}',
                    ),
                    _metricRow(
                      theme,
                      l10n.ownerRetentionFirstTimeCustomers,
                      '${p.firstTimeCustomersThisMonth}',
                    ),
                    _metricRow(
                      theme,
                      l10n.ownerRetentionDistinctThisMonth,
                      '${p.distinctCustomersCompletedThisMonth}',
                    ),
                    _metricRow(
                      theme,
                      l10n.ownerRetentionReturningThisMonth,
                      '${p.returningCustomersThisMonth}',
                    ),
                    _metricRow(
                      theme,
                      l10n.ownerRetentionRate,
                      NumberFormat.percentPattern(
                        locale.toString(),
                      ).format(p.retentionRate),
                    ),
                    _metricRow(
                      theme,
                      l10n.ownerRetentionInactive30Days,
                      '${p.customersWithNoVisit30Days}',
                    ),
                    const Divider(height: AppSpacing.large),
                    Text(
                      l10n.ownerRetentionNoShowTrend,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    _metricRow(
                      theme,
                      l10n.ownerRetentionNoShowLastLocalWeek,
                      '${p.noShowCountLastLocalWeek}',
                    ),
                    _metricRow(
                      theme,
                      l10n.ownerRetentionNoShowPreviousLocalWeek,
                      '${p.noShowCountPreviousLocalWeek}',
                    ),
                    _metricRow(
                      theme,
                      l10n.ownerRetentionNoShowDelta,
                      deltaLabel(p.noShowDeltaLastVsPrevious),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  static Widget _metricRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.small),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
