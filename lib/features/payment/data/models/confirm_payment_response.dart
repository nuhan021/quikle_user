class CashfreeResponse {
  final bool? success;
  final String? orderStatus;
  final String? cfOrderId;
  final double? orderAmount;
  final String? paymentSessionId;

  CashfreeResponse({
    this.success,
    this.orderStatus,
    this.cfOrderId,
    this.orderAmount,
    this.paymentSessionId,
  });

  factory CashfreeResponse.fromJson(Map<String, dynamic> json) {
    return CashfreeResponse(
      success: json['success'] is bool ? json['success'] as bool : null,
      orderStatus: json.containsKey('order_status')
          ? json['order_status'] as String?
          : null,
      cfOrderId: json.containsKey('cf_order_id')
          ? json['cf_order_id'] as String?
          : null,
      orderAmount: json.containsKey('order_amount')
          ? (json['order_amount'] is num
                ? (json['order_amount'] as num).toDouble()
                : null)
          : null,
      paymentSessionId: json.containsKey('payment_session_id')
          ? json['payment_session_id'] as String?
          : null,
    );
  }
}

class ConfirmPaymentResponse {
  final bool? success;
  final String? message;
  final String? parentOrderId;
  final int? ordersCount;
  final String? cashfreeStatus;
  final CashfreeResponse? cashfreeResponse;

  ConfirmPaymentResponse({
    this.success,
    this.message,
    this.parentOrderId,
    this.ordersCount,
    this.cashfreeStatus,
    this.cashfreeResponse,
  });

  factory ConfirmPaymentResponse.fromJson(Map<String, dynamic> json) {
    return ConfirmPaymentResponse(
      success: json['success'] is bool ? json['success'] as bool : null,
      message: json['message'] as String?,
      parentOrderId: json['parent_order_id'] as String?,
      ordersCount: json['orders_count'] is int
          ? json['orders_count'] as int
          : (json['orders_count'] is num
                ? (json['orders_count'] as num).toInt()
                : null),
      cashfreeStatus: json['cashfree_status'] as String?,
      cashfreeResponse: json['cashfree_response'] is Map<String, dynamic>
          ? CashfreeResponse.fromJson(
              json['cashfree_response'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
