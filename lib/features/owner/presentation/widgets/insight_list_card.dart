import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../logic/owner_dashboard_insights.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Insights with strong lines only, or a calm placeholder when data is thin.
class InsightListCard extends StatelessWidget {
  const InsightListCard({
    super.key,
    required this.lines,
    required this.showPlaceholder,
    required this.locale,
  });

  final List<DashboardInsightLine> lines;
  final bool showPlaceholder;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final textLines = _localize(l10n, locale);

    return AppSurfaceCard(
      borderRadius: AppRadius.large,
      padding: const EdgeInsets.all(18),
      showShadow: false,
      outlineOpacity: 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(AppIcons.insights_outlined, color: scheme.primary, size: 22),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: Text(
                  l10n.ownerOverviewInsightsTitle,
                  textAlign: TextAlign.start,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (showPlaceholder && textLines.isEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  AppIcons.auto_graph_outlined,
                  size: 20,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.75),
                ),
                const SizedBox(width: AppSpacing.small),
                Expanded(
                  child: Text(
                    l10n.ownerOverviewInsightsGrowing,
                    textAlign: TextAlign.start,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 13,
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.92),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            )
          else
            for (var i = 0; i < textLines.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.small),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    AppIcons.arrow_circle_right_outlined,
                    size: 18,
                    color: scheme.primary.withValues(alpha: 0.85),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Expanded(
                    child: Text(
                      textLines[i],
                      textAlign: TextAlign.start,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ],
        ],
      ),
    );
  }

  List<String> _localize(AppLocalizations l10n, Locale locale) {
    final out = <String>[];
    for (final line in lines) {
      switch (line) {
        case InsightTopBarberLine(:final name, :final percent):
          final pct = NumberFormat.decimalPercentPattern(
            locale: locale.toString(),
            decimalDigits: 0,
          ).format(percent / 100);
          out.add(l10n.ownerOverviewInsightTopBarberContribution(name, pct));
        case InsightTopServiceWeekLine(:final serviceName):
          out.add(l10n.ownerOverviewInsightTopServiceWeek(serviceName));
        case InsightBookingsCompareLine(:final signedPercent):
          final magnitude = signedPercent.abs().round();
          final formatted = '$magnitude%';
          if (signedPercent >= 0) {
            out.add(l10n.ownerOverviewInsightBookingsUp(formatted));
          } else {
            out.add(l10n.ownerOverviewInsightBookingsDown(formatted));
          }
        case InsightNoBookingsTodayLine():
          out.add(l10n.ownerOverviewInsightNoBookingsToday);
      }
    }
    return out;
  }
}
