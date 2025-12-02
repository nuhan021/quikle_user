import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';

/// Service for caching category/subcategory initial products (first 9 items)
/// Cache persists until app is uninstalled (no expiry)
class CategoryCacheService {
  static CategoryCacheService? _instance;
  static const String _cachePrefix = 'category_cache_';
  static const String _subcategoryListPrefix = 'subcategory_list_';
  static const String _homeProductSectionsKey = 'home_product_sections';
  static const String _cacheTimestampPrefix = 'cache_timestamp_';

  CategoryCacheService._internal();

  factory CategoryCacheService() {
    _instance ??= CategoryCacheService._internal();
    return _instance!;
  }

  /// Generate cache key for category products
  String _getCacheKey(
    String categoryId,
    String? subcategoryId, [
    String? subSubcategoryId,
  ]) {
    if (subSubcategoryId != null && subcategoryId != null) {
      return '${_cachePrefix}${categoryId}_${subcategoryId}_$subSubcategoryId';
    }
    if (subcategoryId != null) {
      return '${_cachePrefix}${categoryId}_$subcategoryId';
    }
    return '${_cachePrefix}$categoryId';
  }

  /// Generate cache key for subcategory list
  String _getSubcategoryListKey(
    String categoryId, [
    String? parentSubcategoryId,
  ]) {
    if (parentSubcategoryId != null) {
      return '${_subcategoryListPrefix}${categoryId}_$parentSubcategoryId';
    }
    return '$_subcategoryListPrefix$categoryId';
  }

  /// Generate timestamp key
  String _getTimestampKey(String cacheKey) {
    return '$_cacheTimestampPrefix$cacheKey';
  }

