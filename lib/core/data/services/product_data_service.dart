import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';

/// Centralized service for managing all product data across the app
/// This ensures data consistency between home and category services
class ProductDataService {
  static ProductDataService? _instance;
  final NetworkCaller _networkCaller = NetworkCaller();

  ProductDataService._internal();

  factory ProductDataService() {
    _instance ??= ProductDataService._internal();
    return _instance!;
  }

  /// Ensures the limit is always a multiple of 3 for grid display
  int _ensureMultipleOfThree(int limit) {
    if (limit % 3 == 0) return limit;
    return ((limit / 3).ceil()) * 3;
  }

  /// Fetch food products from API
  /// [categoryId] - The category ID (1 for food)
  /// [subcategoryId] - Optional subcategory ID filter
  /// [offset] - Pagination offset (default: 0)
  /// [limit] - Number of items to fetch (default: 21 - multiple of 3)
  Future<List<ProductModel>> fetchFoodProducts({
    required String categoryId,
    String? subcategoryId,
    int offset = 0,
    int limit = 21,
  }) async {
    try {
      // Ensure limit is always a multiple of 3 for grid display
      final adjustedLimit = _ensureMultipleOfThree(limit);

      final queryParams = <String, dynamic>{
        'category': categoryId,
        'offset': offset.toString(),
        'limit': adjustedLimit.toString(),
      };

      if (subcategoryId != null) {
        queryParams['subcategory'] = subcategoryId;
      }

      AppLoggerHelper.debug('Fetching food products with params: $queryParams');

      // Create a custom network caller with longer timeout for cold starts
      final uri = Uri.parse(ApiConstants.getFoodProducts).replace(
        queryParameters: queryParams.map((k, v) => MapEntry(k, v.toString())),
      );

      AppLoggerHelper.debug('Full URL: $uri');

      final response = await _networkCaller.getRequest(
        ApiConstants.getFoodProducts,
        queryParams: queryParams,
      );

      if (response.isSuccess && response.responseData != null) {
        final responseMap = response.responseData as Map<String, dynamic>;
        final List data = responseMap['data'] as List;

        AppLoggerHelper.debug(
          'Fetched ${data.length} food products. Total: ${responseMap['total']}',
        );

        AppLoggerHelper.warning("Food data: $data");

        final products = data
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
        print("Food products: ${products[0].discountPercentage}");
        return products;
      }

      AppLoggerHelper.warning('No food products found or API call failed');
      return [];
    } catch (e) {
      AppLoggerHelper.error('❌ Error fetching food products', e);
      return [];
    }
  }

  /// Fetch medicine products from API
  /// [categoryId] - The category ID (should be '6' for medicine)
  /// [subcategoryId] - Optional subcategory ID filter
  /// [offset] - Pagination offset (default: 0)
  /// [limit] - Number of items to fetch (default: 21 - multiple of 3)
  Future<List<ProductModel>> fetchMedicineProducts({
    required String categoryId,
    String? subcategoryId,
    int offset = 0,
    int limit = 21,
  }) async {
    try {
      // Ensure limit is always a multiple of 3 for grid display
      final adjustedLimit = _ensureMultipleOfThree(limit);

      final queryParams = <String, dynamic>{
        'category': categoryId,
        'offset': offset.toString(),
        'limit': adjustedLimit.toString(),
      };

      if (subcategoryId != null) {
        queryParams['subcategory'] = subcategoryId;
      }

      AppLoggerHelper.debug(
        'Fetching medicine products with params: $queryParams',
      );

      // Create URI for debugging
      final uri = Uri.parse(ApiConstants.getMedicineProducts).replace(
        queryParameters: queryParams.map((k, v) => MapEntry(k, v.toString())),
      );

      AppLoggerHelper.debug('Full URL: $uri');

      final response = await _networkCaller.getRequest(
        ApiConstants.getMedicineProducts,
        queryParams: queryParams,
      );

      if (response.isSuccess && response.responseData != null) {
        final responseMap = response.responseData as Map<String, dynamic>;
        final List data = responseMap['data'] as List;

        AppLoggerHelper.debug(
          'Fetched ${data.length} medicine products. Total: ${responseMap['total']}',
        );

        final products = data
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();

        return products;
      }

      AppLoggerHelper.warning('No medicine products found or API call failed');
      return [];
    } catch (e) {
      AppLoggerHelper.error('❌ Error fetching medicine products', e);
      return [];
    }
  }

