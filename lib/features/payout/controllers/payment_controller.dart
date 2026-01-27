import 'package:get/get.dart';
import 'package:quikle_user/features/payment/services/cashfree_payment_service.dart';
import 'package:quikle_user/features/payment/services/phonepe_payment_service.dart';

class PaymentController extends GetxController {
  final CashfreePaymentService _cashfreeService = CashfreePaymentService();
  final PhonePePaymentService _phonePeService = PhonePePaymentService();
  final _isProcessing = false.obs;

  bool get isProcessing => _isProcessing.value;

  void initialize({
    required void Function(String orderId) onPaymentSuccess,
    required void Function(String orderId, String error) onPaymentError,
    required void Function() onPaymentProcessing,
  }) {
    // Initialize both services
    _cashfreeService.initialize(
      onPaymentSuccess: onPaymentSuccess,
      onPaymentError: onPaymentError,
      onPaymentProcessing: onPaymentProcessing,
    );

    _phonePeService.initialize(
      onPaymentSuccess: onPaymentSuccess,
      onPaymentError: onPaymentError,
      onPaymentProcessing: onPaymentProcessing,
    );
  }

  Future<void> startCashfreePayment({
    required String cfOrderId,
    required String paymentSessionId,
    required dynamic parentOrderId,
  }) async {
    _isProcessing.value = true;
    try {
      await _cashfreeService.startPayment(
        cfOrderId: cfOrderId,
        paymentSessionId: paymentSessionId,
        parentOrderId: parentOrderId.toString(),
      );
    } finally {
      _isProcessing.value = false;
    }
  }

  Future<void> startPhonePePayment({
    required String phonePeOrderId,
    required String token,
    required String parentOrderId,
    required String merchantId,
  }) async {
    _isProcessing.value = true;
    try {
      await _phonePeService.startPayment(
        phonePeOrderId: phonePeOrderId,
        token: token,
        parentOrderId: parentOrderId,
        paymentId: merchantId,
      );
    } finally {
      _isProcessing.value = false;
    }
  }

  // Backward compatibility - defaults to Cashfree
  Future<void> startPayment({
    required String cfOrderId,
    required String paymentSessionId,
    required dynamic parentOrderId,
  }) async {
    await startCashfreePayment(
      cfOrderId: cfOrderId,
      paymentSessionId: paymentSessionId,
      parentOrderId: parentOrderId,
    );
  }
}
