import 'package:quikle_user/features/orders/data/models/order/order_model.dart';
import 'package:quikle_user/core/utils/constants/enums/order_enums.dart';

/// Represents a group of orders that share the same parent_order_id
class GroupedOrderModel {
  final String parentOrderId;
  final List<OrderModel> orders;
  final DateTime orderDate;

  const GroupedOrderModel({
    required this.parentOrderId,
    required this.orders,
    required this.orderDate,
  });

  /// Get the total amount across all orders in this group
  double get totalAmount {
    return orders.fold(0.0, (sum, order) => sum + order.total);
  }

  /// Get the total number of items across all orders
  int get totalItems {
    return orders.fold(0, (sum, order) => sum + order.items.length);
  }

  /// Get all items from all orders in this group
  List<dynamic> get allItems {
    return orders.expand((order) => order.items).toList();
  }

  /// Check if any order in the group can be cancelled
  bool get canBeCancelled {
    return orders.any((order) => order.canBeCancelled);
  }

  /// Check if any order in the group is trackable
  bool get isTrackable {
    return orders.any((order) => order.isTrackable);
  }

  /// Get the most recent status from all orders
  /// Priority: cancelled > refunded > delivered > outForDelivery > shipped > preparing > confirmed > processing > pending
  OrderStatus get groupStatus {
    if (orders.isEmpty) return OrderStatus.pending;

    // Check for critical statuses first
    if (orders.any((o) => o.status == OrderStatus.cancelled)) {
      return OrderStatus.cancelled;
    }
    if (orders.any((o) => o.status == OrderStatus.refunded)) {
      return OrderStatus.refunded;
    }
    if (orders.every((o) => o.status == OrderStatus.delivered)) {
      return OrderStatus.delivered;
    }
    if (orders.any((o) => o.status == OrderStatus.outForDelivery)) {
      return OrderStatus.outForDelivery;
    }
    if (orders.any((o) => o.status == OrderStatus.shipped)) {
      return OrderStatus.shipped;
    }
    if (orders.any((o) => o.status == OrderStatus.preparing)) {
      return OrderStatus.preparing;
    }
    if (orders.any((o) => o.status == OrderStatus.confirmed)) {
      return OrderStatus.confirmed;
    }
    if (orders.any((o) => o.status == OrderStatus.processing)) {
      return OrderStatus.processing;
    }

    return OrderStatus.pending;
  }

  /// Get the display name for the group status
  String get statusDisplayName {
    switch (groupStatus) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.refunded:
        return 'Refunded';
    }
  }

  /// Get shipping address (assumes all orders have the same address)
  String get shippingAddressText {
    if (orders.isEmpty) return '';
    final address = orders.first.shippingAddress;
    return '${address.address}, ${address.city}, ${address.state} ${address.zipCode}';
  }

  /// Get payment method (assumes all orders have the same payment method)
  String get paymentMethodText {
    if (orders.isEmpty) return '';
    return orders.first.paymentMethod.name;
  }
}
