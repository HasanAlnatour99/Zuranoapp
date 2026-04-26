import 'package:flutter/material.dart';

import '../../../../core/formatting/app_money_format.dart';
import '../../data/models/team_sales_summary_model.dart';
import '../../../../l10n/app_localizations.dart';
import '../theme/team_member_profile_colors.dart';

class TopSoldServicesCard extends StatelessWidget {
  const TopSoldServicesCard({
    super.key,
    required this.services,
    required this.currencyCode,
  });

  final List<TopSoldServiceModel> services;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TeamMemberProfileColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: TeamMemberProfileColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: TeamMemberProfileColors.softPurple,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.emoji_events_outlined,
                  color: TeamMemberProfileColors.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  l10n.teamSalesTopServicesTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: TeamMemberProfileColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (services.isEmpty)
            Text(
              l10n.teamTopServicesEmpty,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TeamMemberProfileColors.textSecondary,
              ),
            )
          else
            for (var i = 0; i < services.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      services[i].serviceName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: TeamMemberProfileColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        l10n.teamSalesTopServiceCount(services[i].quantity),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: TeamMemberProfileColors.textSecondary,
                        ),
                      ),
                      Text(
                        formatMoney(
                          services[i].totalRevenue,
                          currencyCode,
                          locale,
                        ),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: TeamMemberProfileColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
        ],
      ),
    );
  }
}
