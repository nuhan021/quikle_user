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

  /// Fetch food products from API
  /// [categoryId] - The category ID (1 for food)
  /// [subcategoryId] - Optional subcategory ID filter
  /// [offset] - Pagination offset (default: 0)
  /// [limit] - Number of items to fetch (default: 20)
  Future<List<ProductModel>> fetchFoodProducts({
    required String categoryId,
    String? subcategoryId,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'category': categoryId,
        'offset': offset.toString(),
        'limit': limit.toString(),
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

        final products = data
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();

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
  /// [limit] - Number of items to fetch (default: 20)
  Future<List<ProductModel>> fetchMedicineProducts({
    required String categoryId,
    String? subcategoryId,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'category': categoryId,
        'offset': offset.toString(),
        'limit': limit.toString(),
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
  /// [limit] - Number of items to fetch (default: 20)
  Future<List<ProductModel>> fetchGroceriesProducts({
    required String categoryId,
    String? subcategoryId,
    String? subSubcategoryId,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'category': categoryId,
        'offset': offset.toString(),
        'limit': limit.toString(),
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
    int limit = 20,
  }) async {
    print(
      '🔍 fetchMoreProducts - CategoryID: $categoryId, SubcategoryID: $subcategoryId, SubSubcategoryID: $subSubcategoryId, Offset: $offset, Limit: $limit',
    );

    if (categoryId == '1') {
      // Food category - use API
      print('🍔 Processing as FOOD category');
      try {
        final products = await fetchFoodProducts(
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          offset: offset,
          limit: limit,
        );

        // Check if there are more products by trying to fetch one more
        final hasMore = products.length == limit;

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
          limit: limit,
        );

        final hasMore = products.length == limit;

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
            limit: limit,
          );

          final hasMore = products.length == limit;

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
    // For food category (categoryId = '1'), fetch from API
    if (categoryId == '1') {
      return await fetchFoodProducts(categoryId: categoryId, limit: limit);
    }

    // For groceries and related categories (2: groceries, 3: cleaning, 4: personal care, 5: pet supplies)
    if (categoryId == '2' ||
        categoryId == '3' ||
        categoryId == '4' ||
        categoryId == '5') {
      return await fetchGroceriesProducts(categoryId: categoryId, limit: limit);
    }
    // For medicine category (categoryId = '6'), fetch from API
    if (categoryId == '6') {
      return await fetchMedicineProducts(categoryId: categoryId, limit: limit);
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
    print(
      '🔍 getProductsBySubcategory - SubcategoryID: $subcategoryId, CategoryID: $categoryId, SubSubcategoryID: $subSubcategoryId, Limit: $limit',
    );

    // If categoryId is provided, use it to determine which API to call
    if (categoryId != null) {
      if (categoryId == '1') {
        // Food category
        print('🍔 Fetching food products for subcategory: $subcategoryId');
        return await fetchFoodProducts(
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          limit: limit,
        );
      } else if (categoryId == '6') {
        // Medicine category
        print('💊 Fetching medicine products for subcategory: $subcategoryId');
        return await fetchMedicineProducts(
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          limit: limit,
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
          limit: limit,
        );
      }
    }

    // Fallback: Check for string prefixes (for backward compatibility with static data)
    // Food subcategories start with 'food_'
    if (subcategoryId.startsWith('food_')) {
      return await fetchFoodProducts(
        categoryId: '1',
        subcategoryId: subcategoryId,
        limit: limit,
      );
    }

    // Medicine subcategories start with 'medicine_'
    if (subcategoryId.startsWith('medicine_')) {
      return await fetchMedicineProducts(
        categoryId: '6',
        subcategoryId: subcategoryId,
        limit: limit,
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
        limit: limit,
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
}
