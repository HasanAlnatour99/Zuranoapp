import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Temporary screen to verify Google Maps + API keys (see `/debug/maps`).
class GoogleMapsTestScreen extends StatefulWidget {
  const GoogleMapsTestScreen({super.key});

  @override
  State<GoogleMapsTestScreen> createState() => _GoogleMapsTestScreenState();
}

class _GoogleMapsTestScreenState extends State<GoogleMapsTestScreen> {
  static const _defaultCenter = LatLng(25.2854, 51.5310);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug: Maps')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: _defaultCenter,
          zoom: 14,
        ),
        markers: {
          const Marker(
            markerId: MarkerId('debug'),
            position: _defaultCenter,
            infoWindow: InfoWindow(title: 'Test marker'),
          ),
        },
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
      ),
    );
  }
}
