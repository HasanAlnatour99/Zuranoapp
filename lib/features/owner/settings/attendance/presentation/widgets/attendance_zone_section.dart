import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../salon_settings/presentation/widgets/attendance_zone_map_picker.dart';
import '../../../../../settings/presentation/widgets/zurano/settings_section_card.dart';
import '../../../../../settings/presentation/widgets/zurano/zurano_switch.dart';
import '../../domain/models/attendance_settings_model.dart';

/// Section 1 — Attendance zone (map, radius, location-required).
class AttendanceZoneSection extends StatelessWidget {
  const AttendanceZoneSection({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  final AttendanceSettingsModel draft;
  final ValueChanged<AttendanceSettingsModel> onChanged;

  static const _radiusOptions = <int>[10, 20, 30, 50, 100];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final hasLocation = draft.latitude != null && draft.longitude != null;
    final radius = draft.allowedRadiusMeters;

    return SettingsSectionCard(
      icon: Icons.location_on_outlined,
      title: l10n.ownerAttendanceSectionZone,
      subtitle: l10n.salonAttendanceZoneSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AttendanceZoneMapPicker(
              latitude: draft.latitude ?? 0,
              longitude: draft.longitude ?? 0,
              radiusMeters: radius.toDouble(),
              onLocationChanged: (LatLng ll) => onChanged(
                draft.copyWith(latitude: ll.latitude, longitude: ll.longitude),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: ZuranoPremiumUiColors.lightSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ZuranoPremiumUiColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.my_location_rounded,
                  size: 18,
                  color: ZuranoPremiumUiColors.primaryPurple,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    hasLocation
                        ? l10n.salonAttendanceZoneCoordinates(
                            draft.latitude!.toStringAsFixed(5),
                            draft.longitude!.toStringAsFixed(5),
                          )
                        : l10n.ownerAttendanceZoneCoordinatesEmpty,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: ZuranoPremiumUiColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (hasLocation)
                  IconButton(
                    tooltip: MaterialLocalizations.of(context).copyButtonLabel,
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                          text:
                              '${draft.latitude!.toStringAsFixed(6)},${draft.longitude!.toStringAsFixed(6)}',
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    color: ZuranoPremiumUiColors.textSecondary,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.ownerAttendanceZoneRadiusLabel,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: ZuranoPremiumUiColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in _radiusOptions)
                _RadiusChoiceChip(
                  meters: option,
                  selected: radius == option,
                  onSelected: () =>
                      onChanged(draft.copyWith(allowedRadiusMeters: option)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _ZoneSwitchRow(
            label: l10n.ownerAttendanceZoneLocationRequired,
            subtitle: l10n.ownerAttendanceZoneLocationRequiredHint,
            value: draft.locationRequired,
            onChanged: (v) =>
                onChanged(draft.copyWith(locationRequired: v)),
          ),
        ],
      ),
    );
  }
}

class _RadiusChoiceChip extends StatelessWidget {
  const _RadiusChoiceChip({
    required this.meters,
    required this.selected,
    required this.onSelected,
  });

  final int meters;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: selected,
      onSelected: (_) => onSelected(),
      label: Text(
        AppLocalizations.of(context)!.salonAttendanceZoneMetersShort(meters),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: selected
              ? Colors.white
              : ZuranoPremiumUiColors.textPrimary,
        ),
      ),
      selectedColor: ZuranoPremiumUiColors.primaryPurple,
      backgroundColor: ZuranoPremiumUiColors.lightSurface,
      side: BorderSide(
        color: selected
            ? ZuranoPremiumUiColors.primaryPurple
            : ZuranoPremiumUiColors.border,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }
}

class _ZoneSwitchRow extends StatelessWidget {
  const _ZoneSwitchRow({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: ZuranoPremiumUiColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: ZuranoPremiumUiColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        ZuranoSwitch(value: value, onChanged: onChanged),
      ],
    );
  }
}
