/// Refund-related enums for cancellation and issue reporting

enum CancellationReason {
  changedMind('Changed my mind'),
  orderedByMistake('Ordered by mistake'),
  wrongAddress('Wrong address'),
  deliveryTakingLong('Delivery taking too long'),
  other('Other');

  final String displayName;
  const CancellationReason(this.displayName);
}

enum IssueType {
  missingItem('Missing item'),
  wrongItem('Wrong item'),
  damagedItem('Damaged item'),
  deliveryDelayed('Delivery delayed / not delivered'),
  paymentIssue('Payment issue'),
  other('Other');

  final String displayName;
  const IssueType(this.displayName);
}

enum RefundStatus {
  notApplicable('Not Applicable'),
  pending('Pending'),
  initiated('Refund initiated'),
  processing('Refund processed'),
  completed('Refund completed'),
  failed('Refund failed'),
  rejected('Refund rejected');

  final String displayName;
  const RefundStatus(this.displayName);
}

enum RefundDestination {
  originalMethod('Original payment method'),
  quikleCredits('Quikle credits');

  final String displayName;
  const RefundDestination(this.displayName);
}
