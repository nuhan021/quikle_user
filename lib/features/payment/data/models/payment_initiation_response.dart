class PaymentInitiationResponse {
  final bool success;
  final String orderId;
  final String cfOrderId;
  final String paymentLink;
  final String message;

  PaymentInitiationResponse({
    required this.success,
    required this.orderId,
    required this.cfOrderId,
    required this.paymentLink,
    required this.message,
  });

  factory PaymentInitiationResponse.fromJson(Map<String, dynamic> json) {
    return PaymentInitiationResponse(
      success: json['success'] ?? false,
      orderId: json['order_id'] ?? '',
      cfOrderId: json['cf_order_id'] ?? '',
      paymentLink: json['payment_link'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
