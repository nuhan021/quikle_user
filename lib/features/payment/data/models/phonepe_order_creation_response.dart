/// PhonePe Order Creation Response Model
class PhonePeOrderCreationResponse {
  final String phonePeOrderId;
  final String merchantId;
  final String token;
  final PaymentMode paymentMode;
  final List<OrderInfo> orders;
  final String parentOrderId;

  PhonePeOrderCreationResponse({
    required this.phonePeOrderId,
    required this.merchantId,
    required this.token,
    required this.paymentMode,
    required this.orders,
    required this.parentOrderId,
  });

  factory PhonePeOrderCreationResponse.fromJson(Map<String, dynamic> json) {
    return PhonePeOrderCreationResponse(
      phonePeOrderId: json['phonePE_orderId'] ?? '',
      merchantId: json['merchantId'] ?? '',
      token: json['token'] ?? '',
      paymentMode: PaymentMode.fromJson(
        json['paymentMode'] ?? {'type': 'PAY_PAGE'},
      ),
      orders:
          (json['orders'] as List<dynamic>?)
              ?.map((e) => OrderInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      parentOrderId: json['parent_order_id'] ?? '',
    );
  }
}

class PaymentMode {
  final String type;

  PaymentMode({required this.type});

  factory PaymentMode.fromJson(Map<String, dynamic> json) {
    return PaymentMode(type: json['type'] ?? 'PAY_PAGE');
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
