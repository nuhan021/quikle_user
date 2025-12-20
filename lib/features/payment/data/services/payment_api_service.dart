import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/payment/data/models/payment_initiation_response.dart';

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
  Future<void> confirmPayment({required String parentOrderId}) async {
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

      if (response.isSuccess) {
        AppLoggerHelper.debug('✅ Payment confirmed successfully');
      } else {
        AppLoggerHelper.error('❌ Failed to confirm payment');
        throw Exception('Failed to confirm payment');
      }
    } catch (e) {
      AppLoggerHelper.error('❌ Error confirming payment', e);
      throw Exception('Failed to confirm payment: $e');
    }
  }
}
