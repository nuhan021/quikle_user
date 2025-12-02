enum DeliveryType {
  combined,
  split,
  urgent;

  /// Convert to backend API format
  String toApiValue() {
    switch (this) {
      case DeliveryType.combined:
        return 'standard';
      case DeliveryType.split:
        return 'express';
      case DeliveryType.urgent:
        return 'urgent';
    }
  }
}
