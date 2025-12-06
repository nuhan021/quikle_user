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
    return OrderCreationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: OrderCreationData.fromJson(json['data'] ?? {}),
    );
  }
}

class OrderCreationData {
  final String orderId;
  final String status;
  final String trackingNumber;
  final double total;
  final String paymentStatus;
  final bool requiresPayment;
  final String paymentLink;
  final String cfOrderId;

  OrderCreationData({
    required this.orderId,
    required this.status,
    required this.trackingNumber,
    required this.total,
    required this.paymentStatus,
    required this.requiresPayment,
    required this.paymentLink,
    required this.cfOrderId,
  });

  factory OrderCreationData.fromJson(Map<String, dynamic> json) {
    return OrderCreationData(
      orderId: json['order_id'] ?? '',
      status: json['status'] ?? '',
      trackingNumber: json['tracking_number'] ?? '',
      total: (json['total'] ?? 0).toDouble(),
      paymentStatus: json['payment_status'] ?? '',
      requiresPayment: json['requires_payment'] ?? false,
      paymentLink: json['payment_link'] ?? '',
      cfOrderId: json['cf_order_id'] ?? '',
    );
  }
}
