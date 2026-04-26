import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../logic/owner_overview_state.dart';
import 'overview_design_tokens.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Compact team snapshot + View team CTA.
class OverviewTeamCompactCard extends StatelessWidget {
  const OverviewTeamCompactCard({
    super.key,
    required this.state,
    required this.onViewTeam,
  });

  final OwnerOverviewState state;
  final VoidCallback onViewTeam;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final previews = state.teamBarberPreview.take(3).toList();

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
            Row(
              children: [
                Icon(
                  AppIcons.groups_outlined,
                  color: OwnerOverviewTokens.purple,
                ),
                const Gap(8),
                Expanded(
                  child: Text(
                    l10n.ownerOverviewTeamCardTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: OwnerOverviewTokens.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(10),
            Text(
              l10n.ownerOverviewTeamActiveBarbersLabel(state.activeBarberCount),
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 13,
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(4),
            Text(
              l10n.ownerOverviewTeamCheckedInShort(state.checkedInBarbersToday),
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 13,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const Gap(12),
            Row(
              children: [
                for (var i = 0; i < 3; i++) ...[
                  if (i > 0) const Gap(8),
                  _MiniAvatar(
                    name: i < previews.length ? previews[i].name : null,
                    scheme: scheme,
                  ),
                ],
                const Spacer(),
                TextButton(
                  onPressed: onViewTeam,
                  style: TextButton.styleFrom(
                    foregroundColor: OwnerOverviewTokens.purple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                  ),
                  child: Text(
                    l10n.ownerOverviewViewTeam,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniAvatar extends StatelessWidget {
  const _MiniAvatar({required this.name, required this.scheme});

  final String? name;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final trimmed = (name ?? '').trim();
    final initial = trimmed.isNotEmpty
        ? trimmed.substring(0, 1).toUpperCase()
        : '';
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.primary.withValues(alpha: 0.12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      alignment: Alignment.center,
      child: initial.isEmpty
          ? Icon(
              AppIcons.person_outline_rounded,
              size: 18,
              color: scheme.onSurfaceVariant,
            )
          : Text(
              initial,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: OwnerOverviewTokens.purple,
              ),
            ),
    );
  }
}
