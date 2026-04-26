import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_select_field.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/models/smart_workspace_models.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class SmartWorkspaceSurfaceHost extends StatelessWidget {
  const SmartWorkspaceSurfaceHost({
    required this.surface,
    required this.onPromptAction,
    required this.onWorkspaceAction,
    required this.onEmployeeChanged,
    required this.onPeriodChanged,
    required this.onDateRangeChanged,
    super.key,
  });

  final SmartWorkspaceSurface surface;
  final ValueChanged<String> onPromptAction;
  final ValueChanged<SmartWorkspaceAction> onWorkspaceAction;
  final ValueChanged<String> onEmployeeChanged;
  final ValueChanged<DateTime> onPeriodChanged;
  final void Function(DateTime startDate, DateTime endDate) onDateRangeChanged;

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
            child: _WorkspaceComponentCard(
              component: component,
              onPromptAction: onPromptAction,
              onWorkspaceAction: onWorkspaceAction,
              onEmployeeChanged: onEmployeeChanged,
              onPeriodChanged: onPeriodChanged,
              onDateRangeChanged: onDateRangeChanged,
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
              fontWeight: FontWeight.w800,
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

class _WorkspaceComponentCard extends StatelessWidget {
  const _WorkspaceComponentCard({
    required this.component,
    required this.onPromptAction,
    required this.onWorkspaceAction,
    required this.onEmployeeChanged,
    required this.onPeriodChanged,
    required this.onDateRangeChanged,
  });

  final SmartWorkspaceComponent component;
  final ValueChanged<String> onPromptAction;
  final ValueChanged<SmartWorkspaceAction> onWorkspaceAction;
  final ValueChanged<String> onEmployeeChanged;
  final ValueChanged<DateTime> onPeriodChanged;
  final void Function(DateTime startDate, DateTime endDate) onDateRangeChanged;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      showShadow: false,
      child: switch (component.type) {
        SmartWorkspaceComponentType.summaryCard => _SummaryCard(
          component: component,
        ),
        SmartWorkspaceComponentType.statusChip => _StatusChip(
          component: component,
        ),
        SmartWorkspaceComponentType.employeePicker => _EmployeePicker(
          component: component,
          onChanged: onEmployeeChanged,
        ),
        SmartWorkspaceComponentType.payrollElementCard => _PayrollElementCard(
          component: component,
        ),
        SmartWorkspaceComponentType.earningsBreakdownCard => _BreakdownCard(
          component: component,
        ),
        SmartWorkspaceComponentType.deductionsBreakdownCard => _BreakdownCard(
          component: component,
        ),
        SmartWorkspaceComponentType.dateRangePicker => _DateRangePickerCard(
          component: component,
          onChanged: onDateRangeChanged,
        ),
        SmartWorkspaceComponentType.periodSelector => _PeriodSelectorCard(
          component: component,
          onChanged: onPeriodChanged,
        ),
        SmartWorkspaceComponentType.actionButtonRow => _ActionButtonRow(
          component: component,
          onPromptAction: onPromptAction,
          onWorkspaceAction: onWorkspaceAction,
        ),
        SmartWorkspaceComponentType.chartCard => _ChartCard(
          component: component,
        ),
        SmartWorkspaceComponentType.emptyStateCard => _EmptyStateCard(
          component: component,
        ),
        SmartWorkspaceComponentType.confirmationPanel => _ConfirmationPanel(
          component: component,
          onPromptAction: onPromptAction,
          onWorkspaceAction: onWorkspaceAction,
        ),
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.component});

  final SmartWorkspaceComponent component;

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
        if (component.value != null) ...[
          const SizedBox(height: AppSpacing.small),
          Text(
            component.value!,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
        if (component.caption != null) ...[
          const SizedBox(height: AppSpacing.small / 2),
          Text(
            component.caption!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.component});

  final SmartWorkspaceComponent component;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = switch (component.tone) {
      SmartWorkspaceStatusTone.positive => (
        scheme.primary.withValues(alpha: 0.14),
        scheme.primary,
      ),
      SmartWorkspaceStatusTone.warning => (
        scheme.tertiary.withValues(alpha: 0.18),
        scheme.tertiary,
      ),
      SmartWorkspaceStatusTone.danger => (
        scheme.errorContainer,
        scheme.onErrorContainer,
      ),
      _ => (scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
    };

    return Wrap(
      spacing: AppSpacing.small,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colors.$1,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            component.title ?? '',
            style: theme.textTheme.labelLarge?.copyWith(
              color: colors.$2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmployeePicker extends StatelessWidget {
  const _EmployeePicker({required this.component, required this.onChanged});

  final SmartWorkspaceComponent component;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppSelectField<String>(
      label: component.title ?? '',
      value: component.selectedOptionId,
      hintText: component.subtitle,
      options: component.options
          .map(
            (option) => AppSelectOption<String>(
              value: option.id,
              label: option.label,
              subtitle: option.subtitle,
            ),
          )
          .toList(growable: false),
      onChanged: (value) {
        if (value != null && value.isNotEmpty) {
          onChanged(value);
        }
      },
    );
  }
}

class _PayrollElementCard extends StatelessWidget {
  const _PayrollElementCard({required this.component});

  final SmartWorkspaceComponent component;

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
              fontWeight: FontWeight.w800,
            ),
          ),
        if (component.subtitle != null) ...[
          const SizedBox(height: AppSpacing.small / 2),
          Text(
            component.subtitle!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
        if (component.value != null) ...[
          const SizedBox(height: AppSpacing.small),
          Text(
            component.value!,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
        if (component.caption != null) ...[
          const SizedBox(height: AppSpacing.small),
          Text(
            component.caption!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({required this.component});

  final SmartWorkspaceComponent component;

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
              fontWeight: FontWeight.w800,
            ),
          ),
        if (component.value != null) ...[
          const SizedBox(height: AppSpacing.small),
          Text(
            component.value!,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
        if (component.lines.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.medium),
          ...component.lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.small),
              child: Row(
                children: [
                  Expanded(
                    child: Text(line.label, style: theme.textTheme.bodyMedium),
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  Text(
                    line.value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: line.emphasis ? scheme.primary : null,
                      fontWeight: line.emphasis
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _DateRangePickerCard extends StatelessWidget {
  const _DateRangePickerCard({
    required this.component,
    required this.onChanged,
  });

  final SmartWorkspaceComponent component;
  final void Function(DateTime startDate, DateTime endDate) onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = component.title ?? l10n.smartWorkspaceDateRangePickerLabel;
    final value = component.startDate != null && component.endDate != null
        ? '${_formatDate(component.startDate!)} - ${_formatDate(component.endDate!)}'
        : l10n.smartWorkspaceDateRangePlaceholder;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(value),
      trailing: const Icon(AppIcons.date_range_rounded),
      onTap: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2024),
          lastDate: DateTime(2100),
          initialDateRange:
              component.startDate != null && component.endDate != null
              ? DateTimeRange(
                  start: component.startDate!,
                  end: component.endDate!,
                )
              : null,
        );
        if (picked != null) {
          onChanged(picked.start, picked.end);
        }
      },
    );
  }
}

class _PeriodSelectorCard extends StatelessWidget {
  const _PeriodSelectorCard({required this.component, required this.onChanged});

  final SmartWorkspaceComponent component;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final period = component.period;
    final label = component.title ?? l10n.smartWorkspacePeriodSelectorLabel;
    final value = period == null
        ? l10n.smartWorkspacePeriodPlaceholder
        : '${period.month}/${period.year}';

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(value),
      trailing: const Icon(AppIcons.calendar_month_rounded),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          firstDate: DateTime(2024),
          lastDate: DateTime(2100),
          initialDate: period ?? DateTime.now(),
          initialDatePickerMode: DatePickerMode.year,
        );
        if (picked != null) {
          onChanged(DateTime(picked.year, picked.month));
        }
      },
    );
  }
}

class _ActionButtonRow extends StatelessWidget {
  const _ActionButtonRow({
    required this.component,
    required this.onPromptAction,
    required this.onWorkspaceAction,
  });

  final SmartWorkspaceComponent component;
  final ValueChanged<String> onPromptAction;
  final ValueChanged<SmartWorkspaceAction> onWorkspaceAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (component.title != null) ...[
          Text(
            component.title!,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
        ],
        Wrap(
          spacing: AppSpacing.small,
          runSpacing: AppSpacing.small,
          children: component.actions
              .map((action) {
                if (action.primary) {
                  return SizedBox(
                    width: 180,
                    child: AppPrimaryButton(
                      label: action.label,
                      onPressed: () => _handleAction(context, action),
                    ),
                  );
                }
                return OutlinedButton(
                  onPressed: () => _handleAction(context, action),
                  child: Text(action.label),
                );
              })
              .toList(growable: false),
        ),
      ],
    );
  }

  void _handleAction(BuildContext context, SmartWorkspaceAction action) {
    switch (action.type) {
      case SmartWorkspaceActionType.navigate:
        final route = action.route;
        if (route != null && route.isNotEmpty) {
          context.push(route);
        }
        return;
      case SmartWorkspaceActionType.prompt:
        final prompt = action.prompt;
        if (prompt != null && prompt.isNotEmpty) {
          onPromptAction(prompt);
        }
        return;
      case SmartWorkspaceActionType.submit:
      case SmartWorkspaceActionType.setSelection:
      case SmartWorkspaceActionType.refresh:
        onWorkspaceAction(action);
        return;
    }
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.component});

  final SmartWorkspaceComponent component;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final maxValue = component.points.fold<double>(
      0,
      (current, point) => point.value > current ? point.value : current,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (component.title != null)
          Text(
            component.title!,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        if (component.subtitle != null) ...[
          const SizedBox(height: AppSpacing.small / 2),
          Text(
            component.subtitle!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.medium),
        ...component.points.map((point) {
          final widthFactor = maxValue <= 0
              ? 0.0
              : (point.value / maxValue).clamp(0.0, 1.0);
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.small),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(point.label)),
                    Text(point.value.toStringAsFixed(0)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: widthFactor,
                    minHeight: 8,
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

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({required this.component});

  final SmartWorkspaceComponent component;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(AppIcons.auto_awesome_outlined, color: scheme.primary),
        const SizedBox(height: AppSpacing.medium),
        if (component.title != null)
          Text(
            component.title!,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
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

class _ConfirmationPanel extends StatelessWidget {
  const _ConfirmationPanel({
    required this.component,
    required this.onPromptAction,
    required this.onWorkspaceAction,
  });

  final SmartWorkspaceComponent component;
  final ValueChanged<String> onPromptAction;
  final ValueChanged<SmartWorkspaceAction> onWorkspaceAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (component.title != null)
          Text(
            component.title!,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        if (component.subtitle != null) ...[
          const SizedBox(height: AppSpacing.small),
          Text(component.subtitle!),
        ],
        if (component.lines.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.medium),
          ...component.lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.small),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text(line.label)),
                  const SizedBox(width: AppSpacing.medium),
                  Flexible(
                    child: Text(
                      line.value,
                      textAlign: TextAlign.end,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (component.actions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.medium),
          _ActionButtonRow(
            component: SmartWorkspaceComponent(
              id: component.id,
              type: SmartWorkspaceComponentType.actionButtonRow,
              actions: component.actions,
            ),
            onPromptAction: onPromptAction,
            onWorkspaceAction: onWorkspaceAction,
          ),
        ],
      ],
    );
  }
}

String _formatDate(DateTime value) {
  final year = value.year.toString().padLeft(4, '0');
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
