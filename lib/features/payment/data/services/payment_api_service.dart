import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/payment/data/models/payment_initiation_response.dart';
import 'package:quikle_user/features/payment/data/models/confirm_payment_response.dart';

/// Payment API Service
///
/// Handles Cashfree payment initiation with the backend API.
class PaymentApiService {
  final NetworkCaller _networkCaller = NetworkCaller();

  /// Initiate payment for an order
  Future<PaymentInitiationResponse> initiatePayment({
    required String orderId,
  }) async {
    try {
      final token = StorageService.token;
      final refreshToken = StorageService.refreshToken;

      if (token == null || token.isEmpty) {
        throw Exception('User not authenticated');
      }

      final Map<String, dynamic> requestBody = {'order_id': orderId};

      AppLoggerHelper.debug('Initiating payment for order: $orderId');

      final ResponseData response = await _networkCaller.postRequest(
        ApiConstants.initiatePayment,
        body: requestBody,
        headers: {
          'Authorization': 'Bearer $token',
          'refresh-token': '$refreshToken',
        },
      );

      if (response.isSuccess && response.responseData != null) {
        AppLoggerHelper.debug('Payment initiated successfully');
        AppLoggerHelper.debug('Payment response: ${response.responseData}');

        return PaymentInitiationResponse.fromJson(
          response.responseData as Map<String, dynamic>,
        );
      }

      // Extract error message from response
      String errorMessage = 'Failed to initiate payment';
      if (response.responseData != null) {
        final responseData = response.responseData;
        if (responseData is Map && responseData.containsKey('detail')) {
          final detail = responseData['detail'];
          if (detail is String) {
            errorMessage = detail;
          }
        } else if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
      }

      AppLoggerHelper.error('❌ Failed to initiate payment: $errorMessage');
      throw Exception(errorMessage);
    } catch (e) {
      AppLoggerHelper.error('❌ Error initiating payment', e);
      throw Exception('Failed to initiate payment: $e');
    }
  }

  /// Confirm payment completion for an order
  ///
  /// Returns a [ConfirmPaymentResponse] parsed from the backend. The backend
  /// may return success: false with a cashfree_status (e.g. "ACTIVE") which
  /// indicates the payment was not completed. The caller should inspect
  /// `cashfreeStatus` and `message` to determine the next steps.
  Future<ConfirmPaymentResponse> confirmPayment({
    required String parentOrderId,
  }) async {
    try {
      final token = StorageService.token;
      final refreshToken = StorageService.refreshToken;

      if (token == null || token.isEmpty) {
        throw Exception('User not authenticated');
      }

      final Map<String, dynamic> requestBody = {
        'parent_order_id': parentOrderId,
      };

      AppLoggerHelper.debug('Confirming payment for order: $parentOrderId');

      final ResponseData response = await _networkCaller.postRequest(
        ApiConstants.confirmPayment,
        body: requestBody,
        headers: {
          'Authorization': 'Bearer $token',
          'refresh-token': '$refreshToken',
        },
      );

      if (response.responseData != null &&
          response.responseData is Map<String, dynamic>) {
        AppLoggerHelper.debug(
          'Confirm payment response: ${response.responseData}',
        );
        return ConfirmPaymentResponse.fromJson(
          response.responseData as Map<String, dynamic>,
        );
      }

      AppLoggerHelper.error('❌ Empty or invalid response confirming payment');
      throw Exception('Failed to confirm payment: empty response');
    } catch (e) {
      AppLoggerHelper.error('❌ Error confirming payment', e);
      throw Exception('Failed to confirm payment: $e');
    }
  }
}
