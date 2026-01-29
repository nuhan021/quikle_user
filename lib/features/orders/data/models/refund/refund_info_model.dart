import 'package:quikle_user/core/utils/constants/enums/refund_enums.dart';

/// Model representing refund information and timeline
class RefundInfo {
  final String orderId;
  final double refundAmount;
  final String statusString; // Store status as string from API
  final RefundStatus status; // Keep for backward compatibility
  final RefundDestination destination;
  final String? refundReference; // RRN or transaction ID
  final DateTime? initiatedAt;
  final DateTime? processedAt;
  final DateTime? completedAt;
  final DateTime? expectedCompletionDate;
  final String? failureReason;

  const RefundInfo({
    required this.orderId,
    required this.refundAmount,
    required this.statusString,
    required this.status,
    required this.destination,
    this.refundReference,
    this.initiatedAt,
    this.processedAt,
    this.completedAt,
    this.expectedCompletionDate,
    this.failureReason,
  });

  factory RefundInfo.fromJson(Map<String, dynamic> json) {
    // Handle different API response formats
    final refundId = json['refund_id'] ?? json['orderId'] ?? '';
    final refundAmt = (json['refund_amount'] ?? json['refundAmount'] ?? 0.0)
        .toDouble();
    final statusStr = json['status']?.toString() ?? '';
    final completedAtStr = json['completed_at'] ?? json['completedAt'];

    return RefundInfo(
      orderId: refundId,
      refundAmount: refundAmt,
      statusString: statusStr,
      status: _parseRefundStatus(statusStr),
      destination: _parseRefundDestination(json['destination']),
      refundReference: json['refundReference'] ?? json['refund_reference'],
      initiatedAt: json['initiatedAt'] != null
          ? DateTime.parse(json['initiatedAt'])
          : null,
      processedAt: json['processedAt'] != null
          ? DateTime.parse(json['processedAt'])
          : null,
      completedAt: completedAtStr != null
          ? DateTime.parse(completedAtStr)
          : null,
      expectedCompletionDate: json['expectedCompletionDate'] != null
          ? DateTime.parse(json['expectedCompletionDate'])
          : null,
      failureReason: json['failureReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'refundAmount': refundAmount,
      'statusString': statusString,
      'status': status.name,
      'destination': destination.name,
      'refundReference': refundReference,
      'initiatedAt': initiatedAt?.toIso8601String(),
      'processedAt': processedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'expectedCompletionDate': expectedCompletionDate?.toIso8601String(),
      'failureReason': failureReason,
    };
  }

  static RefundStatus _parseRefundStatus(dynamic status) {
    if (status == null) return RefundStatus.notApplicable;
    final statusStr = status.toString().toLowerCase();
    return RefundStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == statusStr,
      orElse: () => RefundStatus.notApplicable,
    );
  }

  static RefundDestination _parseRefundDestination(dynamic destination) {
    if (destination == null) return RefundDestination.originalMethod;
    final destStr = destination.toString().toLowerCase();
    return RefundDestination.values.firstWhere(
      (e) => e.name.toLowerCase() == destStr,
      orElse: () => RefundDestination.originalMethod,
    );
  }

  /// Returns estimated completion message
  String getExpectedTimelineMessage() {
    // Use statusString for more accurate status
    if (statusString.toLowerCase() == 'completed' ||
        status == RefundStatus.completed) {
      return 'Refund completed';
    }
    if (statusString.toLowerCase() == 'processing') {
      return 'Refund is being processed. Expected within 3–5 business days.';
    }
    if (expectedCompletionDate != null) {
      final days = expectedCompletionDate!.difference(DateTime.now()).inDays;
      if (days <= 0) {
        return 'Expected today';
      } else if (days == 1) {
        return 'Expected tomorrow';
      } else {
        return 'Expected in $days days';
      }
    }
    return 'Refund initiated. Expected within 3–5 business days.';
  }
}
