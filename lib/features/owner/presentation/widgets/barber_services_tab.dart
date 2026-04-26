import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatting/app_money_format.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_modal_sheet.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/repository_providers.dart';
import '../../../../providers/salon_streams_provider.dart';
import '../../../services/data/models/service.dart';
import '../../logic/team_management_providers.dart';
import 'empty_state_action_card.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class BarberServicesTab extends ConsumerWidget {
  const BarberServicesTab({
    super.key,
    required this.data,
    required this.currencyCode,
  });

  final BarberDetailsData data;
  final String currencyCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final servicesAsync = ref.watch(servicesStreamProvider);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.large),
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: FilledButton.tonalIcon(
            onPressed: servicesAsync.hasValue
                ? () => _showAssignmentSheet(
                    context,
                    ref,
                    servicesAsync.requireValue,
                  )
                : null,
            icon: const Icon(AppIcons.tune_rounded),
            label: Text(l10n.teamServicesEditAssignmentsAction),
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        if (data.assignedServices.isEmpty)
          EmptyStateActionCard(
            title: l10n.teamServicesEmptyTitle,
            message: l10n.teamServicesEmptySubtitle,
          )
        else
          AppSurfaceCard(
            borderRadius: AppRadius.large,
            showShadow: false,
            outlineOpacity: 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.teamServicesAssignedTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.medium),
                for (
                  var index = 0;
                  index < data.assignedServices.length;
                  index++
                ) ...[
                  if (index > 0) const Divider(height: AppSpacing.large),
                  _ServiceRow(
                    service: data.assignedServices[index],
                    currencyCode: currencyCode,
                    locale: locale,
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _showAssignmentSheet(
    BuildContext context,
    WidgetRef ref,
    List<SalonService> services,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final selectedIds = data.employee.assignedServiceIds.toSet();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return AppRawBottomSheetFormBody(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.teamServicesEditAssignmentsAction,
                    style: Theme.of(sheetContext).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 320),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        for (final service in services)
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            value: selectedIds.contains(service.id),
                            onChanged: (selected) {
                              setSheetState(() {
                                if (selected ?? false) {
                                  selectedIds.add(service.id);
                                } else {
                                  selectedIds.remove(service.id);
                                }
                              });
                            },
                            title: Text(service.serviceName),
                            subtitle: Text(
                              service.isActive
                                  ? l10n.teamServicesServiceActive
                                  : l10n.teamServicesServiceInactive,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  FilledButton(
                    onPressed: () async {
                      final updated = data.employee.copyWith(
                        assignedServiceIds: selectedIds.toList(growable: false),
                      );
                      await ref
                          .read(employeeRepositoryProvider)
                          .updateEmployee(data.employee.salonId, updated);
                      if (sheetContext.mounted) {
                        Navigator.of(sheetContext).pop();
                      }
                    },
                    child: Text(l10n.teamSaveChangesAction),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.service,
    required this.currencyCode,
    required this.locale,
  });

  final SalonService service;
  final String currencyCode;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.serviceName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${l10n.bookingDurationMinutes(service.durationMinutes)} · ${formatAppMoney(service.price, currencyCode, locale)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        Text(
          service.isActive
              ? l10n.teamServicesServiceActive
              : l10n.teamServicesServiceInactive,
          style: theme.textTheme.labelSmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
