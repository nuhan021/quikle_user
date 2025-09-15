enum SupportIssueType {
  orderIssue('Order Issue'),
  paymentIssue('Payment Issue'),
  deliveryIssue('Delivery Issue'),
  accountIssue('Account Issue'),
  technicalIssue('Technical Issue'),
  other('Other');

  const SupportIssueType(this.label);
  final String label;
}

enum SupportTicketStatus {
  pending('Pending'),
  inProgress('In Progress'),
  resolved('Resolved'),
  closed('Closed');

  const SupportTicketStatus(this.label);
  final String label;
}

class SupportTicketModel {
  final String id;
  final String title;
  final String description;
  final SupportIssueType issueType;
  final SupportTicketStatus status;
  final DateTime submittedAt;
  final String? attachmentPath;
  final DateTime? resolvedAt;

  const SupportTicketModel({
    required this.id,
    required this.title,
    required this.description,
    required this.issueType,
    required this.status,
    required this.submittedAt,
    this.attachmentPath,
    this.resolvedAt,
  });

  SupportTicketModel copyWith({
    String? id,
    String? title,
    String? description,
    SupportIssueType? issueType,
    SupportTicketStatus? status,
    DateTime? submittedAt,
    String? attachmentPath,
    DateTime? resolvedAt,
  }) {
    return SupportTicketModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      issueType: issueType ?? this.issueType,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }
}
