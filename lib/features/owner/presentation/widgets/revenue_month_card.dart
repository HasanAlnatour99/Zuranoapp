import 'package:flutter/material.dart';

import '../../../../core/formatting/app_money_format.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../logic/owner_overview_state.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Month revenue: compact fintech card (title, value, one hint line).
class RevenueMonthCard extends StatelessWidget {
  const RevenueMonthCard({
    super.key,
    required this.state,
    required this.locale,
  });

  final OwnerOverviewState state;
  final Locale locale;

  static const EdgeInsets _cardPadding = EdgeInsets.all(18);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final valueText = formatAppMoney(
      state.monthRevenue,
      state.currencyCode,
      locale,
    );

    final String? hintText;
    if (!state.hasMonthRevenue) {
      hintText = l10n.ownerOverviewRevenueMonthHintEmpty;
    } else if (state.hasTodayRevenue) {
      hintText = l10n.ownerOverviewRevenueTodayLine(
        formatAppMoney(state.todayRevenue, state.currencyCode, locale),
      );
    } else {
      hintText = null;
    }

    final titleStyle = theme.textTheme.titleSmall?.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: scheme.onSurface,
    );
    final valueStyle = theme.textTheme.titleLarge?.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.4,
      height: 1.1,
      color: scheme.onSurface,
    );
    final hintStyle = theme.textTheme.bodySmall?.copyWith(
      fontSize: 13,
      color: scheme.onSurfaceVariant,
      height: 1.3,
    );

    return AppSurfaceCard(
      borderRadius: AppRadius.large,
      padding: _cardPadding,
      showShadow: false,
      outlineOpacity: 0.2,
      color: Color.alphaBlend(
        scheme.primary.withValues(alpha: 0.04),
        scheme.surfaceContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                AppIcons.account_balance_wallet_outlined,
                color: scheme.primary.withValues(alpha: 0.88),
                size: 20,
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: Text(
                  l10n.ownerOverviewRevenueMonthLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: titleStyle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(valueText, textAlign: TextAlign.start, style: valueStyle),
          if (hintText != null) ...[
            const SizedBox(height: 6),
            Text(
              hintText,
              textAlign: TextAlign.start,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: hintStyle,
            ),
          ],
        ],
      ),
    );
  }
}
