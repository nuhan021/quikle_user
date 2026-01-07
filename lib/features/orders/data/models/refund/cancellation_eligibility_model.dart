import 'package:quikle_user/core/utils/constants/enums/order_enums.dart';

/// Model representing cancellation eligibility and impact
class CancellationEligibility {
  final bool isAllowed;
  final String message;
  final double orderAmount;
  final double cancellationFee;
  final double refundAmount;
  final bool isFeeWaived;

  const CancellationEligibility({
    required this.isAllowed,
    required this.message,
    required this.orderAmount,
    this.cancellationFee = 0.0,
    required this.refundAmount,
    this.isFeeWaived = false,
  });

  factory CancellationEligibility.fromJson(Map<String, dynamic> json) {
    return CancellationEligibility(
      isAllowed: json['isAllowed'] ?? false,
      message: json['message'] ?? '',
      orderAmount: (json['orderAmount'] ?? 0.0).toDouble(),
      cancellationFee: (json['cancellationFee'] ?? 0.0).toDouble(),
      refundAmount: (json['refundAmount'] ?? 0.0).toDouble(),
      isFeeWaived: json['isFeeWaived'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isAllowed': isAllowed,
      'message': message,
      'orderAmount': orderAmount,
      'cancellationFee': cancellationFee,
      'refundAmount': refundAmount,
      'isFeeWaived': isFeeWaived,
    };
  }

  /// Get eligibility message based on order status (for frontend fallback)
  static String getMessageForStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return 'Cancellation available. You will receive a full refund.';
      case OrderStatus.confirmed:
        return 'Cancellation available. Refund depends on processing stage.';
      case OrderStatus.preparing:
        return 'Cancellation charges apply at this stage.';
      case OrderStatus.shipped:
        return 'Cancellation charges apply at this stage.';
      case OrderStatus.outForDelivery:
        return "Cancellation isn't available because your order is already out for delivery. If you need help, tap 'Report an Issue' or 'Chat with support'.";
      case OrderStatus.delivered:
        return "This order has already been delivered, so it can't be cancelled. If something is wrong, tap 'Report an Issue'.";
      case OrderStatus.cancelled:
        return 'Your order has been cancelled as requested.';
      default:
        return 'Cancellation not available for this order status.';
    }
  }
}
