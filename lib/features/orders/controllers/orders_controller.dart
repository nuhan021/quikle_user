import 'package:get/get.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';
import 'package:quikle_user/features/orders/data/models/order/grouped_order_model.dart';
import 'package:quikle_user/features/orders/data/services/order/order_service.dart';

class OrdersController extends GetxController {
  final OrderService _orderService = OrderService();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxList<GroupedOrderModel> groupedOrders = <GroupedOrderModel>[].obs;
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

      // Group orders by parent_order_id
      _groupOrders();
    } catch (e) {
      error.value = 'Failed to load orders: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Groups orders by parent_order_id
  void _groupOrders() {
    final Map<String, List<OrderModel>> grouped = {};

    for (final order in orders) {
      // Use parent_order_id if available, otherwise use the order's own orderId
      final groupKey = order.parentOrderId ?? order.orderId;

      if (!grouped.containsKey(groupKey)) {
        grouped[groupKey] = [];
      }
      grouped[groupKey]!.add(order);
    }

    // Convert map to list of GroupedOrderModel
    groupedOrders.value = grouped.entries.map((entry) {
      // Sort orders within group by orderDate
      final sortedOrders = entry.value
        ..sort((a, b) => a.orderDate.compareTo(b.orderDate));

      return GroupedOrderModel(
        parentOrderId: entry.key,
        orders: sortedOrders,
        orderDate: sortedOrders.first.orderDate,
      );
    }).toList();

    // Sort grouped orders by date (most recent first)
    groupedOrders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
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
