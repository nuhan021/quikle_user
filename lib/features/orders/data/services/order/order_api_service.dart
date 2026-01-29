import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/core/utils/constants/enums/order_enums.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/cart/data/models/cart_item_model.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';
import 'package:quikle_user/features/payout/data/models/delivery_option_model.dart';
import 'package:quikle_user/features/payout/data/models/payment_method_model.dart';
import 'package:quikle_user/features/profile/address/data/models/shipping_address_model.dart';
import 'package:quikle_user/features/payment/data/models/order_creation_response.dart';

/// Order API Service
///
/// Handles order creation with the backend API.
/// The API expects orders in the following format:
/// {
///   "items": [{"item_id": 2520, "quantity": 3}],
///   "shipping_address": {
///     "fullName": "John Doe",
///     "addressLine1": "123 Main Street",
///     "addressLine2": "Apartment 4B",
///     "city": "New York",
///     "state": "NY",
///     "postalCode": "10001",
///     "country": "USA",
///     "phoneNumber": "+1 555-123-4567",
///     "isDefault": false
///   },
///   "delivery_option": {
///     "type": "standard",
///     "title": "string",
///     "description": "string",
///     "price": 0
///   },
///   "payment_method": {
///     "type": "razorpay",
///     "title": "string",
///     "description": "string",
///     "is_active": true
///   },
///   "coupon_code": ""
/// }
class OrderApiService {
  final NetworkCaller _networkCaller = NetworkCaller();

  /// Get user orders
  Future<List<OrderModel>> getOrders({int skip = 0, int limit = 10}) async {
    try {
      final token = StorageService.token;
      final refreshToken = StorageService.refreshToken;

      if (token == null || token.isEmpty) {
        throw Exception('User not authenticated');
      }

      final queryParams = {'skip': skip.toString(), 'limit': limit.toString()};

      AppLoggerHelper.debug('Fetching orders with params: $queryParams');

      final ResponseData response = await _networkCaller.getRequest(
        ApiConstants.getOrders,
        queryParams: queryParams,
        headers: {
          'Authorization': 'Bearer $token',
          'refresh-token': '$refreshToken',
        },
      );

      if (response.isSuccess && response.responseData != null) {
        // API returns a MAP with orders list
        final data = response.responseData as Map<String, dynamic>;
        final ordersList = (data['data'] as List<dynamic>?) ?? [];

        final allOrders = ordersList
            .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
            .toList();

        // Filter out orders with pending status
        final filteredOrders = allOrders
            .where((order) => order.status != OrderStatus.pending)
            .toList();

        return filteredOrders;
      }

      AppLoggerHelper.warning('No orders found or API call failed');
      return [];
    } catch (e) {
      AppLoggerHelper.error('❌ Error fetching orders', e);
      throw Exception('Failed to fetch orders: $e');
    }
  }

