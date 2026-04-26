import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

/// Compact salon zone preview for employee surfaces. Fixed height; clipped; no overflow.
class SalonZoneMapPreview extends StatelessWidget {
  const SalonZoneMapPreview({
    super.key,
    required this.salonLat,
    required this.salonLng,
    required this.radiusMeters,
    this.employeeLat,
    this.employeeLng,
    this.height = 168,
    this.staticMessage,
  });

  final double salonLat;
  final double salonLng;
  final double radiusMeters;
  final double? employeeLat;
  final double? employeeLng;

  /// Today ~168; attendance full card ~248.
  final double height;

  /// When set (e.g. permission / map init failure), shows a non-blank card instead of [GoogleMap].
  final String? staticMessage;

  bool get _zoneConfigured {
    if (salonLat == 0 && salonLng == 0) {
      return false;
    }
    return radiusMeters >= 10 && radiusMeters <= 500;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (staticMessage != null) {
      return _StaticMapCard(height: height, message: staticMessage!);
    }

    if (kIsWeb) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: ColoredBox(
            color: ZuranoPremiumUiColors.softPurple,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  l10n.employeeMapPreviewMobileOnly,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ZuranoPremiumUiColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (!_zoneConfigured) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: ColoredBox(
            color: ZuranoPremiumUiColors.softPurple,
            child: Center(
              child: Text(
                l10n.employeeMapZoneNotConfigured,
                style: TextStyle(
                  color: ZuranoPremiumUiColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      );
    }

    final salonPosition = LatLng(salonLat, salonLng);
    final employeePosition = employeeLat != null && employeeLng != null
        ? LatLng(employeeLat!, employeeLng!)
        : null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: GoogleMap(
          key: ValueKey<String>('z_${salonLat}_${salonLng}_$radiusMeters'),
          initialCameraPosition: CameraPosition(
            target: salonPosition,
            zoom: 17,
          ),
          liteModeEnabled: !kIsWeb && Platform.isAndroid,
          markers: {
            Marker(
              markerId: const MarkerId('salon'),
              position: salonPosition,
              infoWindow: InfoWindow(title: l10n.employeeMapMarkerSalonZone),
            ),
            if (employeePosition != null)
              Marker(
                markerId: const MarkerId('employee'),
                position: employeePosition,
                infoWindow: InfoWindow(title: l10n.employeeMapMarkerYourLocation),
              ),
          },
          circles: {
            Circle(
              circleId: const CircleId('attendance_zone'),
              center: salonPosition,
              radius: radiusMeters,
              strokeWidth: 2,
              strokeColor: const Color(0xFF7C3AED),
              fillColor: const Color(0x337C3AED),
            ),
          },
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ),
      ),
    );
  }
}

class _StaticMapCard extends StatelessWidget {
  const _StaticMapCard({required this.height, required this.message});

  final double height;
  final String message;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: ColoredBox(
          color: ZuranoPremiumUiColors.softPurple,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map_outlined,
                  size: 36,
                  color: ZuranoPremiumUiColors.primaryPurple.withValues(
                    alpha: 0.65,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ZuranoPremiumUiColors.textSecondary,
                    fontSize: 13,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
