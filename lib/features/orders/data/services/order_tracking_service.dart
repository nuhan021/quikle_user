import '../models/order_model.dart';
import '../../../../core/utils/constants/enums/order_enums.dart';

class OrderTrackingService {
  Future<Map<String, dynamic>> getOrderTrackingData(String orderId) async {
    return {
      'currentLocation': {
        'lat': 23.8103,
        'lng': 90.4125,
        'address': 'Gulshan 2, Dhaka',
      },
      'deliveryPerson': {
        'name': 'Ahmed Rahman',
        'phone': '+880123456789',
        'vehicle': 'Motorcycle',
        'rating': 4.8,
      },
      'estimatedArrival': DateTime.now().add(const Duration(minutes: 15)),
      'distanceRemaining': '2.3 km',
      'timeRemaining': '15 mins',
      'trackingSteps': _getTrackingSteps(),
    };
  }

  Future<List<Map<String, dynamic>>> getDeliverySteps(OrderModel order) async {
    final now = DateTime.now();
    final orderTime = order.orderDate;

    return [
      {
        'status': OrderStatus.confirmed,
        'title': 'Order Placed',
        'description': 'Your order has been confirmed',
        'time': orderTime,
        'isCompleted': _isStepCompleted(OrderStatus.confirmed, order.status),
        'isCurrent': _isCurrentStep(OrderStatus.confirmed, order.status),
      },
      {
        'status': OrderStatus.processing,
        'title': 'Preparing',
        'description': 'Restaurant is preparing your order',
        'time': order.status.index >= OrderStatus.processing.index
            ? orderTime.add(const Duration(minutes: 10))
            : null,
        'isCompleted': _isStepCompleted(OrderStatus.processing, order.status),
        'isCurrent': _isCurrentStep(OrderStatus.processing, order.status),
      },
      {
        'status': OrderStatus.shipped,
        'title': 'Order Ready',
        'description': 'Order is ready for pickup',
        'time': order.status.index >= OrderStatus.shipped.index
            ? orderTime.add(const Duration(minutes: 20))
            : null,
        'isCompleted': _isStepCompleted(OrderStatus.shipped, order.status),
        'isCurrent': _isCurrentStep(OrderStatus.shipped, order.status),
      },
      {
        'status': OrderStatus.outForDelivery,
        'title': 'Out for Delivery',
        'description': 'Delivery person is on the way',
        'time': order.status.index >= OrderStatus.outForDelivery.index
            ? orderTime.add(const Duration(minutes: 25))
            : null,
        'isCompleted': _isStepCompleted(
          OrderStatus.outForDelivery,
          order.status,
        ),
        'isCurrent': _isCurrentStep(OrderStatus.outForDelivery, order.status),
      },
      {
        'status': OrderStatus.delivered,
        'title': 'Delivered',
        'description': 'Order has been delivered successfully',
        'time': order.status == OrderStatus.delivered
            ? order.estimatedDelivery ?? now
            : null,
        'isCompleted': _isStepCompleted(OrderStatus.delivered, order.status),
        'isCurrent': _isCurrentStep(OrderStatus.delivered, order.status),
      },
    ];
  }

  Future<Map<String, dynamic>?> getDeliveryPersonLocation(
    String orderId,
  ) async {
    return {
      'lat': 23.8103 + (DateTime.now().millisecond % 100) * 0.001,
      'lng': 90.4125 + (DateTime.now().millisecond % 100) * 0.001,
      'heading': 45.0,
      'speed': 25.0, // km/h
      'lastUpdated': DateTime.now(),
    };
  }

  Future<String> getEstimatedDeliveryTime(OrderModel order) async {
    if (order.estimatedDelivery != null) {
      final now = DateTime.now();
      final difference = order.estimatedDelivery!.difference(now);

      if (difference.inMinutes > 0) {
        return '${difference.inMinutes} mins';
      } else if (difference.inMinutes > -30) {
        return 'Arriving soon';
      } else {
        return 'Delivered';
      }
    }

    switch (order.status) {
      case OrderStatus.confirmed:
      case OrderStatus.processing:
        return '25-30 mins';
      case OrderStatus.shipped:
        return '15-20 mins';
      case OrderStatus.outForDelivery:
        return '5-10 mins';
      case OrderStatus.delivered:
        return 'Delivered';
      default:
        return '30-35 mins';
    }
  }

  List<Map<String, dynamic>> _getTrackingSteps() {
    return [
      {
        'title': 'Order Confirmed',
        'time': DateTime.now().subtract(const Duration(minutes: 25)),
        'completed': true,
      },
      {
        'title': 'Preparing Food',
        'time': DateTime.now().subtract(const Duration(minutes: 20)),
        'completed': true,
      },
      {
        'title': 'Out for Delivery',
        'time': DateTime.now().subtract(const Duration(minutes: 10)),
        'completed': true,
      },
      {
        'title': 'Delivered',
        'time': DateTime.now().add(const Duration(minutes: 15)),
        'completed': false,
      },
    ];
  }

  bool _isStepCompleted(OrderStatus stepStatus, OrderStatus currentStatus) {
    return currentStatus.index > stepStatus.index;
  }

  bool _isCurrentStep(OrderStatus stepStatus, OrderStatus currentStatus) {
    switch (currentStatus) {
      case OrderStatus.confirmed:
        return stepStatus == OrderStatus.confirmed;
      case OrderStatus.processing:
        return stepStatus == OrderStatus.processing;
      case OrderStatus.shipped:
        return stepStatus == OrderStatus.shipped;
      case OrderStatus.outForDelivery:
        return stepStatus == OrderStatus.outForDelivery;
      case OrderStatus.delivered:
        return stepStatus == OrderStatus.delivered;
      default:
        return false;
    }
  }
}