  /// Fetch groceries products from API
  /// [categoryId] - The category ID (2 for groceries)
  /// [subcategoryId] - Optional subcategory ID filter
  /// [offset] - Pagination offset (default: 0)
  /// [limit] - Number of items to fetch (default: 21 - multiple of 3)
  Future<List<ProductModel>> fetchGroceriesProducts({
    required String categoryId,
    String? subcategoryId,
    String? subSubcategoryId,
    int offset = 0,
    int limit = 21,
  }) async {
    try {
      // Ensure limit is always a multiple of 3 for grid display
      final adjustedLimit = _ensureMultipleOfThree(limit);

      final queryParams = <String, dynamic>{
        'category': categoryId,
        'offset': offset.toString(),
        'limit': adjustedLimit.toString(),
      };

      if (subcategoryId != null) {
        queryParams['subcategory'] = subcategoryId;
      }

      if (subSubcategoryId != null) {
        queryParams['sub_subcategory'] = subSubcategoryId;
      }

      AppLoggerHelper.debug(
        'Fetching groceries products with params: $queryParams',
      );

      final uri = Uri.parse(ApiConstants.getGroceriesProducts).replace(
        queryParameters: queryParams.map((k, v) => MapEntry(k, v.toString())),
      );

      AppLoggerHelper.debug('Full URL: $uri');

      final response = await _networkCaller.getRequest(
        ApiConstants.getGroceriesProducts,
        queryParams: queryParams,
      );

      if (response.isSuccess && response.responseData != null) {
        final responseMap = response.responseData as Map<String, dynamic>;
        final List data = responseMap['data'] as List;

        AppLoggerHelper.debug(
          'Fetched ${data.length} groceries products. Total: ${responseMap['total']}',
        );

        final products = data
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();

        return products;
      }

      AppLoggerHelper.warning('No groceries products found or API call failed');
      return [];
    } catch (e) {
      AppLoggerHelper.error('❌ Error fetching groceries products', e);
      return [];
    }
  }

  /// Fetch more products with pagination (for infinite scroll)
  /// Returns a tuple-like structure with products and hasMore flag
  Future<Map<String, dynamic>> fetchMoreProducts({
    required String categoryId,
    String? subcategoryId,
    String? subSubcategoryId,
    required int offset,
    int limit = 21,
  }) async {
    // Ensure limit is always a multiple of 3 for grid display
    final adjustedLimit = _ensureMultipleOfThree(limit);
    print(
      '🔍 fetchMoreProducts - CategoryID: $categoryId, SubcategoryID: $subcategoryId, SubSubcategoryID: $subSubcategoryId, Offset: $offset, Limit: $limit (adjusted: $adjustedLimit)',
    );

    if (categoryId == '1') {
      // Food category - use API
      print('🍔 Processing as FOOD category');
      try {
        final products = await fetchFoodProducts(
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          offset: offset,
          limit: adjustedLimit,
        );

        // Check if there are more products by trying to fetch one more
        final hasMore = products.length == adjustedLimit;

        print('✅ Food: Got ${products.length} products, hasMore: $hasMore');

        return {
          'products': products,
          'hasMore': hasMore,
          'nextOffset': offset + products.length,
        };
      } catch (e) {
        AppLoggerHelper.error('Error in fetchMoreProducts (food)', e);
        return {
          'products': <ProductModel>[],
          'hasMore': false,
          'nextOffset': offset,
        };
      }
    } else if (categoryId == '6') {
      // Medicine category - use API
      print('💊 Processing as MEDICINE category');
      try {
        final products = await fetchMedicineProducts(
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          offset: offset,
          limit: adjustedLimit,
        );

        final hasMore = products.length == adjustedLimit;

        print('✅ Medicine: Got ${products.length} products, hasMore: $hasMore');

        return {
          'products': products,
          'hasMore': hasMore,
          'nextOffset': offset + products.length,
        };
      } catch (e) {
        AppLoggerHelper.error('Error in fetchMoreProducts (medicine)', e);
        return {
          'products': <ProductModel>[],
          'hasMore': false,
          'nextOffset': offset,
        };
      }
    } else {
      // Groceries category - use API
      if (categoryId == '2' ||
          categoryId == '3' ||
          categoryId == '4' ||
          categoryId == '5') {
        print('🛒 Processing as GROCERIES/CLEANING/PERSONAL/PET category');
        // Groceries category - use API
        try {
          final products = await fetchGroceriesProducts(
            categoryId: categoryId,
            subcategoryId: subcategoryId,
            subSubcategoryId: subSubcategoryId,
            offset: offset,
            limit: adjustedLimit,
          );

          final hasMore = products.length == adjustedLimit;

          print(
            '✅ Groceries: Got ${products.length} products, hasMore: $hasMore',
          );

          return {
            'products': products,
            'hasMore': hasMore,
            'nextOffset': offset + products.length,
          };
        } catch (e) {
          AppLoggerHelper.error('Error in fetchMoreProducts (groceries)', e);
          print('❌ Groceries error: $e');
          return {
            'products': <ProductModel>[],
            'hasMore': false,
            'nextOffset': offset,
          };
        }
      }

      // For other categories not yet implemented with API, return empty
      print('⚠️ Category $categoryId not implemented with API');
      return {
        'products': <ProductModel>[],
        'hasMore': false,
        'nextOffset': offset,
      };
    }
  }

  // Helper methods for accessing products

