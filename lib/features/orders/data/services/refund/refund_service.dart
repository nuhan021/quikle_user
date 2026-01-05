import 'package:quikle_user/core/utils/constants/enums/order_enums.dart';
import 'package:quikle_user/core/utils/constants/enums/refund_enums.dart';
import 'package:quikle_user/features/orders/data/models/refund/cancellation_eligibility_model.dart';
import 'package:quikle_user/features/orders/data/models/refund/refund_info_model.dart';
import 'package:quikle_user/features/orders/data/models/refund/issue_report_model.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';

/// Service for handling refund and cancellation operations
/// API-ready: All methods return Future and can be easily replaced with HTTP calls
class RefundService {
  /// Check if order can be cancelled and get refund impact
  /// TODO: Replace with API call when backend is ready
  /// API endpoint: GET /api/orders/{orderId}/cancellation-eligibility
  Future<CancellationEligibility> getCancellationEligibility(
    OrderModel order,
  ) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Frontend logic (replace with API response when available)
    return _calculateEligibility(order);
  }

  /// Frontend fallback logic for cancellation eligibility
  CancellationEligibility _calculateEligibility(OrderModel order) {
    final orderAmount = order.total;
    double cancellationFee = 0.0;
    bool isAllowed = false;

    switch (order.status) {
      case OrderStatus.processing:
        isAllowed = true;
        return CancellationEligibility(
          isAllowed: isAllowed,
          message: CancellationEligibility.getMessageForStatus(order.status),
          orderAmount: orderAmount,
          cancellationFee: 0.0,
          refundAmount: orderAmount,
          isFeeWaived: true,
        );

      case OrderStatus.confirmed:
        isAllowed = true;
        return CancellationEligibility(
          isAllowed: isAllowed,
          message: CancellationEligibility.getMessageForStatus(order.status),
          orderAmount: orderAmount,
          cancellationFee: 0.0,
          refundAmount: orderAmount,
          isFeeWaived: true,
        );

      case OrderStatus.shipped: // Preparing/Packing stage
        isAllowed = true;
        // Apply 10% cancellation fee (configurable via API)
        cancellationFee = orderAmount * 0.10;
        return CancellationEligibility(
          isAllowed: isAllowed,
          message: 'Cancellation charges apply at this stage.',
          orderAmount: orderAmount,
          cancellationFee: cancellationFee,
          refundAmount: orderAmount - cancellationFee,
          isFeeWaived: false,
        );

      case OrderStatus.outForDelivery:
      case OrderStatus.delivered:
      case OrderStatus.cancelled:
      case OrderStatus.refunded:
        return CancellationEligibility(
          isAllowed: false,
          message: CancellationEligibility.getMessageForStatus(order.status),
          orderAmount: orderAmount,
          cancellationFee: 0.0,
          refundAmount: 0.0,
        );

      default:
        return CancellationEligibility(
          isAllowed: false,
          message: 'Cancellation not available for this order status.',
          orderAmount: orderAmount,
          cancellationFee: 0.0,
          refundAmount: 0.0,
        );
    }
  }

  /// Request order cancellation with reason
  /// TODO: Replace with API call when backend is ready
  /// API endpoint: POST /api/orders/{orderId}/cancel
  /// Request body: { "reason": "changedMind", "customNote": "..." }
  Future<Map<String, dynamic>> requestCancellation({
    required String orderId,
    required CancellationReason reason,
    String? customNote,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: Replace with actual API call
    // Example:
    // final response = await http.post(
    //   Uri.parse('$baseUrl/api/orders/$orderId/cancel'),
    //   body: {
    //     'reason': reason.name,
    //     'customNote': customNote,
    //   },
    // );

    // Mock response for now
    return {
      'success': true,
      'message': 'Your order has been cancelled as requested.',
      'orderId': orderId,
      'refundInitiated': true,
      'refundReference': 'REF${DateTime.now().millisecondsSinceEpoch}',
    };
  }

  /// Get refund status and timeline for an order
  /// TODO: Replace with API call when backend is ready
  /// API endpoint: GET /api/orders/{orderId}/refund-status
  Future<RefundInfo?> getRefundStatus(String orderId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // For now, return null (no refund) as default
    // When API is ready, it will return RefundInfo.fromJson(response.data)
    return null;
  }

  /// Create an issue report for an order
  /// TODO: Replace with API call when backend is ready
  /// API endpoint: POST /api/orders/{orderId}/issues
  /// Request body: { "issueType": "missingItem", "description": "...", "photoUrl": "...", "transactionId": "..." }
  Future<Map<String, dynamic>> createIssueReport({
    required IssueReport report,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: Replace with actual API call
    // Example:
    // final response = await http.post(
    //   Uri.parse('$baseUrl/api/orders/${report.orderId}/issues'),
    //   body: report.toJson(),
    // );

    // Generate a mock ticket ID
    final ticketId =
        'QK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    return {
      'success': true,
      'ticketId': ticketId,
      'message': 'Ticket created: $ticketId',
      'sla': report.getSlaMessage(),
    };
  }

  /// Upload photo for issue report
  /// TODO: Replace with actual file upload API
  /// API endpoint: POST /api/uploads/issue-photos
  Future<String?> uploadIssuePhoto(String localPath) async {
    // Simulate upload delay
    await Future.delayed(const Duration(milliseconds: 800));

    // TODO: Replace with actual upload logic
    // For now, return a mock URL
    return 'https://quikle.com/uploads/issues/${DateTime.now().millisecondsSinceEpoch}.jpg';
  }
}
