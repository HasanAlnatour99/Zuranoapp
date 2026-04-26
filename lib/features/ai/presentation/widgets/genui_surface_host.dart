import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../../domain/models/ai_surface_response.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class GenuiSurfaceHost extends StatelessWidget {
  const GenuiSurfaceHost({
    required this.surface,
    this.onPromptAction,
    this.onRetryAction,
    super.key,
  });

  final AiSurfaceResponse surface;
  final ValueChanged<String>? onPromptAction;
  final VoidCallback? onRetryAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (surface.title != null || surface.summary != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.medium),
            child: _SurfaceHeading(
              title: surface.title,
              summary: surface.summary,
            ),
          ),
        ...surface.components.map(
          (component) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.medium),
            child: _ComponentCard(
              component: component,
              onPromptAction: onPromptAction,
              onRetryAction: onRetryAction,
            ),
          ),
        ),
      ],
    );
  }
}

class _SurfaceHeading extends StatelessWidget {
  const _SurfaceHeading({this.title, this.summary});

  final String? title;
  final String? summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        if (summary != null) ...[
          const SizedBox(height: AppSpacing.small),
          Text(
            summary!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class _ComponentCard extends StatelessWidget {
  const _ComponentCard({
    required this.component,
    this.onPromptAction,
    this.onRetryAction,
  });

  final AiComponent component;
  final ValueChanged<String>? onPromptAction;
  final VoidCallback? onRetryAction;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      color: _resolveFillColor(context, component.type),
      borderRadius: AppRadius.large,
      child: switch (component.type) {
        AiComponentType.sectionHeader => _SectionHeader(component: component),
        AiComponentType.kpiCard => _KpiCard(component: component),
        AiComponentType.rankingList => _RankingList(component: component),
        AiComponentType.actionButton => _ActionButtonCard(
          component: component,
          onPromptAction: onPromptAction,
          onRetryAction: onRetryAction,
        ),
        AiComponentType.emptyState => _StateCard(
          component: component,
          icon: AppIcons.auto_awesome_outlined,
        ),
        AiComponentType.errorState => _StateCard(
          component: component,
          icon: AppIcons.error_outline_rounded,
        ),
      },
    );
  }

  Color? _resolveFillColor(BuildContext context, AiComponentType type) {
    final scheme = Theme.of(context).colorScheme;
    return switch (type) {
      AiComponentType.sectionHeader => scheme.surfaceContainer,
      AiComponentType.kpiCard => scheme.surfaceContainerHigh,
      AiComponentType.rankingList => scheme.surfaceContainer,
      AiComponentType.actionButton => scheme.surfaceContainerHighest,
      AiComponentType.emptyState => scheme.surfaceContainer,
      AiComponentType.errorState => scheme.errorContainer.withValues(
        alpha: 0.5,
      ),
    };
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.component});

  final AiComponent component;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (component.badge != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.small,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Text(
              component.badge!,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        if (component.badge != null) const SizedBox(height: AppSpacing.medium),
        if (component.title != null)
          Text(
            component.title!,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        if (component.subtitle != null) ...[
          const SizedBox(height: AppSpacing.small),
          Text(
            component.subtitle!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.component});

  final AiComponent component;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (component.title != null)
          Text(
            component.title!,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        if (component.value != null) ...[
          const SizedBox(height: AppSpacing.small),
          Text(
            component.value!,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
        if (component.subtitle != null || component.badge != null) ...[
          const SizedBox(height: AppSpacing.small),
          Wrap(
            spacing: AppSpacing.small,
            runSpacing: AppSpacing.small,
            children: [
              if (component.subtitle != null)
                Text(
                  component.subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              if (component.badge != null)
                Text(
                  component.badge!,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _RankingList extends StatelessWidget {
  const _RankingList({required this.component});

  final AiComponent component;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (component.title != null)
          Text(
            component.title!,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        if (component.subtitle != null) ...[
          const SizedBox(height: AppSpacing.small),
          Text(
            component.subtitle!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.medium),
        ...component.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == component.items.length - 1
                  ? 0
                  : AppSpacing.medium,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.medium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (item.caption != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.caption!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.medium),
                Text(
                  item.value,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _ActionButtonCard extends StatelessWidget {
  const _ActionButtonCard({
    required this.component,
    this.onPromptAction,
    this.onRetryAction,
  });

  final AiComponent component;
  final ValueChanged<String>? onPromptAction;
  final VoidCallback? onRetryAction;

  @override
  Widget build(BuildContext context) {
    final action = component.action;
    if (action == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (component.title != null)
          Text(
            component.title!,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        if (component.subtitle != null) ...[
          const SizedBox(height: AppSpacing.small),
          Text(component.subtitle!),
        ],
        const SizedBox(height: AppSpacing.medium),
        FilledButton(
          onPressed: () => _handleAction(context, action),
          child: Text(action.label),
        ),
      ],
    );
  }

  void _handleAction(BuildContext context, AiAction action) {
    switch (action.type) {
      case AiActionType.navigate:
        final route = action.route;
        if (route != null && route.isNotEmpty) {
          context.push(route);
        }
        return;
      case AiActionType.prompt:
        final prompt = action.prompt;
        if (prompt != null && prompt.isNotEmpty) {
          onPromptAction?.call(prompt);
        }
        return;
      case AiActionType.retry:
        onRetryAction?.call();
        return;
    }
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({required this.component, required this.icon});

  final AiComponent component;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: scheme.primary),
        const SizedBox(height: AppSpacing.medium),
        if (component.title != null)
          Text(
            component.title!,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        if (component.subtitle != null) ...[
          const SizedBox(height: AppSpacing.small),
          Text(
            component.subtitle!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
