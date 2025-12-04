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
  final DeliveryOptionData deliveryOption;
  final PaymentMethodData paymentMethod;
  final bool requiresPayment;
  final String? paymentInstructions;

  OrderCreationData({
    required this.orderId,
    required this.status,
    required this.trackingNumber,
    required this.total,
    required this.deliveryOption,
    required this.paymentMethod,
    required this.requiresPayment,
    this.paymentInstructions,
  });

  factory OrderCreationData.fromJson(Map<String, dynamic> json) {
    return OrderCreationData(
      orderId: json['order_id'] ?? '',
      status: json['status'] ?? '',
      trackingNumber: json['tracking_number'] ?? '',
      total: (json['total'] ?? 0).toDouble(),
      deliveryOption: DeliveryOptionData.fromJson(
        json['delivery_option'] ?? {},
      ),
      paymentMethod: PaymentMethodData.fromJson(json['payment_method'] ?? {}),
      requiresPayment: json['requires_payment'] ?? false,
      paymentInstructions: json['payment_instructions'],
    );
  }
}

class DeliveryOptionData {
  final String type;
  final String title;
  final String description;
  final double price;

  DeliveryOptionData({
    required this.type,
    required this.title,
    required this.description,
    required this.price,
  });

  factory DeliveryOptionData.fromJson(Map<String, dynamic> json) {
    return DeliveryOptionData(
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}

class PaymentMethodData {
  final String type;
  final String name;

  PaymentMethodData({required this.type, required this.name});

  factory PaymentMethodData.fromJson(Map<String, dynamic> json) {
    return PaymentMethodData(
      type: json['type'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
