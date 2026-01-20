import 'dart:async';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/enums/order_enums.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';
import 'package:quikle_user/features/orders/data/services/order/order_service.dart';

class LiveOrderController extends GetxController {
  final OrderService _orderService = OrderService();

  final _currentLiveOrder = Rx<OrderModel?>(null);
  final _isLoading = false.obs;
  final _progressPercentage = 0.0.obs;

  OrderModel? get currentLiveOrder => _currentLiveOrder.value;
  bool get hasLiveOrder => _currentLiveOrder.value != null;
  bool get isLoading => _isLoading.value;
  double get progressPercentage => _progressPercentage.value;

  Timer? _liveOrderTimer;

  @override
  void onInit() {
    super.onInit();
    _startLiveOrderTracking();
  }

  @override
  void onClose() {
    _liveOrderTimer?.cancel();
    super.onClose();
  }

  void _startLiveOrderTracking() {
    _checkForLiveOrder();

    _liveOrderTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) => _checkForLiveOrder(),
    );
  }

  Future<void> _checkForLiveOrder() async {
    try {
      _isLoading.value = true;

      // Fetch orders from API (userId is handled by auth token)
      final orders = await _orderService.getUserOrders('');

      final liveOrder = _findLiveOrder(orders);

      if (liveOrder != null) {
        _currentLiveOrder.value = liveOrder;
        _updateProgress();
      } else {
        _currentLiveOrder.value = null;
        _progressPercentage.value = 0.0;
      }
    } catch (e) {
      print('Error checking for live order: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  OrderModel? _findLiveOrder(List<OrderModel> orders) {
    try {
      final trackableOrders = orders.where((order) {
        return [
          OrderStatus.confirmed,
          OrderStatus.preparing,
          OrderStatus.shipped,
          OrderStatus.outForDelivery,
        ].contains(order.status);
      }).toList();

      if (trackableOrders.isEmpty) return null;

      //Print all the trackable orders for debugging
      for (var order in trackableOrders) {
        AppLoggerHelper.debug(
          'Liver order found for all orders: ${order.orderId} with status ${order.status}',
        );
      }

      trackableOrders.sort((a, b) => b.orderDate.compareTo(a.orderDate));

      AppLoggerHelper.debug(
        'Live order found: ${trackableOrders.first.orderId} with status ${trackableOrders.first.status}',
      );

      return trackableOrders.first;
    } catch (e) {
      print('Error finding live order: $e');
      return null;
    }
  }

  void _updateProgress() {
    if (_currentLiveOrder.value == null) return;

    switch (_currentLiveOrder.value!.status) {
      case OrderStatus.confirmed:
        _progressPercentage.value = 0.2;
        break;
      case OrderStatus.processing:
        _progressPercentage.value = 0.3;
        break;
      case OrderStatus.preparing:
        _progressPercentage.value = 0.4;
        break;
      case OrderStatus.shipped:
        _progressPercentage.value = 0.6;
        break;
      case OrderStatus.outForDelivery:
        _progressPercentage.value = 0.8;
        break;
      case OrderStatus.delivered:
        _progressPercentage.value = 1.0;
        break;
      default:
        _progressPercentage.value = 0.0;
    }
  }

  String get statusText {
    if (_currentLiveOrder.value == null) return '';

    switch (_currentLiveOrder.value!.status) {
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.preparing:
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

  String get estimatedTime {
    if (_currentLiveOrder.value?.estimatedDelivery == null) return '';

    // If order is actually delivered, don't show time estimation
    if (_currentLiveOrder.value!.status == OrderStatus.delivered) {
      return 'Delivered';
    }

    final now = DateTime.now();
    final delivery = _currentLiveOrder.value!.estimatedDelivery!;
    final difference = delivery.difference(now);

    if (difference.inMinutes > 0) {
      return '${difference.inMinutes} mins';
    } else {
      // If time has passed but order is still in transit, show appropriate message
      return 'Arriving soon';
    }
  }

  String get primaryItemName {
    if (_currentLiveOrder.value?.items.isEmpty ?? true) {
      return 'Order Items';
    }

    return _currentLiveOrder.value!.items.first.product.title;
  }

  void navigateToTracking() {
    if (_currentLiveOrder.value != null) {
      Get.toNamed('/order-tracking', arguments: _currentLiveOrder.value!);
    }
  }

  Future<void> refreshLiveOrder() async {
    await _checkForLiveOrder();
  }

  void clearLiveOrder() {
    _currentLiveOrder.value = null;
    _progressPercentage.value = 0.0;
  }

  Future<void> addNewOrder(OrderModel order) async {
    // Since orders are now fetched from API, just refresh to get the latest
    await refreshLiveOrder();
  }
}
