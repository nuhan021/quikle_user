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
}
