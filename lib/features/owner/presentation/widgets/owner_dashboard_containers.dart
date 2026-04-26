import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_surface_card.dart';

/// Compact metric card (surface style; prefer for new dashboard layouts).
class OwnerDashboardRevenueHero extends StatelessWidget {
  const OwnerDashboardRevenueHero({
    super.key,
    required this.label,
    required this.value,
    this.periodHint,
  });

  final String label;
  final String value;
  final String? periodHint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppSurfaceCard(
      borderRadius: AppRadius.large,
      padding: const EdgeInsets.all(18),
      showShadow: false,
      outlineOpacity: 0.2,
      color: Color.alphaBlend(
        scheme.primary.withValues(alpha: 0.04),
        scheme.surfaceContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            textAlign: TextAlign.start,
            style: theme.textTheme.titleSmall?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
            ),
          ),
          if (periodHint != null) ...[
            const SizedBox(height: 6),
            Text(
              periodHint!,
              textAlign: TextAlign.start,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 13,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            value,
            textAlign: TextAlign.start,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// Rounded surface panel for dashboard sections (services, team, etc.).
class OwnerDashboardPanel extends StatelessWidget {
  const OwnerDashboardPanel({
    super.key,
    required this.child,
    this.title,
    this.titleStyle,
  });

  final Widget child;
  final String? title;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppSurfaceCard(
      borderRadius: AppRadius.xlarge,
      color: scheme.surfaceContainer,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Text(
              title!,
              textAlign: TextAlign.start,
              style:
                  titleStyle ??
                  theme.textTheme.titleSmall?.copyWith(
                    fontSize: 15,
                    color: scheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

/// Category strip (soft container tone — not gold).
class OwnerDashboardCategoryBanner extends StatelessWidget {
  const OwnerDashboardCategoryBanner({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.small),
      child: AppSurfaceCard(
        borderRadius: AppRadius.medium,
        color: scheme.secondaryContainer.withValues(alpha: 0.85),
        showShadow: false,
        showBorder: false,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: scheme.onSecondaryContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// One service row: name (start) · price & duration (end).
class OwnerDashboardServiceRow extends StatelessWidget {
  const OwnerDashboardServiceRow({
    super.key,
    required this.name,
    required this.metaRight,
    this.showDivider = true,
  });

  final String name;
  final String metaRight;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Text(
                metaRight,
                textAlign: TextAlign.end,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(height: 1, color: scheme.outlineVariant),
      ],
    );
  }
}

/// Three-column ledger header (Service · Price · Team-style third column).
class OwnerDashboardLedgerHeader extends StatelessWidget {
  const OwnerDashboardLedgerHeader({
    super.key,
    required this.col1,
    required this.col2,
    required this.col3,
  });

  final String col1;
  final String col2;
  final String col3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme.labelMedium?.copyWith(
      color: scheme.onSurfaceVariant,
      fontWeight: FontWeight.w700,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.small),
      child: Row(
        children: [
          Expanded(flex: 5, child: Text(col1, style: style)),
          Expanded(
            flex: 3,
            child: Text(col2, style: style, textAlign: TextAlign.end),
          ),
          Expanded(
            flex: 4,
            child: Text(col3, style: style, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}

class OwnerDashboardLedgerRow extends StatelessWidget {
  const OwnerDashboardLedgerRow({
    super.key,
    required this.col1,
    required this.col2,
    required this.col3,
    this.showDivider = true,
  });

  final String col1;
  final String col2;
  final String col3;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final body = theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurface);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  col1,
                  style: body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  col2,
                  style: body?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  col3,
                  style: body,
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(height: 1, color: scheme.outlineVariant),
      ],
    );
  }
}
