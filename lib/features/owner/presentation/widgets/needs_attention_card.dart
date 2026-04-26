import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Visual priority of a [NeedsAttentionItem]. Drives accent color and whether
/// the row gets the chevron/affordance treatment.
enum NeedsAttentionUrgency { low, medium, high }

/// One actionable row in the "Needs attention" card.
///
/// The controller builds these from the overview state; widgets should never
/// derive urgency themselves.
class NeedsAttentionItem {
  const NeedsAttentionItem({
    required this.id,
    required this.icon,
    required this.label,
    this.trailingLabel,
    this.onTap,
    this.urgency = NeedsAttentionUrgency.medium,
    this.actionLabel,
    this.onAction,
  });

  final String id;
  final IconData icon;
  final String label;

  /// Short counter or status text shown next to the label (e.g. "3").
  final String? trailingLabel;
  final VoidCallback? onTap;
  final NeedsAttentionUrgency urgency;

  /// Optional compact CTA (e.g. Run payroll) shown beside the row.
  final String? actionLabel;
  final VoidCallback? onAction;
}

/// Operational "Needs review" summary card shown on Owner overview.
///
/// Receives a pre-computed list of [NeedsAttentionItem]s. Shows a clean empty
/// state when nothing needs action and applies a warning-tinted surface when
/// there is work to do.
class NeedsAttentionCard extends StatelessWidget {
  const NeedsAttentionCard({
    super.key,
    required this.items,
    this.title,
    this.emptyMessage,
    this.maxItems = 8,
    this.emptyActions,
  });

  final List<NeedsAttentionItem> items;
  final String? title;
  final String? emptyMessage;
  final int maxItems;

  /// Shown under the empty message (e.g. quick-start CTAs).
  final List<Widget>? emptyActions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final resolvedTitle = title ?? l10n.ownerOverviewNeedsAttentionTitle;
    final resolvedEmpty = emptyMessage ?? l10n.ownerOverviewNeedsAttentionNone;
    final sorted = List<NeedsAttentionItem>.from(items)
      ..sort((a, b) => _urgencyRank(b).compareTo(_urgencyRank(a)));
    final visible = sorted.take(maxItems).toList();
    final hasWork = visible.isNotEmpty;
    final warningAmber = const Color(0xFFE8A317);
    final accent = hasWork ? warningAmber : scheme.primary;
    final fill = hasWork
        ? Color.alphaBlend(
            warningAmber.withValues(alpha: 0.14),
            scheme.surfaceContainer,
          )
        : null;
    final card = AppSurfaceCard(
      borderRadius: AppRadius.large,
      padding: const EdgeInsets.all(18),
      color: fill,
      showBorder: !hasWork,
      outlineOpacity: hasWork ? 0 : 0.22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                visible.isEmpty
                    ? AppIcons.verified_outlined
                    : AppIcons.warning_amber_rounded,
                color: accent,
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: Text(
                  resolvedTitle,
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
          if (!hasWork) ...[
            Text(
              resolvedEmpty,
              textAlign: TextAlign.start,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 13,
                color: scheme.onSurfaceVariant,
              ),
            ),
            if (emptyActions != null && emptyActions!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.medium),
              Wrap(
                spacing: AppSpacing.small,
                runSpacing: AppSpacing.small,
                children: emptyActions!,
              ),
            ],
          ] else
            for (var i = 0; i < visible.length; i++) ...[
              if (i > 0)
                Divider(
                  height: AppSpacing.medium,
                  color: scheme.outlineVariant,
                ),
              _AttentionRow(item: visible[i]),
            ],
        ],
      ),
    );

    if (!hasWork) return card;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(
          color: warningAmber.withValues(alpha: 0.42),
          width: 1,
        ),
      ),
      child: card,
    );
  }
}

int _urgencyRank(NeedsAttentionItem item) {
  switch (item.urgency) {
    case NeedsAttentionUrgency.high:
      return 3;
    case NeedsAttentionUrgency.medium:
      return 2;
    case NeedsAttentionUrgency.low:
      return 1;
  }
}

class _AttentionRow extends StatelessWidget {
  const _AttentionRow({required this.item});

  final NeedsAttentionItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = _accent(item.urgency, scheme);
    final child = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
          child: Icon(item.icon, size: 18, color: accent),
        ),
        const SizedBox(width: AppSpacing.small),
        Expanded(
          child: Text(
            item.label,
            textAlign: TextAlign.start,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 13),
          ),
        ),
        if ((item.trailingLabel ?? '').isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.small,
              vertical: AppSpacing.small / 2,
            ),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: Text(
              item.trailingLabel!,
              style: theme.textTheme.labelMedium?.copyWith(
                color: accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.small / 2),
        ],
        if ((item.actionLabel ?? '').isNotEmpty && item.onAction != null) ...[
          const SizedBox(width: AppSpacing.small / 2),
          FilledButton.tonal(
            onPressed: item.onAction,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.small,
                vertical: AppSpacing.small / 2,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              item.actionLabel!,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
        if (item.onTap != null &&
            (item.actionLabel == null || item.onAction == null))
          Icon(
            AppIcons.chevron_right_rounded,
            size: 20,
            color: scheme.onSurfaceVariant,
          ),
      ],
    );

    if (item.onTap == null) return child;

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.small / 2),
        child: child,
      ),
    );
  }

  Color _accent(NeedsAttentionUrgency urgency, ColorScheme scheme) {
    switch (urgency) {
      case NeedsAttentionUrgency.high:
        return scheme.error;
      case NeedsAttentionUrgency.medium:
        return const Color(0xFFE8B659);
      case NeedsAttentionUrgency.low:
        return scheme.primary;
    }
  }
}
