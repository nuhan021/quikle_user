import 'package:quikle_user/core/utils/constants/enums/order_enums.dart';
import 'package:quikle_user/features/cart/data/models/cart_item_model.dart';
import 'package:quikle_user/features/payout/data/models/delivery_option_model.dart';
import 'package:quikle_user/features/payout/data/models/payment_method_model.dart';
import 'package:quikle_user/features/profile/data/models/shipping_address_model.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final List<CartItemModel> items;
  final ShippingAddressModel shippingAddress;
  final DeliveryOptionModel deliveryOption;
  final PaymentMethodModel paymentMethod;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String? couponCode;
  final double? discount;
  final DateTime orderDate;
  final OrderStatus status;
  final String? transactionId;
  final String? trackingNumber;
  final DateTime? estimatedDelivery;
  final Map<String, dynamic>? metadata;

  const OrderModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.shippingAddress,
    required this.deliveryOption,
    required this.paymentMethod,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    this.couponCode,
    this.discount,
    required this.orderDate,
    required this.status,
    this.transactionId,
    this.trackingNumber,
    this.estimatedDelivery,
    this.metadata,
  });

  OrderModel copyWith({
    String? orderId,
    String? userId,
    List<CartItemModel>? items,
    ShippingAddressModel? shippingAddress,
    DeliveryOptionModel? deliveryOption,
    PaymentMethodModel? paymentMethod,
    double? subtotal,
    double? deliveryFee,
    double? total,
    String? couponCode,
    double? discount,
    DateTime? orderDate,
    OrderStatus? status,
    String? transactionId,
    String? trackingNumber,
    DateTime? estimatedDelivery,
    Map<String, dynamic>? metadata,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      deliveryOption: deliveryOption ?? this.deliveryOption,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      couponCode: couponCode ?? this.couponCode,
      discount: discount ?? this.discount,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      transactionId: transactionId ?? this.transactionId,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get canBeCancelled {
    return status == OrderStatus.pending || status == OrderStatus.processing;
  }

  bool get isTrackable {
    return (status == OrderStatus.confirmed ||
        status == OrderStatus.shipped ||
        status == OrderStatus.outForDelivery);
  }

  String get statusDisplayName {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.confirmed:
        return 'Confirmed';
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

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'items': items
          .map(
            (item) => {
              'productId': item.product.id,
              'title': item.product.title,
              'price': item.product.price,
              'quantity': item.quantity,
              'imagePath': item.product.imagePath,
            },
          )
          .toList(),
      'shippingAddress': shippingAddress.toJson(),
      'deliveryOption': {
        'type': deliveryOption.type.name,
        'title': deliveryOption.title,
        'description': deliveryOption.description,
        'price': deliveryOption.price,
      },
      'paymentMethod': {
        'type': paymentMethod.type.name,
        'name': paymentMethod.name,
      },
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'couponCode': couponCode,
      'discount': discount,
      'orderDate': orderDate.toIso8601String(),
      'status': status.name,
      'transactionId': transactionId,
      'trackingNumber': trackingNumber,
      'estimatedDelivery': estimatedDelivery?.toIso8601String(),
      'metadata': metadata,
    };
  }
}
