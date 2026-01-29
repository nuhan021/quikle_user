import 'package:quikle_user/core/utils/constants/enums/order_enums.dart';
import 'package:quikle_user/core/utils/constants/enums/delivery_enums.dart';
import 'package:quikle_user/core/utils/constants/enums/payment_enums.dart';
import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';
import 'package:quikle_user/features/cart/data/models/cart_item_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/payout/data/models/delivery_option_model.dart';
import 'package:quikle_user/features/payout/data/models/payment_method_model.dart';
import 'package:quikle_user/features/profile/address/data/models/shipping_address_model.dart';
import 'package:quikle_user/features/orders/data/models/order/rider_info_model.dart';
import 'package:quikle_user/features/orders/data/models/order/vendor_info_model.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final String? parentOrderId; // Group orders by this ID
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
  final String? paymentStatus;
  final String? paymentLink;
  final List<Map<String, dynamic>>? vendors;
  final VendorInfo? vendorInfo;
  final RiderInfo? riderInfo;

  // Refund-related fields (optional, populated when applicable)
  final String? cancellationReason;
  final double? refundAmount;
  final String? refundStatus; // Store as string for API flexibility
  final String? refundReference; // RRN or transaction ID
  final DateTime? refundInitiatedAt;
  final DateTime? refundCompletedAt;

  const OrderModel({
    required this.orderId,
    required this.userId,
    this.parentOrderId,
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
    this.paymentStatus,
    this.paymentLink,
    this.vendors,
    this.vendorInfo,
    this.riderInfo,
    this.cancellationReason,
    this.refundAmount,
    this.refundStatus,
    this.refundReference,
    this.refundInitiatedAt,
    this.refundCompletedAt,
  });

  OrderModel copyWith({
    String? orderId,
    String? userId,
    String? parentOrderId,
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
    String? paymentStatus,
    String? paymentLink,
    List<Map<String, dynamic>>? vendors,
    VendorInfo? vendorInfo,
    RiderInfo? riderInfo,
    String? cancellationReason,
    double? refundAmount,
    String? refundStatus,
    String? refundReference,
    DateTime? refundInitiatedAt,
    DateTime? refundCompletedAt,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      parentOrderId: parentOrderId ?? this.parentOrderId,
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
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentLink: paymentLink ?? this.paymentLink,
      vendors: vendors ?? this.vendors,
      vendorInfo: vendorInfo ?? this.vendorInfo,
      riderInfo: riderInfo ?? this.riderInfo,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      refundAmount: refundAmount ?? this.refundAmount,
      refundStatus: refundStatus ?? this.refundStatus,
      refundReference: refundReference ?? this.refundReference,
      refundInitiatedAt: refundInitiatedAt ?? this.refundInitiatedAt,
      refundCompletedAt: refundCompletedAt ?? this.refundCompletedAt,
    );
  }

  bool get canBeCancelled {
    return status == OrderStatus.pending ||
        status == OrderStatus.processing ||
        status == OrderStatus.confirmed ||
        status == OrderStatus.preparing;
  }

  bool get isTrackable {
    return (status == OrderStatus.confirmed ||
        status == OrderStatus.preparing ||
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

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'parent_order_id': parentOrderId,
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
      'paymentStatus': paymentStatus,
      'paymentLink': paymentLink,
      'vendors': vendors,
      'vendor_info': vendorInfo?.toJson(),
      'riderInfo': riderInfo?.toJson(),
      'cancellationReason': cancellationReason,
      'refundAmount': refundAmount,
      'refundStatus': refundStatus,
      'refundReference': refundReference,
      'refundInitiatedAt': refundInitiatedAt?.toIso8601String(),
      'refundCompletedAt': refundCompletedAt?.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    double? toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    // Parse order status
    OrderStatus orderStatus = OrderStatus.pending;
    if (json['status'] != null) {
      final s = json['status'].toString().toLowerCase();
      if (s == 'prepared') {
        orderStatus = OrderStatus.preparing;
      } else {
        orderStatus = OrderStatus.values.firstWhere(
          (e) => e.name.toLowerCase() == s,
          orElse: () => OrderStatus.pending,
        );
      }
    }

    // Parse items -> convert API item structure into CartItemModel
    final items = (json['items'] as List? ?? []).map((item) {
      final map = item as Map<String, dynamic>;

      final product = ProductModel(
        id: map['item_id']?.toString() ?? "",
        title: map['title'] ?? "",
        description: "",
        price: map['price']?.toString() ?? "0",
        imagePath: map['image_path'] ?? "",
        categoryId: "",
        shopId: "",
      );

      return CartItemModel(product: product, quantity: map['quantity'] ?? 1);
    }).toList();

    // Parse shipping address (snake_case)
    final sa = json['shipping_address'] as Map<String, dynamic>? ?? {};
    final shippingAddress = ShippingAddressModel(
      id: sa['id'] ?? "",
      userId: json['user_id']?.toString() ?? "",
      name: sa['full_name'] ?? "",
      address: sa['address_line1'] ?? "",
      landmark: sa['address_line2'],
      city: sa['city'] ?? "",
      state: sa['state'] ?? "",
      country: sa['country'] ?? "",
      zipCode: sa['postal_code'] ?? "",
      phoneNumber: sa['phone_number'] ?? "",
      type: AddressType.home,
      isDefault: sa['isDefault'] ?? false,
      createdAt: DateTime.now(),
    );

    // Delivery option
    final doMap = json['delivery_option'] as Map<String, dynamic>? ?? {};
    DeliveryType dType = DeliveryType.combined;
    if (doMap['type'] == "urgent") dType = DeliveryType.urgent;
    if (doMap['type'] == "split") dType = DeliveryType.split;
    if (doMap['type'] == "combined") dType = DeliveryType.combined;

    final deliveryOption = DeliveryOptionModel(
      type: dType,
      title: doMap['title'] ?? "",
      description: doMap['description'] ?? "",
      price: toDouble(doMap['price']) ?? 0.0,
      isSelected: true,
    );

    // Payment method
    final pm = json['payment_method'] as Map<String, dynamic>? ?? {};
    PaymentMethodType pType = PaymentMethodType.cashfree;
    if (pm['type'] == "cod") pType = PaymentMethodType.cashOnDelivery;
    if (pm['type'] == "phonepe") pType = PaymentMethodType.phonePe;

    final paymentMethod = PaymentMethodModel(type: pType, isSelected: true);

    return OrderModel(
      orderId: json['order_id'] ?? "",
      userId: json['user_id']?.toString() ?? "",
      parentOrderId: json['parent_order_id'],
      items: items,
      shippingAddress: shippingAddress,
      deliveryOption: deliveryOption,
      paymentMethod: paymentMethod,
      subtotal: toDouble(json['subtotal']) ?? 0.0,
      deliveryFee: toDouble(json['delivery_fee']) ?? 0.0,
      total: toDouble(json['total']) ?? 0.0,
      couponCode: json['coupon_code'] ?? "",
      discount: toDouble(json['discount']) ?? 0.0,
      orderDate: DateTime.tryParse(json['order_date'] ?? "") ?? DateTime.now(),
      status: orderStatus,
      transactionId: json['transaction_id'],
      trackingNumber: json['tracking_number'],
      estimatedDelivery: json['estimated_delivery'] != null
          ? DateTime.tryParse(json['estimated_delivery'])
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      paymentStatus: json['payment_status'],
      paymentLink: json['payment_link'],
      vendors: (json['vendors'] as List?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      vendorInfo: json['vendor_info'] != null
          ? VendorInfo.fromJson(json['vendor_info'] as Map<String, dynamic>)
          : null,
      riderInfo: json['rider_info'] != null
          ? RiderInfo.fromJson(json['rider_info'] as Map<String, dynamic>)
          : null,
      cancellationReason: json['cancellation_reason'],
      refundAmount: toDouble(json['refund_amount']),
      refundStatus: json['refund_status'],
      refundReference: json['refund_reference'],
      refundInitiatedAt: json['refund_initiated_at'] != null
          ? DateTime.tryParse(json['refund_initiated_at'])
          : null,
      refundCompletedAt: json['refund_completed_at'] != null
          ? DateTime.tryParse(json['refund_completed_at'])
          : null,
    );
  }
}
