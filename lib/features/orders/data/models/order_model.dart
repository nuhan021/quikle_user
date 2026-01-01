import 'package:quikle_user/core/utils/constants/enums/order_enums.dart';
import 'package:quikle_user/core/utils/constants/enums/delivery_enums.dart';
import 'package:quikle_user/core/utils/constants/enums/payment_enums.dart';
import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';
import 'package:quikle_user/features/cart/data/models/cart_item_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/payout/data/models/delivery_option_model.dart';
import 'package:quikle_user/features/payout/data/models/payment_method_model.dart';
import 'package:quikle_user/features/profile/data/models/shipping_address_model.dart';
import 'rider_info_model.dart';
import 'vendor_info_model.dart';

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
  final String? paymentStatus;
  final String? paymentLink;
  final List<Map<String, dynamic>>? vendors;
  final VendorInfo? vendorInfo;
  final RiderInfo? riderInfo;

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
    this.paymentStatus,
    this.paymentLink,
    this.vendors,
    this.vendorInfo,
    this.riderInfo,
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
    String? paymentStatus,
    String? paymentLink,
    List<Map<String, dynamic>>? vendors,
    VendorInfo? vendorInfo,
    RiderInfo? riderInfo,
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
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentLink: paymentLink ?? this.paymentLink,
      vendors: vendors ?? this.vendors,
      vendorInfo: vendorInfo ?? this.vendorInfo,
      riderInfo: riderInfo ?? this.riderInfo,
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
      'paymentStatus': paymentStatus,
      'paymentLink': paymentLink,
      'vendors': vendors,
      'vendor_info': vendorInfo?.toJson(),
      'riderInfo': riderInfo?.toJson(),
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
      orderStatus = OrderStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == s,
        orElse: () => OrderStatus.pending,
      );
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
    );
  }
}
