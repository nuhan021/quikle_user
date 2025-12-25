import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quikle_user/features/orders/controllers/order_tracking_controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:quikle_user/features/profile/data/models/shipping_address_model.dart';

class OrderTrackingMapSection extends StatefulWidget {
  final double? vendorLat;
  final double? vendorLng;
  final String? vendorName;
  final ShippingAddressModel? shippingAddress;

  const OrderTrackingMapSection({
    super.key,
    this.vendorLat,
    this.vendorLng,
    this.shippingAddress,
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
  late BitmapDescriptor _vendorIcon;
  late BitmapDescriptor _customerIcon;
  late BitmapDescriptor _riderIcon;

  @override
  void initState() {
    super.initState();
    _setInitialPosition();
    _initializeDefaultMarkers();
    _initializeMarkers();
    _setupRiderLocationListener();
  }

  void _setupRiderLocationListener() {
    final controller = Get.find<OrderTrackingController>();
    ever(controller.riderLocation, (LatLng? newLocation) {
      if (newLocation != null && mounted) {
        _updateRiderMarker(newLocation);
      }
    });
  }

  void _setInitialPosition() {
    if (widget.vendorLat != null && widget.vendorLng != null) {
      _initialPosition = CameraPosition(
        target: LatLng(widget.vendorLat!, widget.vendorLng!),
        zoom: 14,
      );
    } else {
      _initialPosition = const CameraPosition(
        target: LatLng(28.6139, 77.2090),
        zoom: 14,
      );
    }
  }

  void _initializeDefaultMarkers() {
    _vendorIcon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueBlue,
    );
    _customerIcon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueGreen,
    );
    _riderIcon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueOrange,
    );
  }

  void _initializeMarkers() async {
    // Add vendor marker
    if (widget.vendorLat != null && widget.vendorLng != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('vendor'),
          position: LatLng(widget.vendorLat!, widget.vendorLng!),
          infoWindow: InfoWindow(
            title: widget.vendorName ?? 'Vendor',
            snippet: 'Restaurant Location',
          ),
          icon: _vendorIcon,
        ),
      );
    }

    // Add customer marker from order shipping address if provided,
    // otherwise fall back to device current location
    try {
      if (widget.shippingAddress != null) {
        final addr = widget.shippingAddress!.fullAddress;
        log('Attempting to geocode address: $addr');
        if (addr.isNotEmpty) {
          log('Geocoding address: $addr');
          final locations = await locationFromAddress(addr);
          log('Geocoded $addr to $locations');
          if (locations.isNotEmpty) {
            final loc = locations.first;
            if (mounted) {
              setState(() {
                _markers.add(
                  Marker(
                    markerId: const MarkerId('customer'),
                    position: LatLng(loc.latitude, loc.longitude),
                    infoWindow: InfoWindow(
                      title: widget.shippingAddress!.name.isNotEmpty
                          ? widget.shippingAddress!.name
                          : 'Delivery Address',
                      snippet: widget.shippingAddress!.fullAddress,
                    ),
                    icon: _customerIcon,
                  ),
                );
                // If initial position was the default, move camera to customer
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(loc.latitude, loc.longitude),
                    14,
                  ),
                );
              });
            }
            return;
          }
        }
      }

      // Fallback to device GPS
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever) {
        final position = await Geolocator.getCurrentPosition();
        if (mounted) {
          setState(() {
            _markers.add(
              Marker(
                markerId: const MarkerId('customer'),
                position: LatLng(position.latitude, position.longitude),
                infoWindow: const InfoWindow(
                  title: 'Your Location',
                  snippet: 'Delivery Address',
                ),
                icon: _customerIcon,
              ),
            );
          });
        }
      }
    } catch (e) {
      print('Could not get customer location: $e');
    }
  }

  void _updateRiderMarker(LatLng position) {
    setState(() {
      _markers.removeWhere((marker) => marker.markerId.value == 'rider');
      _markers.add(
        Marker(
          markerId: const MarkerId('rider'),
          position: position,
          infoWindow: const InfoWindow(
            title: 'Delivery Rider',
            snippet: 'On the way',
          ),
          icon: _riderIcon,
          rotation: 0,
        ),
      );
    });

    // Animate camera to show rider
    _mapController?.animateCamera(CameraUpdate.newLatLng(position));
  }

  Future<void> _goToMyLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Permission Denied',
            'Location permission is required to show your location',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition();
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          16,
        ),
      );
    } catch (e) {
      print('Error getting location: $e');
      Get.snackbar(
        'Error',
        'Failed to get your location',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderTrackingController>();

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
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: GoogleMap(
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              initialCameraPosition: _initialPosition,
              onMapCreated: (GoogleMapController mapController) {
                _mapController = mapController;
              },
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              markers: _markers,
            ),
          ),
          // Custom Zoom Controls
          Positioned(
            right: 16.w,
            top: 16.h,
            child: Column(
              children: [
                Material(
                  color: Colors.white,
                  elevation: 4,
                  borderRadius: BorderRadius.circular(4.r),
                  child: InkWell(
                    onTap: () {
                      _mapController?.animateCamera(CameraUpdate.zoomIn());
                    },
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      alignment: Alignment.center,
                      child: Icon(Icons.add, size: 20.sp),
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Material(
                  color: Colors.white,
                  elevation: 4,
                  borderRadius: BorderRadius.circular(4.r),
                  child: InkWell(
                    onTap: () {
                      _mapController?.animateCamera(CameraUpdate.zoomOut());
                    },
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      alignment: Alignment.center,
                      child: Icon(Icons.remove, size: 20.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // My Location Button
          Positioned(
            right: 16.w,
            bottom: 16.h,
            child: Material(
              color: Colors.white,
              elevation: 4,
              borderRadius: BorderRadius.circular(4.r),
              child: InkWell(
                onTap: _goToMyLocation,
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.my_location,
                    size: 20.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          // WebSocket Connection Status Indicator
          Positioned(
            left: 16.w,
            top: 16.h,
            child: Obx(() {
              if (!controller.isWebSocketConnected.value) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_off, size: 12.sp, color: Colors.white),
                      SizedBox(width: 4.w),
                      Text(
                        'Reconnecting...',
                        style: TextStyle(color: Colors.white, fontSize: 10.sp),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