  /// Check if cache is still valid (not expired)
  /// Cache never expires - always returns true if timestamp exists
  Future<bool> _isCacheValid(String cacheKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestampStr = prefs.getString(_getTimestampKey(cacheKey));

      // If timestamp exists, cache is valid (no expiry)
      return timestampStr != null;
    } catch (e) {
      AppLoggerHelper.error('Error checking cache validity', e);
      return false;
    }
  }

  /// Cache initial products for a category/subcategory/sub-subcategory
  Future<void> cacheProducts({
    required String categoryId,
    String? subcategoryId,
    String? subSubcategoryId,
    required List<ProductModel> products,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _getCacheKey(
        categoryId,
        subcategoryId,
        subSubcategoryId,
      );

      // Convert products to JSON
      final productsJson = products.map((p) => p.toJson()).toList();
      final jsonString = jsonEncode(productsJson);

      // Save to cache
      await prefs.setString(cacheKey, jsonString);

      // Save timestamp
      await prefs.setString(
        _getTimestampKey(cacheKey),
        DateTime.now().toIso8601String(),
      );

      AppLoggerHelper.debug(
        '💾 Cached ${products.length} products for category: $categoryId${subcategoryId != null ? ', subcategory: $subcategoryId' : ''}${subSubcategoryId != null ? ', sub-subcategory: $subSubcategoryId' : ''}',
      );
    } catch (e) {
      AppLoggerHelper.error('Error caching products', e);
    }
  }

  /// Get cached products for a category/subcategory/sub-subcategory
  Future<List<ProductModel>?> getCachedProducts({
    required String categoryId,
    String? subcategoryId,
    String? subSubcategoryId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _getCacheKey(
        categoryId,
        subcategoryId,
        subSubcategoryId,
      );

      // Check if cache exists
      if (!await _isCacheValid(cacheKey)) {
        AppLoggerHelper.debug('❌ No cache found for $cacheKey');
        return null;
      }

      final jsonString = prefs.getString(cacheKey);
      if (jsonString == null) {
        AppLoggerHelper.debug('❌ No cache data found for $cacheKey');
        return null;
      }

      // Parse JSON
      final List productsJson = jsonDecode(jsonString) as List;
      final products = productsJson
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();

      AppLoggerHelper.debug(
        '✅ Retrieved ${products.length} cached products for category: $categoryId${subcategoryId != null ? ', subcategory: $subcategoryId' : ''}${subSubcategoryId != null ? ', sub-subcategory: $subSubcategoryId' : ''}',
      );

      return products;
    } catch (e) {
      AppLoggerHelper.error('Error retrieving cached products', e);
      return null;
    }
  }

  /// Cache subcategory list for a category
  Future<void> cacheSubcategories({
    required String categoryId,
    String? parentSubcategoryId,
    required List<SubcategoryModel> subcategories,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _getSubcategoryListKey(categoryId, parentSubcategoryId);

      // Convert subcategories to JSON
      final subcategoriesJson = subcategories.map((s) => s.toJson()).toList();
      final jsonString = jsonEncode(subcategoriesJson);

      // Save to cache
      await prefs.setString(cacheKey, jsonString);

      // Save timestamp
      await prefs.setString(
        _getTimestampKey(cacheKey),
        DateTime.now().toIso8601String(),
      );

      AppLoggerHelper.debug(
        '💾 Cached ${subcategories.length} subcategories for category: $categoryId${parentSubcategoryId != null ? ', parent: $parentSubcategoryId' : ''}',
      );
    } catch (e) {
      AppLoggerHelper.error('Error caching subcategories', e);
    }
  }

  /// Get cached subcategories for a category
  Future<List<SubcategoryModel>?> getCachedSubcategories({
    required String categoryId,
    String? parentSubcategoryId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _getSubcategoryListKey(categoryId, parentSubcategoryId);

      // Check if cache exists
      if (!await _isCacheValid(cacheKey)) {
        AppLoggerHelper.debug('❌ No subcategory cache found for $cacheKey');
        return null;
      }

      final jsonString = prefs.getString(cacheKey);
      if (jsonString == null) {
        AppLoggerHelper.debug(
          '❌ No subcategory cache data found for $cacheKey',
        );
        return null;
      }

      // Parse JSON
      final List subcategoriesJson = jsonDecode(jsonString) as List;
      final subcategories = subcategoriesJson
          .map(
            (json) => SubcategoryModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      AppLoggerHelper.debug(
        '✅ Retrieved ${subcategories.length} cached subcategories for category: $categoryId${parentSubcategoryId != null ? ', parent: $parentSubcategoryId' : ''}',
      );

      return subcategories;
    } catch (e) {
      AppLoggerHelper.error('Error retrieving cached subcategories', e);
      return null;
    }
  }

  /// Clear cache for a specific category/subcategory
  Future<void> clearCache({
    required String categoryId,
    String? subcategoryId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _getCacheKey(categoryId, subcategoryId);

      await prefs.remove(cacheKey);
      await prefs.remove(_getTimestampKey(cacheKey));

      AppLoggerHelper.debug('🗑️ Cleared cache for $cacheKey');
    } catch (e) {
      AppLoggerHelper.error('Error clearing cache', e);
    }
  }

  /// Invalidate product cache for a specific product's category
  /// This will clear all cache entries for the product's category to ensure fresh data
  Future<void> invalidateProductCache(ProductModel product) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear cache for the product's category
      await clearCache(categoryId: product.categoryId);

      // Also clear cache for subcategory if it exists
      if (product.subcategoryId != null) {
        await clearCache(
          categoryId: product.categoryId,
          subcategoryId: product.subcategoryId,
        );
      }

      // Clear home product sections cache as well
      await prefs.remove(_homeProductSectionsKey);
      await prefs.remove(_getTimestampKey(_homeProductSectionsKey));

      AppLoggerHelper.debug(
        '🔄 Invalidated cache for product ${product.id} in category ${product.categoryId}',
      );
    } catch (e) {
      AppLoggerHelper.error('Error invalidating product cache', e);
    }
  }

  /// Clear all category caches
  Future<void> clearAllCaches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      final cacheKeys = keys.where(
        (key) =>
            key.startsWith(_cachePrefix) ||
            key.startsWith(_subcategoryListPrefix) ||
            key.startsWith(_cacheTimestampPrefix),
      );

      for (final key in cacheKeys) {
        await prefs.remove(key);
      }

      AppLoggerHelper.debug('🗑️ Cleared all category caches');
    } catch (e) {
      AppLoggerHelper.error('Error clearing all caches', e);
    }
  }

  /// Get cache statistics (for debugging)
  Future<Map<String, dynamic>> getCacheStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      final productCacheKeys = keys
          .where((key) => key.startsWith(_cachePrefix))
          .toList();
      final subcategoryCacheKeys = keys
          .where((key) => key.startsWith(_subcategoryListPrefix))
          .toList();

      int validCaches = 0;

      // All caches are valid (no expiry)
      for (final key in [...productCacheKeys, ...subcategoryCacheKeys]) {
        if (await _isCacheValid(key)) {
          validCaches++;
        }
      }

      return {
        'total_product_caches': productCacheKeys.length,
        'total_subcategory_caches': subcategoryCacheKeys.length,
        'valid_caches': validCaches,
        'cache_expiry_enabled': false,
      };
    } catch (e) {
      AppLoggerHelper.error('Error getting cache stats', e);
      return {};
    }
  }

  /// Cache home product sections (6 products per category)
  Future<void> cacheHomeProductSections(
    List<ProductSectionModel> sections,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert sections to JSON
      final sectionsJson = sections.map((s) => s.toJson()).toList();
      final jsonString = jsonEncode(sectionsJson);

      // Save to cache
      await prefs.setString(_homeProductSectionsKey, jsonString);

      // Save timestamp
      await prefs.setString(
        _getTimestampKey(_homeProductSectionsKey),
        DateTime.now().toIso8601String(),
      );

      AppLoggerHelper.debug(
        '💾 Cached ${sections.length} home product sections',
      );
    } catch (e) {
      AppLoggerHelper.error('Error caching home product sections', e);
    }
  }

  /// Get cached home product sections
  Future<List<ProductSectionModel>?> getCachedHomeProductSections() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if cache exists
      if (!await _isCacheValid(_homeProductSectionsKey)) {
        AppLoggerHelper.debug('❌ No home product sections cache found');
        return null;
      }

      final jsonString = prefs.getString(_homeProductSectionsKey);
      if (jsonString == null) {
        AppLoggerHelper.debug('❌ No home product sections data found');
        return null;
      }

      // Parse JSON
      final List sectionsJson = jsonDecode(jsonString) as List;
      final sections = sectionsJson
          .map(
            (json) =>
                ProductSectionModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      AppLoggerHelper.debug(
        '✅ Retrieved ${sections.length} cached home product sections',
      );

      return sections;
    } catch (e) {
      AppLoggerHelper.error('Error retrieving cached home product sections', e);
      return null;
    }
  }

  /// Clear home product sections cache
  Future<void> clearHomeProductSectionsCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(_homeProductSectionsKey);
      await prefs.remove(_getTimestampKey(_homeProductSectionsKey));

      AppLoggerHelper.debug('🗑️ Cleared home product sections cache');
    } catch (e) {
      AppLoggerHelper.error('Error clearing home product sections cache', e);
    }
  }
}
