import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class AttendanceZoneMapPicker extends StatelessWidget {
  const AttendanceZoneMapPicker({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    required this.onLocationChanged,
  });

  final double latitude;
  final double longitude;
  final double radiusMeters;
  final ValueChanged<LatLng> onLocationChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (kIsWeb) {
      return Container(
        height: 220,
        alignment: Alignment.center,
        color: ZuranoPremiumUiColors.softPurple,
        child: Text(l10n.salonAttendanceZoneMapWebHint),
      );
    }

    final center = LatLng(latitude, longitude);

    return SizedBox(
      height: 220,
      child: GoogleMap(
        key: ObjectKey(center),
        // Lets the map receive pans/zooms inside a parent [ScrollView].
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
        },
        initialCameraPosition: CameraPosition(target: center, zoom: 17),
        markers: {
          Marker(
            markerId: const MarkerId('zone'),
            position: center,
            infoWindow: InfoWindow(
              title: l10n.salonAttendanceZoneMapCenterMarker,
            ),
          ),
        },
        circles: {
          Circle(
            circleId: const CircleId('attendance_zone'),
            center: center,
            radius: radiusMeters,
            strokeWidth: 2,
            strokeColor: const Color(0xFF7C3AED),
            fillColor: const Color(0x337C3AED),
          ),
        },
        onTap: onLocationChanged,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
      ),
    );
  }
}
