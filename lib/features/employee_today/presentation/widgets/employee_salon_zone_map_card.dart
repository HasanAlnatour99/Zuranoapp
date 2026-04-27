import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../employee_dashboard/presentation/widgets/salon_zone_map_preview.dart';
import '../../../owner/settings/attendance/domain/models/attendance_settings_model.dart';
import '../../data/models/employee_workplace_location_snapshot.dart';
import '../employee_today_theme.dart';
import 'employee_today_widgets.dart';
import '../../../../shared/widgets/zurano_status_chip.dart';

/// Salon zone preview + salon details, distance, zone chip, and open-in-maps.
class EmployeeSalonZoneMapCard extends StatelessWidget {
  const EmployeeSalonZoneMapCard({
    super.key,
    required this.settings,
    required this.location,
    required this.salonDisplayName,
  });

  final AttendanceSettingsModel settings;
  final EmployeeWorkplaceLocationSnapshot location;
  final String salonDisplayName;

  static const double _mapHeight = 168;

  Future<void> _openMaps(double lat, double lng) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (!settings.hasSalonLocationConfigured) {
      return EtPremiumCard(
        child: Text(
          l10n.employeeTodaySalonLocationMissing,
          textAlign: TextAlign.start,
        ),
      );
    }

    final lat = settings.salonLatitude!;
    final lng = settings.salonLongitude!;
    final address = settings.salonAddress?.trim().isNotEmpty == true
        ? settings.salonAddress!.trim()
        : l10n.employeeTodayAddressOnFile;

    final distLabel = location.distanceMeters != null
        ? l10n.employeeTodayDistanceMeters(location.distanceMeters!.round())
        : l10n.employeeTodayDistanceUnknown;

    final inside = location.insideZone;
    final zoneLabel = inside == null
        ? l10n.employeeTodayLocationUnknown
        : inside
        ? l10n.employeeTodayZoneInside
        : l10n.employeeTodayZoneOutside;
    final zoneColor = inside == true
        ? EmployeeTodayColors.success
        : EmployeeTodayColors.amber;

    return EtPremiumCard(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            salonDisplayName,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 17,
              color: EmployeeTodayColors.deepText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            address,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: EmployeeTodayColors.mutedText,
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                distLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: EmployeeTodayColors.deepText,
                ),
              ),
              ZuranoStatusChip(
                icon: Icons.location_on_outlined,
                label: zoneLabel,
                color: zoneColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: _mapHeight,
              width: double.infinity,
              child: SalonZoneMapPreview(
                salonLat: lat,
                salonLng: lng,
                radiusMeters: settings.allowedRadiusMeters.toDouble(),
                employeeLat: location.employeeLatitude,
                employeeLng: location.employeeLongitude,
                height: _mapHeight,
              ),
            ),
          ),
          if (!kIsWeb) ...[
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: () => _openMaps(lat, lng),
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: Text(l10n.employeeMapOpenInMaps),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
