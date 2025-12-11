import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';

/// Restaurant Products Service
///
/// Handles fetching products for a specific restaurant from the backend API.
class RestaurantProductsService {
  final NetworkCaller _networkCaller = NetworkCaller();

  /// Get products for a specific restaurant/vendor
  Future<List<ProductModel>> getRestaurantProducts({
    required String vendorId,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      AppLoggerHelper.debug(
        'Fetching products for vendor $vendorId (offset: $offset, limit: $limit)',
      );

      final queryParams = {
        'vendor_id': vendorId,
        'offset': offset.toString(),
        'limit': limit.toString(),
      };

      final ResponseData response = await _networkCaller.getRequest(
        ApiConstants.getRestaurantProducts,
        queryParams: queryParams,
      );

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData as Map<String, dynamic>;

        if (data['status'] == 'success' && data['data'] != null) {
          final productsList = data['data'] as List<dynamic>;

          final products = productsList
              .map(
                (json) => ProductModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();

          AppLoggerHelper.debug(
            '✅ Fetched ${products.length} products for vendor $vendorId',
          );
          return products;
        }
      }

      AppLoggerHelper.warning('No products found for vendor $vendorId');
      return [];
    } catch (e) {
      AppLoggerHelper.error('❌ Error fetching restaurant products', e);
      throw Exception('Failed to fetch restaurant products: $e');
    }
  }
}