  /// Create a new order
  Future<OrderCreationResponse> createOrder({
    required List<CartItemModel> items,
    required ShippingAddressModel shippingAddress,
    required DeliveryOptionModel deliveryOption,
    required PaymentMethodModel paymentMethod,
    String? couponCode,
  }) async {
    try {
      final token = StorageService.token;
      final refreshToken = StorageService.refreshToken;

      if (token == null || token.isEmpty) {
        throw Exception('User not authenticated');
      }

      // Build items array
      final itemsArray = items.map((cartItem) {
        return {
          'item_id': int.parse(cartItem.product.id),
          'quantity': cartItem.quantity,
        };
      }).toList();

      // Build shipping address
      final shippingAddressMap = {
        'fullName': shippingAddress.name,
        'addressLine1': shippingAddress.address,
        'addressLine2': shippingAddress.landmark ?? '',
        'city': shippingAddress.city,
        'state': shippingAddress.state,
        'postalCode': shippingAddress.zipCode,
        'country': shippingAddress.country,
        'phoneNumber': shippingAddress.phoneNumber,
        'isDefault': shippingAddress.isDefault,
      };

      // Build delivery option
      final deliveryOptionMap = {
        'type': deliveryOption.type.toApiValue(),
        'title': deliveryOption.title,
        'description': deliveryOption.description,
        'price': deliveryOption.price,
      };

      // Build payment method
      final paymentMethodMap = {
        'type': paymentMethod.type.toApiValue(),
        'title': paymentMethod.type.displayName,
        'description': '',
        'is_active': true,
      };

      // Build request body
      final Map<String, dynamic> requestBody = {
        'items': itemsArray,
        'shipping_address': shippingAddressMap,
        'delivery_option': deliveryOptionMap,
        'payment_method': paymentMethodMap,
        'coupon_code': couponCode ?? '',
      };

      AppLoggerHelper.debug('Creating order with body: $requestBody');

      final url = ApiConstants.createOrder.replaceFirst(
        '{order_type_name}',
        deliveryOption.type.toApiValue(),
      );

      AppLoggerHelper.debug('Order creation URL: $url');

      final ResponseData response = await _networkCaller.postRequest(
        url,
        body: requestBody,
        headers: {
          'Authorization': 'Bearer $token',
          'refresh-token': '$refreshToken',
        },
      );

      if (response.isSuccess && response.responseData != null) {
        AppLoggerHelper.debug('Order created successfully');
        AppLoggerHelper.debug('Order response: ${response.responseData}');

        // Log response structure for debugging
        final responseMap = response.responseData as Map<String, dynamic>;
        AppLoggerHelper.debug('Response keys: ${responseMap.keys.toList()}');

        // Check if it's PhonePe or Cashfree response
        final bool isPhonePeResponse = responseMap.containsKey(
          'phonePE_orderId',
        );
        AppLoggerHelper.debug(
          'Response type: ${isPhonePeResponse ? 'PhonePe' : 'Cashfree'}',
        );

        if (isPhonePeResponse) {
          // PhonePe response - data is at root level
          AppLoggerHelper.debug('Parsing PhonePe response...');
        } else if (responseMap.containsKey('data')) {
          // Cashfree response - data is nested
          final dataMap = responseMap['data'] as Map<String, dynamic>;
          AppLoggerHelper.debug('Data keys: ${dataMap.keys.toList()}');
        }

        final orderResponse = OrderCreationResponse.fromJson(
          response.responseData as Map<String, dynamic>,
        );

        AppLoggerHelper.debug(
          'Order ID: ${orderResponse.data.orderId}, Requires Payment: ${orderResponse.data.requiresPayment}',
        );

        // Log payment method detected
        if (orderResponse.data.phonePeOrderId != null) {
          AppLoggerHelper.debug(
            'PhonePe Payment - Order: ${orderResponse.data.phonePeOrderId}, Token: ${orderResponse.data.phonePeToken}, Merchant: ${orderResponse.data.merchantId}',
          );
        } else if (orderResponse.data.cfOrderId.isNotEmpty) {
          AppLoggerHelper.debug(
            'Cashfree Payment - Order: ${orderResponse.data.cfOrderId}, Session: ${orderResponse.data.paymentSessionId}',
          );
        }

        return orderResponse;
      }

      // Extract error message from response
      String errorMessage = 'Failed to create order';
      if (response.responseData != null) {
        final responseData = response.responseData;
        if (responseData is Map && responseData.containsKey('detail')) {
          // Handle validation errors
          final detail = responseData['detail'];
          if (detail is List && detail.isNotEmpty) {
            final errors = detail.map((e) => e['msg'] ?? '').join(', ');
            errorMessage = errors.isNotEmpty ? errors : errorMessage;
          } else if (detail is String) {
            errorMessage = detail;
          }
        } else if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
      }

      AppLoggerHelper.error('❌ Failed to create order: $errorMessage');
      throw Exception(errorMessage);
    } catch (e) {
      AppLoggerHelper.error('❌ Error creating order', e);
      throw Exception('Failed to create order: $e');
    }
  }
}
