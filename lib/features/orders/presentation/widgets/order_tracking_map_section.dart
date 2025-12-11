import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingMapSection extends StatefulWidget {
  final double? vendorLat;
  final double? vendorLng;
  final String? vendorName;

  const OrderTrackingMapSection({
    super.key,
    this.vendorLat,
    this.vendorLng,
    this.vendorName,
  });

  @override
  State<OrderTrackingMapSection> createState() =>
      _OrderTrackingMapSectionState();
}

class _OrderTrackingMapSectionState extends State<OrderTrackingMapSection> {
  GoogleMapController? _mapController;
  late CameraPosition _initialPosition;
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      height: 350.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: GoogleMap(
          initialCameraPosition: _initialPosition,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            // If vendor location available, animate camera to it and add marker
            if (widget.vendorLat != null && widget.vendorLng != null) {
              final vendorPos = LatLng(widget.vendorLat!, widget.vendorLng!);
              controller.animateCamera(
                CameraUpdate.newLatLngZoom(vendorPos, 15),
              );
              setState(() {
                _markers.add(
                  Marker(
                    markerId: const MarkerId('vendor'),
                    position: vendorPos,
                    infoWindow: InfoWindow(
                      title: widget.vendorName ?? 'Vendor',
                    ),
                  ),
                );
              });
            }
          },
          zoomControlsEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
          markers: _markers,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.vendorLat != null && widget.vendorLng != null) {
      _initialPosition = CameraPosition(
        target: LatLng(widget.vendorLat!, widget.vendorLng!),
        zoom: 15,
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('vendor'),
          position: LatLng(widget.vendorLat!, widget.vendorLng!),
          infoWindow: InfoWindow(title: widget.vendorName ?? 'Vendor'),
        ),
      );
    } else {
      _initialPosition = const CameraPosition(
        target: LatLng(28.6139, 77.2090),
        zoom: 15,
      );
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
