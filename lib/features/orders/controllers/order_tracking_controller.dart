import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/utils/constants/enums/order_enums.dart';
import 'package:quikle_user/features/orders/data/models/order_model.dart';
import 'package:quikle_user/features/orders/data/services/order_tracking_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class OrderTrackingController extends GetxController {
  final OrderTrackingService _trackingService = OrderTrackingService();

  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  final trackingData = Rx<Map<String, dynamic>?>(null);
  final deliverySteps = <Map<String, dynamic>>[].obs;
  final estimatedTime = ''.obs;
  final deliveryPersonLocation = Rx<Map<String, dynamic>?>(null);

  // WebSocket for real-time rider location
  WebSocketChannel? _locationChannel;
  final riderLocation = Rx<LatLng?>(null);
  final isWebSocketConnected = false.obs;

  OrderModel? _order;
  OrderModel get order => _order!;

  Timer? _locationTimer;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is OrderModel) {
      _order = Get.arguments as OrderModel;
      loadTrackingData();
      _startLocationUpdates();
      _connectToWebSocket();
    }
  }

  @override
  void onClose() {
    _locationTimer?.cancel();
    _disconnectWebSocket();
    super.onClose();
  }

  void initializeWithOrder(OrderModel orderModel) {
    if (_order == null) {
      _order = orderModel;
      loadTrackingData();
      _startLocationUpdates();
      _connectToWebSocket();
    }
  }

  Future<void> loadTrackingData() async {
    if (_order == null) return;

    try {
      isLoading.value = true;
      hasError.value = false;

      await Future.wait([
        _loadOrderTrackingData(),
        _loadDeliverySteps(),
        _loadEstimatedTime(),
      ]);

      isLoading.value = false;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load tracking data';
      isLoading.value = false;
    }
  }

  Future<void> refreshTrackingData() async {
    await loadTrackingData();
    // Get.snackbar(
    //   'Updated',
    //   'Tracking data refreshed',
    //   snackPosition: SnackPosition.BOTTOM,
    //   duration: const Duration(seconds: 2),
    // );
  }

  Future<void> _loadOrderTrackingData() async {
    final data = await _trackingService.getOrderTrackingData(order.orderId);
    trackingData.value = data;
  }

  Future<void> _loadDeliverySteps() async {
    final steps = await _trackingService.getDeliverySteps(order);
    deliverySteps.value = steps;
  }

  Future<void> _loadEstimatedTime() async {
    final time = await _trackingService.getEstimatedDeliveryTime(order);
    estimatedTime.value = time;
  }

  void _startLocationUpdates() {
    if (_order != null && order.status == OrderStatus.outForDelivery) {
      _locationTimer = Timer.periodic(
        const Duration(seconds: 30),
        (_) => _updateDeliveryPersonLocation(),
      );
    }
  }

  Future<void> _updateDeliveryPersonLocation() async {
    try {
      final location = await _trackingService.getDeliveryPersonLocation(
        order.orderId,
      );
      if (location != null) {
        deliveryPersonLocation.value = location;
      }
    } catch (e) {
      print('Failed to update delivery person location: $e');
    }
  }

  double get progressPercentage {
    if (_order == null) return 0.0;

    switch (order.status) {
      case OrderStatus.confirmed:
        return 0.2;
      case OrderStatus.processing:
        return 0.4;
      case OrderStatus.shipped:
        return 0.6;
      case OrderStatus.outForDelivery:
        return 0.8;
      case OrderStatus.delivered:
        return 1.0;
      default:
        return 0.0;
    }
  }

  String get statusText {
    if (_order == null) return 'Processing';

    switch (order.status) {
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.processing:
        return 'Preparing';
      case OrderStatus.shipped:
        return 'Ready for Pickup';
      case OrderStatus.outForDelivery:
        return 'On the Way';
      case OrderStatus.delivered:
        return 'Delivered';
      default:
        return 'Processing';
    }
  }

  String get primaryItemName {
    if (_order == null) return 'Order Items';

    if (order.items.isNotEmpty) {
      return order.items.first.product.title;
    }
    return 'Order Items';
  }

  bool get isActiveDelivery {
    if (_order == null) return false;
    return order.status == OrderStatus.outForDelivery;
  }

  bool get isTrackable {
    if (_order == null) return false;

    return [
      OrderStatus.confirmed,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.outForDelivery,
    ].contains(order.status);
  }

  String? get nextStepTitle {
    if (_order == null) return null;

    final currentIndex = order.status.index;
    final nextStatuses = [
      OrderStatus.confirmed,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];

    for (final status in nextStatuses) {
      if (status.index > currentIndex) {
        switch (status) {
          case OrderStatus.processing:
            return 'Preparing';
          case OrderStatus.shipped:
            return 'Ready for Pickup';
          case OrderStatus.outForDelivery:
            return 'Out for Delivery';
          case OrderStatus.delivered:
            return 'Delivered';
          default:
            return null;
        }
      }
    }
    return null;
  }

  void contactDeliveryPerson([String? phoneNumber]) {
    final phone =
        phoneNumber ?? trackingData.value?['deliveryPerson']?['phone'];
    if (phone != null) {
      Get.snackbar(
        'Calling',
        'Calling delivery person...',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Here you would implement the actual calling functionality
      // For example: url_launcher to call the phone number
    } else {
      Get.snackbar(
        'Error',
        'Phone number not available',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void shareTrackingInfo() {
    Get.snackbar(
      'Sharing',
      'Tracking info shared',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // WebSocket Methods
  void _connectToWebSocket() {
    try {
      final customerId = StorageService.userId;
      if (customerId == null) {
        print('⚠️ Cannot connect to WebSocket: Customer ID is null');
        return;
      }

      final wsUrl =
          'wss://quikle-u4dv.onrender.com/rider/ws/location/customers/$customerId';
      print('🔌 Connecting to WebSocket: $wsUrl');

      _locationChannel = WebSocketChannel.connect(Uri.parse(wsUrl));
      isWebSocketConnected.value = true;

      _locationChannel!.stream.listen(
        (dynamic message) {
          try {
            final data = jsonDecode(message as String) as Map<String, dynamic>;
            print('📍 Received location update: $data');

            if (data['type'] == 'location_send') {
              final lat = (data['latitude'] as num).toDouble();
              final lng = (data['longitude'] as num).toDouble();

              riderLocation.value = LatLng(lat, lng);
              print('✅ Rider location updated: $lat, $lng');
            }
          } catch (e) {
            print('❌ Error parsing WebSocket message: $e');
          }
        },
        onError: (error) {
          print('❌ WebSocket error: $error');
          isWebSocketConnected.value = false;
          _reconnectWebSocket();
        },
        onDone: () {
          print('🔌 WebSocket connection closed');
          isWebSocketConnected.value = false;
          _reconnectWebSocket();
        },
      );

      print('✅ WebSocket connected successfully');
    } catch (e) {
      print('❌ Error connecting to WebSocket: $e');
      isWebSocketConnected.value = false;
    }
  }

  void _disconnectWebSocket() {
    _locationChannel?.sink.close();
    _locationChannel = null;
    isWebSocketConnected.value = false;
    print('🔌 WebSocket disconnected');
  }

  void _reconnectWebSocket() {
    if (_order != null && isActiveDelivery) {
      Future.delayed(const Duration(seconds: 5), () {
        if (!isWebSocketConnected.value) {
          print('🔄 Attempting to reconnect WebSocket...');
          _connectToWebSocket();
        }
      });
    }
  }
}
