import 'package:flutter/material.dart';
import '../../../../core/formatting/app_money_format.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../logic/owner_overview_state.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Today summary: greeting, salon context, earnings line, operational status.
class OverviewSummaryCard extends StatelessWidget {
  const OverviewSummaryCard({
    super.key,
    required this.userDisplayName,
    required this.salonName,
    required this.state,
    required this.locale,
  });

  final String userDisplayName;
  final String salonName;
  final OwnerOverviewState state;
  final Locale locale;

  static const EdgeInsets _cardPadding = EdgeInsets.all(18);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final greeting = _greetingFor(l10n, now);
    final headline = userDisplayName.isEmpty
        ? greeting
        : '$greeting, $userDisplayName';

    final summaryLine = _summaryLine(l10n, state, locale);
    final statusLine = _statusLine(l10n, state);

    final headlineStyle = theme.textTheme.titleSmall?.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.2,
    );
    final salonStyle = theme.textTheme.labelMedium?.copyWith(
      fontSize: 13,
      color: scheme.onSurfaceVariant.withValues(alpha: 0.9),
      fontWeight: FontWeight.w500,
    );
    final summaryStyle = theme.textTheme.bodyMedium?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.35,
    );
    final statusStyle = theme.textTheme.bodySmall?.copyWith(
      fontSize: 13,
      color: scheme.onSurfaceVariant.withValues(alpha: 0.92),
      height: 1.35,
    );

    return AppSurfaceCard(
      borderRadius: AppRadius.large,
      showShadow: false,
      outlineOpacity: 0.2,
      padding: _cardPadding,
      color: Color.alphaBlend(
        scheme.primary.withValues(alpha: 0.04),
        scheme.surfaceContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  border: Border.all(
                    color: scheme.primary.withValues(alpha: 0.18),
                  ),
                ),
                child: Icon(
                  AppIcons.dashboard_customize_outlined,
                  color: scheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headline,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: headlineStyle,
                    ),
                    if (salonName.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        salonName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: salonStyle,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(summaryLine, textAlign: TextAlign.start, style: summaryStyle),
          const SizedBox(height: 6),
          Text(statusLine, textAlign: TextAlign.start, style: statusStyle),
        ],
      ),
    );
  }

  static String _greetingFor(AppLocalizations l10n, DateTime now) {
    final hour = now.toLocal().hour;
    if (hour < 12) return l10n.ownerOverviewGreetingMorning;
    if (hour < 18) return l10n.ownerOverviewGreetingAfternoon;
    return l10n.ownerOverviewGreetingEvening;
  }

  static String _summaryLine(
    AppLocalizations l10n,
    OwnerOverviewState state,
    Locale locale,
  ) {
    if (!state.hasTodayRevenue && state.todayRevenue <= 0) {
      return l10n.ownerOverviewSummaryNoSalesToday;
    }
    final amount = formatAppMoney(
      state.todayRevenue,
      state.currencyCode,
      locale,
    );
    if (state.completedSalesTodayCount <= 0) {
      return l10n.ownerOverviewSummaryEarnedOnly(amount);
    }
    return l10n.ownerOverviewSummaryEarnedFromSales(
      amount,
      state.completedSalesTodayCount,
    );
  }

  static String _statusLine(AppLocalizations l10n, OwnerOverviewState state) {
    final parts = <String>[
      l10n.ownerOverviewSummaryPendingSegment(state.pendingBookingsCount),
      l10n.ownerOverviewSummaryBarbersCheckedInSegment(
        state.checkedInBarbersToday,
      ),
    ];
    if (!state.payrollRunExistsForCurrentMonth && state.hasMonthRevenue) {
      parts.add(l10n.ownerOverviewSummaryPayrollPendingSegment);
    }
    return parts.join(' · ');
  }
}
