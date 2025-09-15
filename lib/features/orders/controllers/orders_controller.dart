import 'package:get/get.dart';
import '../data/models/order_model.dart';
import '../data/services/order_service.dart';

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

      
      const String userId = 'user123';

      final List<OrderModel> fetchedOrders = await _orderService.getUserOrders(
        userId,
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
}
