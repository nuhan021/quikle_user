import 'dart:async';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/enums/order_enums.dart';
import 'package:quikle_user/features/orders/data/models/order_model.dart';
import 'package:quikle_user/features/orders/data/services/order_service.dart';

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

      
      final orders = await _orderService.getUserOrders('user123');

      
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
          OrderStatus.processing,
          OrderStatus.shipped,
          OrderStatus.outForDelivery,
        ].contains(order.status);
      }).toList();

      if (trackableOrders.isEmpty) return null;

      
      trackableOrders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
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

    final now = DateTime.now();
    final delivery = _currentLiveOrder.value!.estimatedDelivery!;
    final difference = delivery.difference(now);

    if (difference.inMinutes > 0) {
      return '${difference.inMinutes} mins';
    } else if (difference.inMinutes > -30) {
      return 'Arriving soon';
    } else {
      return 'Delivered';
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
    
    final isTrackable = [
      OrderStatus.confirmed,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.outForDelivery,
    ].contains(order.status);

    if (isTrackable) {
      if (_currentLiveOrder.value == null ||
          order.orderDate.isAfter(_currentLiveOrder.value!.orderDate)) {
        _currentLiveOrder.value = order;
        _updateProgress();
      }
    }
  }
}
