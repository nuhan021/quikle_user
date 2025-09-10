import 'dart:async';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/enums/order_enums.dart';
import 'package:quikle_user/features/orders/data/models/order_model.dart';
import 'package:quikle_user/features/orders/data/services/order_tracking_service.dart';

class OrderTrackingController extends GetxController {
  final OrderTrackingService _trackingService = OrderTrackingService();

  // Reactive variables
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  final trackingData = Rx<Map<String, dynamic>?>(null);
  final deliverySteps = <Map<String, dynamic>>[].obs;
  final estimatedTime = ''.obs;
  final deliveryPersonLocation = Rx<Map<String, dynamic>?>(null);

  // Order reference
  OrderModel? _order;
  OrderModel get order => _order!;

  // Timer for real-time updates
  Timer? _locationTimer;

  @override
  void onInit() {
    super.onInit();
    // Initialize with order from arguments
    if (Get.arguments != null && Get.arguments is OrderModel) {
      _order = Get.arguments as OrderModel;
      loadTrackingData();
      _startLocationUpdates();
    }
  }

  @override
  void onClose() {
    _locationTimer?.cancel();
    super.onClose();
  }

  // Initialize with order (alternative method)
  void initializeWithOrder(OrderModel orderModel) {
    // Only initialize if not already set, to avoid hot reload issues
    if (_order == null) {
      _order = orderModel;
      loadTrackingData();
      _startLocationUpdates();
    }
  }

  // Load all tracking data
  Future<void> loadTrackingData() async {
    // Don't load if order is not initialized
    if (_order == null) return;

    try {
      isLoading.value = true;
      hasError.value = false;

      // Load tracking data in parallel
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

  // Refresh tracking data
  Future<void> refreshTrackingData() async {
    await loadTrackingData();
    Get.snackbar(
      'Updated',
      'Tracking data refreshed',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Load main tracking data
  Future<void> _loadOrderTrackingData() async {
    final data = await _trackingService.getOrderTrackingData(order.orderId);
    trackingData.value = data;
  }

  // Load delivery steps
  Future<void> _loadDeliverySteps() async {
    final steps = await _trackingService.getDeliverySteps(order);
    deliverySteps.value = steps;
  }

  // Load estimated delivery time
  Future<void> _loadEstimatedTime() async {
    final time = await _trackingService.getEstimatedDeliveryTime(order);
    estimatedTime.value = time;
  }

  // Start real-time location updates
  void _startLocationUpdates() {
    // Only track location for active deliveries
    if (_order != null && order.status == OrderStatus.outForDelivery) {
      _locationTimer = Timer.periodic(
        const Duration(seconds: 30),
        (_) => _updateDeliveryPersonLocation(),
      );
    }
  }

  // Update delivery person location
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

  // Get current progress percentage
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

  // Get status display text
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

  // Get primary order item name
  String get primaryItemName {
    if (_order == null) return 'Order Items';

    if (order.items.isNotEmpty) {
      return order.items.first.product.title;
    }
    return 'Order Items';
  }

  // Check if order is actively being delivered
  bool get isActiveDelivery {
    if (_order == null) return false;
    return order.status == OrderStatus.outForDelivery;
  }

  // Check if order can be tracked
  bool get isTrackable {
    if (_order == null) return false;

    return [
      OrderStatus.confirmed,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.outForDelivery,
    ].contains(order.status);
  }

  // Get next expected step
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

  // Contact delivery person
  void contactDeliveryPerson() {
    if (trackingData.value != null) {
      final deliveryPerson = trackingData.value!['deliveryPerson'];
      if (deliveryPerson != null) {
        Get.snackbar(
          'Calling',
          'Calling ${deliveryPerson['name']}...',
          snackPosition: SnackPosition.BOTTOM,
        );
        // Here you would integrate with phone calling functionality
      }
    }
  }

  // Share tracking info
  void shareTrackingInfo() {
    Get.snackbar(
      'Sharing',
      'Tracking info shared',
      snackPosition: SnackPosition.BOTTOM,
    );
    // Here you would integrate with sharing functionality
  }
}
