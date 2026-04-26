import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../logic/team_management_providers.dart';

class BarberBookingPrepTab extends StatelessWidget {
  const BarberBookingPrepTab({super.key, required this.data});

  final BarberDetailsData data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.large),
      children: [
        AppSurfaceCard(
          borderRadius: AppRadius.large,
          showShadow: false,
          outlineOpacity: 0.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BookingPrepRow(
                label: l10n.teamFieldBookable,
                value: data.employee.isBookable
                    ? l10n.teamValueEnabled
                    : l10n.teamValueDisabled,
              ),
              _BookingPrepRow(
                label: l10n.teamBookingPrepPublicDisplayName,
                value: data.employee.name,
              ),
              _BookingPrepRow(
                label: l10n.teamBookingPrepPublicBio,
                value: (data.employee.publicBio ?? '').trim().isEmpty
                    ? l10n.teamValueNotAvailable
                    : data.employee.publicBio!,
              ),
              _BookingPrepRow(
                label: l10n.teamBookingPrepWorkingHoursProfile,
                value:
                    data.employee.workingHoursProfileId ??
                    l10n.teamPlaceholderLaterReady,
              ),
              _BookingPrepRow(
                label: l10n.teamBookingPrepSlotDuration,
                value: l10n.teamPlaceholderLaterReady,
              ),
              _BookingPrepRow(
                label: l10n.teamBookingPrepDisplayOrder,
                value: '${data.employee.displayOrder}',
              ),
              _BookingPrepRow(
                label: l10n.teamBookingPrepProfileImage,
                value:
                    data.employee.avatarUrl ?? l10n.teamPlaceholderLaterReady,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        AppSurfaceCard(
          borderRadius: AppRadius.large,
          showShadow: false,
          outlineOpacity: 0.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.teamBookingPrepVisibleServicesTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.medium),
              if (data.visibleServices.isEmpty)
                Text(l10n.teamBookingPrepVisibleServicesEmpty)
              else
                for (
                  var index = 0;
                  index < data.visibleServices.length;
                  index++
                ) ...[
                  if (index > 0) const Divider(height: AppSpacing.large),
                  Text(data.visibleServices[index].serviceName),
                ],
            ],
          ),
        ),
      ],
    );
  }
}

class _BookingPrepRow extends StatelessWidget {
  const _BookingPrepRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.small),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
