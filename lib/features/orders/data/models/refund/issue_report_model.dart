import 'package:quikle_user/core/utils/constants/enums/refund_enums.dart';

/// Model for submitting an issue report
class IssueReport {
  final String orderId;
  final IssueType issueType;
  final String? customDescription;
  final String? photoUrl; // Local path or uploaded URL
  final String? transactionId;
  final DateTime createdAt;
  final String? ticketId; // Generated after submission

  const IssueReport({
    required this.orderId,
    required this.issueType,
    this.customDescription,
    this.photoUrl,
    this.transactionId,
    required this.createdAt,
    this.ticketId,
  });

  factory IssueReport.fromJson(Map<String, dynamic> json) {
    return IssueReport(
      orderId: json['orderId'] ?? '',
      issueType: _parseIssueType(json['issueType']),
      customDescription: json['customDescription'],
      photoUrl: json['photoUrl'],
      transactionId: json['transactionId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      ticketId: json['ticketId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'issueType': issueType.name,
      'customDescription': customDescription,
      'photoUrl': photoUrl,
      'transactionId': transactionId,
      'createdAt': createdAt.toIso8601String(),
      'ticketId': ticketId,
    };
  }

  static IssueType _parseIssueType(dynamic type) {
    if (type == null) return IssueType.other;
    final typeStr = type.toString().toLowerCase();
    return IssueType.values.firstWhere(
      (e) => e.name.toLowerCase() == typeStr,
      orElse: () => IssueType.other,
    );
  }

  /// Get SLA message based on issue type
  String getSlaMessage() {
    switch (issueType) {
      case IssueType.missingItem:
      case IssueType.wrongItem:
      case IssueType.damagedItem:
        return 'within 30 minutes';
      case IssueType.paymentIssue:
        return 'within 1 hour';
      default:
        return 'within 30 minutes';
    }
  }
}
