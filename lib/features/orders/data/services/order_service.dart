import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/orders/data/models/order_model.dart';
import 'package:quikle_user/features/orders/data/services/order_api_service.dart';

class OrderService {
  final OrderApiService _apiService = OrderApiService();

  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      AppLoggerHelper.debug('Fetching orders from API for user: $userId');

      final orders = await _apiService.getOrders(skip: 0, limit: 50);

      return orders;
    } catch (e) {
      AppLoggerHelper.error('❌ Error fetching orders', e);
      throw Exception('Failed to fetch orders: $e');
    }
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final orders = await getUserOrders('');
      return orders.firstWhere((order) => order.orderId == orderId);
    } catch (e) {
      AppLoggerHelper.error('❌ Error fetching order by ID', e);
      return null;
    }
  }

  Future<void> addOrder(OrderModel order) async {
    // Order creation is now handled by OrderApiService.createOrder
    // This method is kept for backwards compatibility
    AppLoggerHelper.debug('Order ${order.orderId} added via API');
  }
}
