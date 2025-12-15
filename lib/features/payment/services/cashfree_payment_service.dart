import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import '../../../core/utils/logging/logger.dart';

/// Cashfree Payment Service
///
/// Handles payment integration using the official Cashfree SDK.
/// This service manages payment sessions, callbacks, and payment verification.
class CashfreePaymentService {
  final CFPaymentGatewayService _paymentGatewayService =
      CFPaymentGatewayService();

  // Determine environment based on build mode
  // In production, use CFEnvironment.PRODUCTION
  final CFEnvironment _environment = CFEnvironment.SANDBOX;

  // Callbacks
  void Function(String orderId)? _onPaymentSuccess;
  void Function(String orderId, String errorMessage)? _onPaymentError;

  /// Initialize the payment service with callbacks
  void initialize({
    required void Function(String orderId) onPaymentSuccess,
    required void Function(String orderId, String errorMessage) onPaymentError,
  }) {
    _onPaymentSuccess = onPaymentSuccess;
    _onPaymentError = onPaymentError;

    // Set up SDK callbacks
    _paymentGatewayService.setCallback(_verifyPayment, _onError);
  }

  /// Internal callback for payment verification
  void _verifyPayment(String orderId) {
    AppLoggerHelper.debug('✅ Payment verified for order: $orderId');
    _onPaymentSuccess?.call(orderId);
  }

  /// Internal callback for payment errors
  void _onError(CFErrorResponse errorResponse, String orderId) {
    final errorMessage = errorResponse.getMessage() ?? 'Payment failed';
    AppLoggerHelper.error('❌ Payment error for order $orderId: $errorMessage');
    _onPaymentError?.call(orderId, errorMessage);
  }

  /// Start payment checkout with Cashfree
  ///
  /// [cfOrderId] - Cashfree order ID from backend
  /// [paymentSessionId] - Payment session ID from backend
  Future<void> startPayment({
    required String cfOrderId,
    required String paymentSessionId,
  }) async {
    try {
      AppLoggerHelper.debug('Starting Cashfree payment...');
      AppLoggerHelper.debug('CF Order ID: $cfOrderId');
      AppLoggerHelper.debug('Payment Session ID: $paymentSessionId');

      // Create session
      final session = _createSession(
        orderId: cfOrderId,
        paymentSessionId: paymentSessionId,
      );

      if (session == null) {
        throw Exception('Failed to create Cashfree session');
      }

      // Create web checkout payment
      final cfWebCheckout = CFWebCheckoutPaymentBuilder()
          .setSession(session)
          .build();

      AppLoggerHelper.debug('Initiating payment...');

      // Start payment
      _paymentGatewayService.doPayment(cfWebCheckout);
    } on CFException catch (e) {
      AppLoggerHelper.error('❌ Cashfree exception', e);
      throw Exception('Payment initialization failed: ${e.message}');
    } catch (e) {
      AppLoggerHelper.error('❌ Error starting payment', e);
      throw Exception('Payment initialization failed: $e');
    }
  }

  /// Create Cashfree session
  CFSession? _createSession({
    required String orderId,
    required String paymentSessionId,
  }) {
    try {
      return CFSessionBuilder()
          .setEnvironment(_environment)
          .setOrderId(orderId)
          .setPaymentSessionId(paymentSessionId)
          .build();
    } on CFException catch (e) {
      AppLoggerHelper.error('❌ Error creating session', e);
      return null;
    }
  }
}
