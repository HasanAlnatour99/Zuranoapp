import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../employee_dashboard/presentation/widgets/salon_zone_map_preview.dart';
import '../../../employee_today/data/models/et_attendance_settings.dart';
import '../../../employee_today/presentation/employee_today_theme.dart';
import '../providers/employee_attendance_providers.dart';
import 'employee_attendance_shell.dart';

class EmployeeSalonLocationCard extends StatelessWidget {
  const EmployeeSalonLocationCard({
    super.key,
    required this.settings,
    required this.salonName,
    required this.locationAsync,
    required this.insideZone,
    required this.distanceMeters,
    required this.onRetryLocation,
  });

  final EtAttendanceSettings settings;
  final String salonName;
  final AsyncValue<EmployeeAttendanceLocationSnapshot> locationAsync;
  final bool? insideZone;
  final double? distanceMeters;
  final VoidCallback onRetryLocation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final configured = settings.hasSalonLocationConfigured;
    final lat = settings.salonLatitude ?? 0;
    final lng = settings.salonLongitude ?? 0;

    return Container(
      decoration: zuranoAttendanceCardDecoration(),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: EmployeeTodayColors.primaryPurple,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.employeeAttendanceSalonLocationTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: EmployeeTodayColors.deepText,
                  ),
                ),
              ),
              if (configured && insideZone != null)
                _RangeChip(l10n: l10n, inside: insideZone!)
              else if (configured)
                _MiniChip(
                  label: l10n.employeeAttendanceLocating,
                  color: EmployeeTodayColors.mutedText,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            salonName,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            settings.salonAddress?.trim().isNotEmpty == true
                ? settings.salonAddress!.trim()
                : l10n.employeeTodayAddressOnFile,
            style: const TextStyle(
              color: EmployeeTodayColors.mutedText,
              fontSize: 13,
            ),
          ),
          if (distanceMeters != null) ...[
            const SizedBox(height: 6),
            Text(
              l10n.employeeTodayDistanceMeters(distanceMeters!.round()),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: EmployeeTodayColors.deepText,
              ),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            l10n.salonAttendanceZonePunchRadiusMeters(
              settings.allowedRadiusMeters.round(),
            ),
            style: const TextStyle(
              color: EmployeeTodayColors.primaryPurple,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          locationAsync.when(
            data: (snap) => Row(
              children: [
                const Icon(
                  Icons.satellite_alt_rounded,
                  size: 16,
                  color: EmployeeTodayColors.mutedText,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.employeeAttendanceGpsAccuracy(snap.accuracyLabel),
                  style: const TextStyle(
                    fontSize: 12,
                    color: EmployeeTodayColors.mutedText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 14),
          if (!configured)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: EmployeeTodayColors.backgroundSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                l10n.employeeAttendanceSalonLocationOwnerNote,
                style: const TextStyle(color: EmployeeTodayColors.mutedText),
              ),
            )
          else
            locationAsync.when(
              data: (snap) {
                if (snap.permissionDenied) {
                  return SalonZoneMapPreview(
                    salonLat: lat,
                    salonLng: lng,
                    radiusMeters: settings.allowedRadiusMeters.toDouble(),
                    height: 248,
                    staticMessage: l10n.employeeMapLocationPermissionRequired,
                  );
                }
                if (snap.errorLabel != null && snap.position == null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        snap.errorLabel!,
                        style: const TextStyle(
                          color: EmployeeTodayColors.mutedText,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: onRetryLocation,
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(l10n.employeeAttendanceRetryLocation),
                      ),
                    ],
                  );
                }
                return SalonZoneMapPreview(
                  salonLat: lat,
                  salonLng: lng,
                  radiusMeters: settings.allowedRadiusMeters.toDouble(),
                  employeeLat: snap.latLng?.latitude,
                  employeeLng: snap.latLng?.longitude,
                  height: 248,
                );
              },
              loading: () => const _MapSkeleton(height: 248),
              error: (_, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.employeeMapUnavailableBody,
                    style: const TextStyle(
                      color: EmployeeTodayColors.mutedText,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: onRetryLocation,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l10n.employeeAttendanceRetryLocation),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RangeChip extends StatelessWidget {
  const _RangeChip({required this.l10n, required this.inside});

  final AppLocalizations l10n;
  final bool inside;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color:
            (inside ? EmployeeTodayColors.success : EmployeeTodayColors.amber)
                .withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            inside ? Icons.check_circle_outline : Icons.warning_amber_rounded,
            size: 16,
            color: inside
                ? EmployeeTodayColors.success
                : EmployeeTodayColors.amber,
          ),
          const SizedBox(width: 6),
          Text(
            inside
                ? l10n.employeeAttendanceWithinRange
                : l10n.employeeAttendanceOutsideRange,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: inside
                  ? EmployeeTodayColors.success
                  : EmployeeTodayColors.amber,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: color,
        ),
      ),
    );
  }
}

class _MapSkeleton extends StatelessWidget {
  const _MapSkeleton({this.height = 168});

  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: ColoredBox(
          color: EmployeeTodayColors.cardBorder.withValues(alpha: 0.5),
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      ),
    );
  }
}
