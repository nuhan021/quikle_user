import 'package:get/get.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';
import 'package:quikle_user/features/orders/data/services/order/order_service.dart';

class OrdersController extends GetxController {
  final OrderService _orderService = OrderService();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Fetch orders from API (userId is handled by auth token)
      final List<OrderModel> fetchedOrders = await _orderService.getUserOrders(
        '',
      );
      orders.value = fetchedOrders;
    } catch (e) {
      error.value = 'Failed to load orders: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOrders() async {
    await loadOrders();
  }

  OrderModel? getOrderById(String orderId) {
    try {
      return orders.firstWhere((order) => order.orderId == orderId);
    } catch (e) {
      return null;
    }
  }

  Future<void> addOrder(OrderModel order) async {
    try {
      print(
        'OrdersController: Adding order ${order.orderId} with ${order.items.length} items',
      );

      // Add to service (for backwards compatibility)
      await _orderService.addOrder(order);

      // Refresh orders from API to get the latest
      await loadOrders();

      print(
        'OrdersController: Order added successfully. Total orders: ${orders.length}',
      );
    } catch (e) {
      print('OrdersController: Error adding order: $e');
      error.value = 'Failed to add order: ${e.toString()}';
      rethrow;
    }
  }
}
