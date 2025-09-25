import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class OrderTrackingMapSection extends StatefulWidget {
  const OrderTrackingMapSection({super.key});

  @override
  State<OrderTrackingMapSection> createState() =>
      _OrderTrackingMapSectionState();
}

class _OrderTrackingMapSectionState extends State<OrderTrackingMapSection> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  final double _zoom = 15.0;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      height: 250.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target:
                _currentPosition ??
                const LatLng(23.8103, 90.4125), // fallback: Dhaka
            zoom: _zoom,
          ),
          onMapCreated: (controller) {
            _mapController = controller;
            if (_currentPosition != null) {
              _mapController?.animateCamera(
                CameraUpdate.newLatLng(_currentPosition!),
              );
            }
          },
          myLocationEnabled: true, // shows blue dot
          myLocationButtonEnabled: true, // default Google location button
          zoomControlsEnabled: false, // remove extra +/- buttons
          compassEnabled: true, // compass when rotated
          scrollGesturesEnabled: true, // allow drag
          zoomGesturesEnabled: true, // allow pinch zoom
          rotateGesturesEnabled: true, // allow rotation
          tiltGesturesEnabled: true, // allow tilt
        ),
      ),
    );
  }
}
