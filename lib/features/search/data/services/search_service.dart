import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';

class SearchService {
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<Map<String, dynamic>> searchProducts({
    required String query,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'name': query,
        'offset': offset.toString(),
        'limit': limit.toString(),
      };

      final ResponseData response = await _networkCaller.getRequest(
        ApiConstants.searchItems,
        queryParams: queryParams,
      );

      if (response.isSuccess && response.responseData != null) {
        final responseMap = response.responseData as Map<String, dynamic>;

        if (responseMap['status'] == 'success') {
          final List<dynamic> data = responseMap['data'] ?? [];
          final products = data
              .map((json) => ProductModel.fromJson(json))
              .toList();

          return {
            'products': products,
            'total': responseMap['total'] ?? 0,
            'count': responseMap['count'] ?? 0,
            'offset': responseMap['offset'] ?? 0,
            'limit': responseMap['limit'] ?? limit,
          };
        } else {
          throw Exception(
            responseMap['message'] ?? 'Failed to search products',
          );
        }
      } else {
        throw Exception('Failed to search products');
      }
    } catch (e) {
      print('Error searching products: $e');
      rethrow;
    }
  }
}
