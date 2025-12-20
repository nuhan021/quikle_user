enum DeliveryType {
  combined,
  split,
  urgent;

  /// Convert to backend API format
  String toApiValue() {
    switch (this) {
      case DeliveryType.combined:
        return 'combined';
      case DeliveryType.split:
        return 'split';
      case DeliveryType.urgent:
        return 'urgent';
    }
  }
}
