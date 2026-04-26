import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/formatting/app_money_format.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../logic/owner_overview_state.dart';
import 'overview_design_tokens.dart';

/// Up to three active services from overview state.
class OverviewRecentServicesCard extends StatelessWidget {
  const OverviewRecentServicesCard({
    super.key,
    required this.state,
    required this.locale,
  });

  final OwnerOverviewState state;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final items = state.servicePreviewTop3;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(OwnerOverviewTokens.cardRadius),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.ownerOverviewRecentServicesTitle,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: OwnerOverviewTokens.textPrimary,
              ),
            ),
            const Gap(10),
            if (items.isEmpty)
              Text(
                l10n.ownerOverviewRecentServicesEmpty,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                  color: scheme.onSurfaceVariant,
                ),
              )
            else
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) Divider(height: 20, color: scheme.outlineVariant),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        items[i].name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: OwnerOverviewTokens.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      formatAppMoney(
                        items[i].price,
                        state.currencyCode,
                        locale,
                      ),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: OwnerOverviewTokens.purple,
                      ),
                    ),
                  ],
                ),
              ],
          ],
        ),
      ),
    );
  }
}
