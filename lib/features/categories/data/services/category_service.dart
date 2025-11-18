import 'dart:async';
import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';
import 'package:quikle_user/features/categories/data/models/sub_subcategory_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/core/data/services/product_data_service.dart';

class CategoryService {
  final ProductDataService _productService = ProductDataService();
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<List<SubcategoryModel>> _fetchSubcategoriesFromApi(
    String categoryId,
  ) async {
    AppLoggerHelper.debug('User token is: ${StorageService.token}');
    AppLoggerHelper.debug(
      'User Refresh token is: ${StorageService.refreshToken}',
    );
    try {
      final url = ApiConstants.getSubcategoriesByCategory.replaceAll(
        '{category_id}',
        categoryId,
      );

      final ResponseData response = await _networkCaller.getRequest(url);

      if (response.isSuccess && response.responseData != null) {
        final responseMap = response.responseData as Map<String, dynamic>;
        final List data = responseMap['data'] as List;
        final subcategories = data
            .map((json) => SubcategoryModel.fromJson(json))
            .toList();
        return subcategories;
      }

      return [];
    } catch (e) {
      AppLoggerHelper.error('❌ Error fetching subcategories', e);
      return [];
    }
  }

  Future<List<SubSubcategoryModel>> fetchSubSubcategoriesBySubcategory(
    String subcategoryId,
  ) async {
    try {
      final url = ApiConstants.getSubSubcategoriesBySubcategory.replaceAll(
        '{subcategory_id}',
        subcategoryId,
      );

      AppLoggerHelper.debug('Fetching sub-subcategories from: $url');

      final ResponseData response = await _networkCaller.getRequest(url);

      if (response.isSuccess && response.responseData != null) {
        final responseMap = response.responseData as Map<String, dynamic>;
        final List data = responseMap['data'] as List;

        AppLoggerHelper.debug('Found ${data.length} sub-subcategories');

        final subSubcategories = data
            .map((json) => SubSubcategoryModel.fromJson(json))
            .toList();
        return subSubcategories;
      }

      AppLoggerHelper.warning('No sub-subcategories found or API call failed');
      return [];
    } catch (e) {
      AppLoggerHelper.error('❌ Error fetching sub-subcategories', e);
      return [];
    }
  }

  // ⚠️ DEPRECATED: These methods below are kept for backward compatibility
  // They will be removed once all controllers are updated to use the API

  Future<List<SubcategoryModel>> fetchGroceryMainCategories() async {
    return [
      const SubcategoryModel(
        id: 'grocery_produce',
        title: 'Produce',
        description: 'Fresh fruits and vegetables',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
      ),
      const SubcategoryModel(
        id: 'grocery_cooking',
        title: 'Cooking',
        description: 'Cooking essentials and ingredients',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
      ),
      const SubcategoryModel(
        id: 'grocery_meats',
        title: 'Meats',
        description: 'Fresh meat and poultry',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
      ),
      const SubcategoryModel(
        id: 'grocery_oils',
        title: 'Oils',
        description: 'Cooking oils and vinegars',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
      ),
      const SubcategoryModel(
        id: 'grocery_dairy',
        title: 'Dairy',
        description: 'Milk, cheese, and dairy products',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
      ),
      const SubcategoryModel(
        id: 'grocery_grains',
        title: 'Grains',
        description: 'Rice, flour, and cereals',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
      ),
    ];
  }

  Future<List<SubcategoryModel>> fetchProduceSubcategories() async {
    // This method is now generic - it gets the subcategory ID from the calling context
    // For backward compatibility, we return empty list
    // The proper way is to call fetchSubSubcategoriesBySubcategory with the actual subcategory ID
    return [];
  }

  Future<List<SubcategoryModel>> fetchCookingSubcategories() async {
    // Same as above - deprecated, returns empty
    return [];
  }

  Future<List<SubcategoryModel>> fetchMeatsSubcategories() async {
    // Same as above - deprecated, returns empty
    return [];
  }

  Future<List<SubcategoryModel>> fetchOilsSubcategories() async {
    // Same as above - deprecated, returns empty
    return [];
  }

  Future<List<SubcategoryModel>> fetchDairySubcategories() async {
    // Same as above - deprecated, returns empty
    return [];
  }

  Future<List<SubcategoryModel>> fetchGrainsSubcategories() async {
    // Same as above - deprecated, returns empty
    return [];
  }

  // New method to fetch sub-subcategories and convert to SubcategoryModel for UI compatibility
  Future<List<SubcategoryModel>> fetchSubSubcategoriesAsSubcategories(
    String subcategoryId,
  ) async {
    final subSubcategories = await fetchSubSubcategoriesBySubcategory(
      subcategoryId,
    );

    return subSubcategories
        .map(
          (subSub) => SubcategoryModel(
            id: subSub.id,
            title: subSub.name,
            description: subSub.description ?? '',
            iconPath: subSub.avatar,
            categoryId: subSub.subcategory.category.id,
            parentSubcategoryId: subSub.subcategory.id,
          ),
        )
        .toList();
  }

  Future<List<SubcategoryModel>> fetchSubcategories(
    String categoryId, {
    String? parentSubcategoryId,
  }) async {
    // For subcategories with parent (nested categories like grocery sub-subcategories)
    if (parentSubcategoryId != null) {
      // Fetch sub-subcategories and convert them to SubcategoryModel
      return fetchSubSubcategoriesAsSubcategories(parentSubcategoryId);
    }

    // For all categories, fetch subcategories from API
    return _fetchSubcategoriesFromApi(categoryId);
  }

  Future<List<ProductModel>> fetchProductsBySubcategory(
    String subcategoryId,
  ) async {
    return await _productService.getProductsBySubcategory(subcategoryId);
  }

  Future<List<SubcategoryModel>> fetchPopularSubcategories(
    String categoryId,
  ) async {
    // All subcategories are popular, so just return all subcategories
    return fetchSubcategories(categoryId);
  }

  Future<List<ProductModel>> fetchFeaturedProducts(
    String categoryId, {
    int limit = 9,
  }) async {
    return await _productService.getFeaturedProducts(categoryId, limit: limit);
  }

  Future<List<ProductModel>> fetchRecommendedProducts(
    String categoryId, {
    int limit = 9,
  }) async {
    return await _productService.getRecommendedProducts(
      categoryId,
      limit: limit,
    );
  }

  Future<List<ProductModel>> fetchProductsByMainCategory(
    String mainCategoryId, {
    int limit = 9,
  }) async {
    return _productService.getProductsByMainCategory(mainCategoryId);
  }

  Future<List<ProductModel>> fetchAllProductsByCategory(
    String categoryId, {
    int limit = 9,
  }) async {
    return await _productService.getProductsByCategory(
      categoryId,
      limit: limit,
    );
  }
}
