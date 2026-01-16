import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
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
  final NetworkCaller _networkCaller = NetworkCaller();

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
  /// API endpoint: POST /payment/refunds/orders/{orderId}/cancel
  Future<Map<String, dynamic>> requestCancellation({
    required String orderId,
    required CancellationReason reason,
    String? customNote,
  }) async {
    try {
      // Use the selected reason's display name, or custom note if reason is 'other'
      final reasonText =
          reason == CancellationReason.other && customNote != null
          ? customNote
          : reason.displayName;

      // Build URL with query parameter
      final url = ApiConstants.cancelOrder.replaceAll('{order_id}', orderId);
      final urlWithReason = '$url?reason=${Uri.encodeComponent(reasonText)}';

      // Make API call using NetworkCaller
      final response = await _networkCaller.postRequest(
        urlWithReason,
        headers: {'accept': 'application/json'},
      );

      if (response.isSuccess) {
        return {
          'success': true,
          'message': 'Your order has been cancelled successfully.',
          'orderId': orderId,
          'refundInitiated': true,
          'data': response.responseData,
        };
      } else {
        return {
          'success': false,
          'message': response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to cancel order. Please try again.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Something went wrong. Please try again.',
      };
    }
  }

  /// Request individual order cancellation (for orders within a group)
  /// API endpoint: POST /payment/refunds/individual-orders/{orderId}/cancel
  Future<Map<String, dynamic>> requestIndividualOrderCancellation({
    required String orderId,
    required CancellationReason reason,
    String? customNote,
  }) async {
    try {
      // Use the selected reason's display name, or custom note if reason is 'other'
      final reasonText =
          reason == CancellationReason.other && customNote != null
          ? customNote
          : reason.displayName;

      // Build URL with query parameter
      final url = ApiConstants.cancelIndividualOrder.replaceAll(
        '{order_id}',
        orderId,
      );
      final urlWithReason = '$url?reason=${Uri.encodeComponent(reasonText)}';

      // Make API call using NetworkCaller
      final response = await _networkCaller.postRequest(
        urlWithReason,
        headers: {'accept': 'application/json'},
      );

      if (response.isSuccess) {
        return {
          'success': true,
          'message': 'Your order has been cancelled successfully.',
          'orderId': orderId,
          'refundInitiated': true,
          'data': response.responseData,
        };
      } else {
        return {
          'success': false,
          'message': response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to cancel order. Please try again.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Something went wrong. Please try again.',
      };
    }
  }

  /// Get refund status and timeline for an order
  Future<RefundInfo?> getRefundStatus(String orderId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    return null;
  }

  Future<Map<String, dynamic>> createIssueReport({
    required IssueReport report,
  }) async {
    try {
      final token = StorageService.token;
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      // Prepare form fields
      final fields = <String, String>{
        'order_id': report.orderId,
        'reason': report.issueType.name,
      };

      // Add optional fields
      if (report.customDescription != null &&
          report.customDescription!.isNotEmpty) {
        fields['details'] = report.customDescription!;
      }

      if (report.transactionId != null && report.transactionId!.isNotEmpty) {
        fields['transection_id'] = report.transactionId!;
      }

      // Prepare file if photoUrl contains a local path
      List<http.MultipartFile>? files;
      if (report.photoUrl != null && report.photoUrl!.isNotEmpty) {
        // Check if it's a local file path (not a URL)
        if (!report.photoUrl!.startsWith('http')) {
          final mime = _inferMime(report.photoUrl!);
          final multipartFile = await http.MultipartFile.fromPath(
            'file',
            report.photoUrl!,
            contentType: MediaType.parse(mime),
          );
          files = [multipartFile];
        }
      }

      // Make API call
      final response = await _networkCaller.multipartRequest(
        ApiConstants.reportIssue,
        fields: fields,
        files: files,
        token: 'Bearer $token',
      );

      if (!response.isSuccess) {
        throw Exception(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to submit issue report',
        );
      }

      // Parse response data - handle both Map and String cases
      Map<String, dynamic> responseData;
      if (response.responseData is Map<String, dynamic>) {
        responseData = response.responseData as Map<String, dynamic>;
      } else if (response.responseData is String) {
        responseData = {'raw': response.responseData};
      } else {
        responseData = {};
      }

      final ticketId =
          (responseData['id']?.toString() ??
          responseData['ticket_id']?.toString() ??
          'QK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}');

      final result = {
        'success': true,
        'ticketId': ticketId,
        'message':
            responseData['message'] ??
            responseData['detail'] ??
            'Issue reported successfully. Ticket ID: $ticketId',
        'sla': report.getSlaMessage(),
      };

      print('✅ Returning Success Result: $result');
      return result;
    } catch (e) {
      print('Error creating issue report: $e');
      return {
        'success': false,
        'message': 'Failed to submit issue: ${e.toString()}',
      };
    }
  }

  /// Helper method to infer MIME type from file extension
  String _inferMime(String path) {
    final ext = path.toLowerCase().split('.').last;
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }

  /// Upload photo for issue report
  /// Note: Photo upload is now handled directly in createIssueReport
  /// This method returns the local path as-is for backward compatibility
  Future<String?> uploadIssuePhoto(String localPath) async {
    // Return the local path - it will be uploaded when creating the issue report
    return localPath;
  }
}
