import 'package:flutter/material.dart';

import '../../../../core/formatting/app_money_format.dart';
import '../../../../l10n/app_localizations.dart';
import '../../logic/team_management_providers.dart';
import 'kpi_stat_tile.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class TeamSummaryStrip extends StatelessWidget {
  const TeamSummaryStrip({
    super.key,
    required this.summary,
    required this.currencyCode,
  });

  final TeamSummaryData summary;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return OwnerKpiGrid(
      children: [
        KpiStatTile(
          icon: AppIcons.content_cut_outlined,
          label: l10n.teamSummaryTotalBarbers,
          value: '${summary.totalBarbers}',
        ),
        KpiStatTile(
          icon: AppIcons.badge_outlined,
          label: l10n.teamSummaryCheckedInToday,
          value: '${summary.checkedInToday}',
        ),
        KpiStatTile(
          icon: AppIcons.point_of_sale_outlined,
          label: l10n.teamSummarySalesToday,
          value: formatAppMoney(summary.salesToday, currencyCode, locale),
        ),
        KpiStatTile(
          icon: AppIcons.payments_outlined,
          label: l10n.teamSummaryCommissionToday,
          value: formatAppMoney(summary.commissionToday, currencyCode, locale),
        ),
      ],
    );
  }
}
