enum PaymentMethodType {
  paytm('Paytm', 'assets/icons/paytm.png'),
  googlePay('Google Pay', 'assets/icons/google_pay.png'),
  phonePe('PhonePe', 'assets/icons/phone_pe.png'),
  cashfree('Cashfree', 'assets/icons/cashfree.png'),
  razorpay('Razorpay', 'assets/icons/razorpay.png'),
  cashOnDelivery('Cash On Delivery', 'assets/icons/cod.png');

  final String displayName;
  final String? iconPath;

  const PaymentMethodType(this.displayName, this.iconPath);

  /// Convert to backend API format
  String toApiValue() {
    switch (this) {
      case PaymentMethodType.razorpay:
        return 'razorpay';
      case PaymentMethodType.cashOnDelivery:
        return 'cod';
      // Map other payment methods to razorpay as default
      case PaymentMethodType.paytm:
      case PaymentMethodType.googlePay:
      case PaymentMethodType.phonePe:
      case PaymentMethodType.cashfree:
        return 'cashfree';
    }
  }
}
