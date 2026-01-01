/// PhonePe Payment Verification Response Model
class PhonePeVerifyResponse {
  final bool? success;
  final String? message;
  final String? state;
  final String? parentOrderId;
  final int? ordersCount;

  PhonePeVerifyResponse({
    this.success,
    this.message,
    this.state,
    this.parentOrderId,
    this.ordersCount,
  });

  factory PhonePeVerifyResponse.fromJson(Map<String, dynamic> json) {
    return PhonePeVerifyResponse(
      success: json['success'] is bool ? json['success'] as bool : null,
      message: json['message'] as String?,
      state:
          json['state'] as String? ??
          json['STATE'] as String?, // Try lowercase first, then uppercase
      parentOrderId: json['parent_order_id'] as String?,
      ordersCount: json['orders_count'] is int
          ? json['orders_count'] as int
          : (json['orders_count'] is num
                ? (json['orders_count'] as num).toInt()
                : null),
    );
  }
}
