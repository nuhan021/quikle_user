import 'package:get/get.dart';
import 'package:quikle_user/features/payment/services/cashfree_payment_service.dart';

class PaymentController extends GetxController {
  final CashfreePaymentService _cashfreeService = CashfreePaymentService();
  final _isProcessing = false.obs;

  bool get isProcessing => _isProcessing.value;

  void initialize({
    required void Function(String orderId) onPaymentSuccess,
    required void Function(String orderId, String error) onPaymentError,
    required void Function() onPaymentProcessing,
  }) {
    _cashfreeService.initialize(
      onPaymentSuccess: onPaymentSuccess,
      onPaymentError: onPaymentError,
      onPaymentProcessing: onPaymentProcessing,
    );
  }

  Future<void> startPayment({
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
}
