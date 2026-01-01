class OrderCreationResponse {
  final bool success;
  final String message;
  final OrderCreationData data;

  OrderCreationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OrderCreationResponse.fromJson(Map<String, dynamic> json) {
    // Check if this is a PhonePe response (no nested 'data' object)
    final bool isPhonePeResponse =
        json.containsKey('phonePE_orderId') && json.containsKey('merchantId');

    if (isPhonePeResponse) {
      // PhonePe response structure - data is at root level
      return OrderCreationResponse(
        success: true, // PhonePe returns success implicitly
        message: 'Order created successfully',
        data: OrderCreationData.fromJson(json),
      );
    } else {
      // Cashfree response structure - data is nested
      return OrderCreationResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: OrderCreationData.fromJson(json['data'] ?? {}),
      );
    }
  }
}

class OrderCreationData {
  final List<OrderInfo> orders;
  final double totalAmount;
  final String paymentStatus;
  final bool requiresPayment;
  final String paymentSessionId;
  final String cfOrderId;
  final String parentOrderId;

  // PhonePe specific fields
  final String? phonePeOrderId;
  final String? phonePeToken;
  final String? merchantId;

  OrderCreationData({
    required this.orders,
    required this.totalAmount,
    required this.paymentStatus,
    required this.requiresPayment,
    required this.paymentSessionId,
    required this.cfOrderId,
    required this.parentOrderId,
    this.phonePeOrderId,
    this.phonePeToken,
    this.merchantId,
  });

  // Convenience getters for backward compatibility
  String get orderId => parentOrderId;
  String get trackingNumber =>
      orders.isNotEmpty ? orders.first.trackingNumber : '';
  double get total => totalAmount;
  String get paymentLink => ''; // No longer used with SDK

  factory OrderCreationData.fromJson(Map<String, dynamic> json) {
    final ordersList =
        (json['orders'] as List<dynamic>?)
            ?.map((e) => OrderInfo.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    // Check if this is a PhonePe response
    final bool isPhonePeResponse = json.containsKey('phonePE_orderId');

    if (isPhonePeResponse) {
      // PhonePe response - different structure
      return OrderCreationData(
        orders: ordersList,
        totalAmount: ordersList.isNotEmpty ? ordersList.first.total : 0.0,
        paymentStatus: 'pending',
        requiresPayment: true, // PhonePe always requires payment
        paymentSessionId: '', // Not used in PhonePe
        cfOrderId: '', // Not used in PhonePe
        parentOrderId: json['parent_order_id'] ?? '',
        // PhonePe specific fields
        phonePeOrderId: json['phonePE_orderId'] as String?,
        phonePeToken: json['token'] as String?,
        merchantId: json['merchantId'] as String?,
      );
    } else {
      // Cashfree response - original structure
      return OrderCreationData(
        orders: ordersList,
        totalAmount: (json['total_amount'] ?? 0).toDouble(),
        paymentStatus: json['payment_status'] ?? '',
        requiresPayment: json['requires_payment'] ?? false,
        paymentSessionId: json['payment_session_id'] ?? '',
        cfOrderId: json['cf_order_id'] ?? '',
        parentOrderId: json['parent_order_id'] ?? '',
        // PhonePe fields will be null for Cashfree
        phonePeOrderId: null,
        phonePeToken: null,
        merchantId: null,
      );
    }
  }
}

class OrderInfo {
  final String orderId;
  final int vendorId;
  final String status;
  final String trackingNumber;
  final double total;

  OrderInfo({
    required this.orderId,
    required this.vendorId,
    required this.status,
    required this.trackingNumber,
    required this.total,
  });

  factory OrderInfo.fromJson(Map<String, dynamic> json) {
    return OrderInfo(
      orderId: json['order_id'] ?? '',
      vendorId: json['vendor_id'] ?? 0,
      status: json['status'] ?? '',
      trackingNumber: json['tracking_number'] ?? '',
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}
