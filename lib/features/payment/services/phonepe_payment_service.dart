import 'dart:convert';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import '../../../core/utils/logging/logger.dart';
import '../data/services/payment_api_service.dart';

/// PhonePe Payment Service
///
/// Handles payment integration using the official PhonePe SDK.
/// This service manages payment sessions, callbacks, and payment verification.
class PhonePePaymentService {
  final PaymentApiService _paymentApiService = PaymentApiService();

  // PhonePe configuration
  final String _environment = "SANDBOX"; // Use "PRODUCTION" for live
  final String _appSchema = "quikleapp"; // iOS URL scheme
  final bool _enableLogging = true;

  // PhonePe merchant ID - this should match your PhonePe dashboard
  static const String _phonePeMerchantId = "M23KQHM53S73C";

  // Callbacks
  void Function(String orderId)? _onPaymentSuccess;
  void Function(String orderId, String errorMessage)? _onPaymentError;
  void Function()? _onPaymentProcessing;

  // Store parent order ID and token for verification
  String? _parentOrderId;
  String? _token;

  /// Initialize the payment service with callbacks
  void initialize({
    required void Function(String orderId) onPaymentSuccess,
    required void Function(String orderId, String errorMessage) onPaymentError,
    void Function()? onPaymentProcessing,
  }) {
    _onPaymentSuccess = onPaymentSuccess;
    _onPaymentError = onPaymentError;
    _onPaymentProcessing = onPaymentProcessing;

    // SDK will be initialized when startPayment is called with merchantId
  }

  /// Start payment checkout with PhonePe
  ///
  /// [phonePeOrderId] - PhonePe order ID from backend
  /// [token] - Payment token from backend
  /// [parentOrderId] - Parent order ID for confirmation
  /// [merchantId] - Merchant ID from backend response
  Future<void> startPayment({
    required String phonePeOrderId,
    required String token,
    required String parentOrderId,
    required String merchantId,
  }) async {
    try {
      // Store order details for verification
      _parentOrderId = parentOrderId;
      _token = token;

      AppLoggerHelper.debug('Starting PhonePe payment...');
      AppLoggerHelper.debug('PhonePe Order ID: $phonePeOrderId');
      AppLoggerHelper.debug('Merchant ID from backend: $merchantId');
      AppLoggerHelper.debug('Parent Order ID: $parentOrderId');

      // Use the correct PhonePe merchant ID (not the one from backend which is wrong)
      // Backend sends parent_order_id as merchantId incorrectly
      const String actualMerchantId = _phonePeMerchantId;
      AppLoggerHelper.debug(
        'Using actual PhonePe Merchant ID: $actualMerchantId',
      );

      // Initialize SDK with actual merchantId from backend
      AppLoggerHelper.debug('Initializing PhonePe SDK with merchantId...');
      bool isInit = await PhonePePaymentSdk.init(
        _environment,
        actualMerchantId,
        _appSchema,
        _enableLogging,
      );

      if (!isInit) {
        AppLoggerHelper.error('❌ PhonePe SDK initialization failed');
        _onPaymentError?.call(
          parentOrderId,
          'PhonePe SDK initialization failed',
        );
        return;
      }

      AppLoggerHelper.debug('✅ PhonePe SDK Initialized successfully');

      // Build payment payload
      Map<String, dynamic> payload = {
        "orderId": phonePeOrderId,
        "merchantId": merchantId,
        "token": token,
        "paymentMode": {"type": "PAY_PAGE"},
      };

      String request = jsonEncode(payload);

      AppLoggerHelper.debug('Initiating PhonePe payment...');

      // Start transaction
      final response = await PhonePePaymentSdk.startTransaction(
        request,
        _appSchema,
      );

      // Handle payment response
      _handlePaymentResponse(response);
    } catch (e) {
      AppLoggerHelper.error('❌ Error starting PhonePe payment', e);
      _onPaymentError?.call(parentOrderId, 'Payment initialization failed: $e');
    }
  }

  /// Handle payment response from PhonePe SDK
  void _handlePaymentResponse(dynamic response) async {
    if (response == null) {
      AppLoggerHelper.error('❌ PhonePe payment response is null');
      _onPaymentError?.call(_parentOrderId ?? '', 'Transaction incomplete');
      return;
    }

    final String status = response['status']?.toString() ?? '';
    final String error = response['error']?.toString() ?? '';

    AppLoggerHelper.debug('PhonePe Payment Response:');
    AppLoggerHelper.debug('Status: $status');
    AppLoggerHelper.debug('Error: $error');

    // Notify that payment is being processed
    _onPaymentProcessing?.call();

    // Verify payment status with backend
    if (_parentOrderId != null && _token != null) {
      await _verifyPaymentStatus();
    } else {
      AppLoggerHelper.error('❌ Missing order details for verification');
      _onPaymentError?.call(
        _parentOrderId ?? '',
        'Payment verification failed',
      );
    }
  }

  /// Verify payment status with backend
  Future<void> _verifyPaymentStatus() async {
    try {
      AppLoggerHelper.debug('Verifying PhonePe payment status with backend...');
      AppLoggerHelper.debug('Merchant Order ID: $_parentOrderId');

      final verifyResponse = await _paymentApiService.verifyPhonePePayment(
        merchantOrderId: _parentOrderId!,
        token: _token!,
      );

      AppLoggerHelper.debug(
        'PhonePe verification response - State: ${verifyResponse.state}, Message: ${verifyResponse.message}',
      );

      final paymentState = verifyResponse.state?.toUpperCase();

      // If payment state is COMPLETED, treat as success
      if (paymentState == 'COMPLETED') {
        AppLoggerHelper.debug(
          '✅ Payment state COMPLETED — calling success callback',
        );
        _onPaymentSuccess?.call(_parentOrderId!);
        return;
      }

      // For any other state, treat as payment not completed
      final msg =
          verifyResponse.message ??
          'Payment not completed. State: ${verifyResponse.state}';
      AppLoggerHelper.error('❌ Payment not completed: $msg');
      _onPaymentError?.call(_parentOrderId!, msg);
    } catch (e) {
      AppLoggerHelper.error('❌ Failed to verify PhonePe payment', e);
      _onPaymentError?.call(
        _parentOrderId ?? '',
        'Failed to verify payment status',
      );
    }
  }

  /// Check if PhonePe is initialized
  /// Note: SDK is initialized per-transaction with merchantId, so this always returns false
  @deprecated
  Future<bool> isInitialized() async {
    return false; // SDK is initialized when startPayment is called
  }
}