  // Helper methods for accessing products
  Future<List<ProductModel>> getProductsByCategory(
    String categoryId, {
    int limit = 30,
  }) async {
    final adjustedLimit = _ensureMultipleOfThree(limit);

    if (categoryId == '1') {
      return await fetchFoodProducts(
        categoryId: categoryId,
        limit: adjustedLimit,
      );
    }

    if (categoryId == '2' ||
        categoryId == '3' ||
        categoryId == '4' ||
        categoryId == '5') {
      return await fetchGroceriesProducts(
        categoryId: categoryId,
        limit: adjustedLimit,
      );
    }

    if (categoryId == '6') {
      return await fetchMedicineProducts(
        categoryId: categoryId,
        limit: adjustedLimit,
      );
    }

    // For other categories not yet implemented, return empty list
    print('⚠️ Category $categoryId not yet implemented with API');
    return [];
  }

  Future<List<ProductModel>> getProductsBySubcategory(
    String subcategoryId, {
    int limit = 30,
    String? categoryId,
    String? subSubcategoryId,
  }) async {
    // Ensure limit is always a multiple of 3 for grid display
    final adjustedLimit = _ensureMultipleOfThree(limit);

    print(
      '🔍 getProductsBySubcategory - SubcategoryID: $subcategoryId, CategoryID: $categoryId, SubSubcategoryID: $subSubcategoryId, Limit: $limit (adjusted: $adjustedLimit)',
    );

    // If categoryId is provided, use it to determine which API to call
    if (categoryId != null) {
      if (categoryId == '1') {
        // Food category
        print('🍔 Fetching food products for subcategory: $subcategoryId');
        return await fetchFoodProducts(
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          limit: adjustedLimit,
        );
      } else if (categoryId == '6') {
        // Medicine category
        print('💊 Fetching medicine products for subcategory: $subcategoryId');
        return await fetchMedicineProducts(
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          limit: adjustedLimit,
        );
      } else if (categoryId == '2' ||
          categoryId == '3' ||
          categoryId == '4' ||
          categoryId == '5') {
        // Groceries/cleaning/personal/pet categories
        print(
          '🛒 Fetching groceries products for subcategory: $subcategoryId, subSubcategory: $subSubcategoryId',
        );
        return await fetchGroceriesProducts(
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          subSubcategoryId: subSubcategoryId,
          limit: adjustedLimit,
        );
      }
    }

    // Fallback: Check for string prefixes (for backward compatibility with static data)
    // Food subcategories start with 'food_'
    if (subcategoryId.startsWith('food_')) {
      return await fetchFoodProducts(
        categoryId: '1',
        subcategoryId: subcategoryId,
        limit: adjustedLimit,
      );
    }

    // Medicine subcategories start with 'medicine_'
    if (subcategoryId.startsWith('medicine_')) {
      return await fetchMedicineProducts(
        categoryId: '6',
        subcategoryId: subcategoryId,
        limit: adjustedLimit,
      );
    }

    // Grocery subcategories typically start with these prefixes
    final groceryPrefixes = [
      'produce_',
      'cooking_',
      'meats_',
      'oils_',
      'dairy_',
      'grains_',
      'grocery_',
    ];

    if (groceryPrefixes.any((p) => subcategoryId.startsWith(p))) {
      return await fetchGroceriesProducts(
        categoryId: '2',
        subcategoryId: subcategoryId,
        limit: adjustedLimit,
      );
    }

    // For other subcategories not yet implemented, return empty list
    print('⚠️ Subcategory $subcategoryId not yet implemented with API');
    return [];
  }

  List<ProductModel> getProductsByMainCategory(String mainCategoryId) {
    // All grocery main categories should fetch from API now
    print('⚠️ getProductsByMainCategory is deprecated - use API calls instead');
    return [];
  }

  Future<List<ProductModel>> getFeaturedProducts(
    String categoryId, {
    int limit = 6,
  }) async {
    final categoryProducts = await getProductsByCategory(categoryId);
    if (categoryId == '2') {
      // For groceries, prioritize produce items as featured
      final produceProducts = categoryProducts
          .where(
            (product) => product.subcategoryId?.startsWith('produce_') == true,
          )
          .toList();
      produceProducts.shuffle();
      return produceProducts.take(limit).toList();
    } else {
      categoryProducts.shuffle();
      return categoryProducts.take(limit).toList();
    }
  }

  Future<List<ProductModel>> getRecommendedProducts(
    String categoryId, {
    int limit = 8,
  }) async {
    final categoryProducts = await getProductsByCategory(categoryId);
    categoryProducts.shuffle();
    return categoryProducts.take(limit).toList();
  }

  Future<ProductModel?> getProductById(String id) async {
    try {
      final url = ApiConstants.getItemById.replaceFirst('{id}', id);
      AppLoggerHelper.debug('Fetching product by id: $id, URL: $url');

      final response = await _networkCaller.getRequest(url);

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData as Map<String, dynamic>;
        AppLoggerHelper.debug('Fetched product data: $data');
        return ProductModel.fromJson(data);
      }

      AppLoggerHelper.warning(
        'Product not found or API call failed for id: $id',
      );
      return null;
    } catch (e) {
      AppLoggerHelper.error('Error fetching product by id: $id', e);
      return null;
    }
  }
}
