import 'package:quikle_user/core/utils/constants/enums/order_enums.dart';
import 'package:quikle_user/core/utils/constants/enums/refund_enums.dart';
import 'package:quikle_user/features/orders/data/models/refund/cancellation_eligibility_model.dart';
import 'package:quikle_user/features/orders/data/models/refund/refund_info_model.dart';
import 'package:quikle_user/features/orders/data/models/refund/issue_report_model.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';
import 'package:quikle_user/features/orders/data/models/order/grouped_order_model.dart';

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
    return _calculateEligibility(order.total, order.status);
  }

  /// Check if grouped orders can be cancelled and get refund impact
  /// Uses the total amount of all orders in the group
  /// TODO: Replace with API call when backend is ready
  /// API endpoint: GET /api/orders/group/{parentOrderId}/cancellation-eligibility
  Future<CancellationEligibility> getCancellationEligibilityForGroup(
    GroupedOrderModel groupedOrder,
  ) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Use group total and group status for eligibility
    return _calculateEligibility(
      groupedOrder.totalAmount,
      groupedOrder.groupStatus,
    );
  }

  /// Frontend fallback logic for cancellation eligibility
  /// Updated refund rules:
  /// - Pending/Processing/Confirmed: Full refund (100%)
  /// - Preparing: 90% refund (10% cut)
  /// - Shipped/Out for Delivery/Delivered/Cancelled/Refunded: No refund (0%)
  CancellationEligibility _calculateEligibility(
    double orderAmount,
    OrderStatus status,
  ) {
    double cancellationFee = 0.0;
    bool isAllowed = false;

    switch (status) {
      case OrderStatus.pending:
      case OrderStatus.processing:
      case OrderStatus.confirmed:
        // Full refund - no charges
        isAllowed = true;
        return CancellationEligibility(
          isAllowed: isAllowed,
          message: 'Full refund available for cancellation.',
          orderAmount: orderAmount,
          cancellationFee: 0.0,
          refundAmount: orderAmount,
          isFeeWaived: true,
        );

      case OrderStatus.preparing:
        // 90% refund - 10% cancellation fee
        isAllowed = true;
        cancellationFee = orderAmount * 0.10;
        return CancellationEligibility(
          isAllowed: isAllowed,
          message: 'Order is being prepared. 10% cancellation fee applies.',
          orderAmount: orderAmount,
          cancellationFee: cancellationFee,
          refundAmount: orderAmount - cancellationFee,
          isFeeWaived: false,
        );

      case OrderStatus.shipped:
      case OrderStatus.outForDelivery:
      case OrderStatus.delivered:
      case OrderStatus.cancelled:
      case OrderStatus.refunded:
        // No refund available
        return CancellationEligibility(
          isAllowed: false,
          message: CancellationEligibility.getMessageForStatus(status),
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
