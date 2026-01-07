import 'package:flutter/material.dart';
import 'package:quikle_user/core/utils/constants/enums/order_enums.dart';

class OrderStatusHelpers {
  static Widget getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Image.asset(
          'assets/icons/pending.png',
          width: 20.0,
          height: 20.0,
        );
      case OrderStatus.processing:
        return Image.asset(
          'assets/icons/pending.png',
          width: 20.0,
          height: 20.0,
        );
      case OrderStatus.confirmed:
        return Image.asset(
          'assets/icons/ordered.png',
          width: 20.0,
          height: 20.0,
        );
      case OrderStatus.preparing:
        return Image.asset(
          'assets/icons/preparing.png',
          width: 20.0,
          height: 20.0,
        );
      case OrderStatus.shipped:
        return Image.asset(
          'assets/icons/shipped.png',
          width: 20.0,
          height: 20.0,
        );
      case OrderStatus.outForDelivery:
        return Image.asset(
          'assets/icons/out_for_delivery.png',
          width: 20.0,
          height: 20.0,
        );
      case OrderStatus.delivered:
        return Image.asset(
          'assets/icons/delivered.png',
          width: 20.0,
          height: 20.0,
        );
      case OrderStatus.cancelled:
        return Image.asset(
          'assets/icons/cancelled.png',
          width: 20.0,
          height: 20.0,
        );
      case OrderStatus.refunded:
        return Image.asset(
          'assets/icons/cancelled.png',
          width: 20.0,
          height: 20.0,
        );
    }
  }

  static Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFE6AF00);
      case OrderStatus.processing:
        return const Color(0xFFE6AF00);
      case OrderStatus.confirmed:
        return const Color(0xFF484848);
      case OrderStatus.preparing:
        return const Color(0xFFF57C00);
      case OrderStatus.shipped:
        return const Color(0xFF484848);
      case OrderStatus.outForDelivery:
        return const Color(0xFF484848);
      case OrderStatus.delivered:
        return const Color(0xFF06BC4C);
      case OrderStatus.cancelled:
        return const Color(0xFFFF0000);
      case OrderStatus.refunded:
        return Colors.orange;
    }
  }

  static String getStatusText(OrderStatus status) {
    switch (status) {
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
}
