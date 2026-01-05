import 'package:quikle_user/core/utils/constants/enums/refund_enums.dart';

/// Model representing refund information and timeline
class RefundInfo {
  final String orderId;
  final double refundAmount;
  final RefundStatus status;
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
    return RefundInfo(
      orderId: json['orderId'] ?? '',
      refundAmount: (json['refundAmount'] ?? 0.0).toDouble(),
      status: _parseRefundStatus(json['status']),
      destination: _parseRefundDestination(json['destination']),
      refundReference: json['refundReference'],
      initiatedAt: json['initiatedAt'] != null
          ? DateTime.parse(json['initiatedAt'])
          : null,
      processedAt: json['processedAt'] != null
          ? DateTime.parse(json['processedAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
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
    if (status == RefundStatus.completed) {
      return 'Refund completed';
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
