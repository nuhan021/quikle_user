import 'dart:async';
import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/core/data/services/product_data_service.dart';

class CategoryService {
  final ProductDataService _productService = ProductDataService();
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<List<SubcategoryModel>> _fetchSubcategoriesFromApi(
    String categoryId,
  ) async {
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
    return [
      const SubcategoryModel(
        id: 'produce_vegetables',
        title: 'Vegetables',
        description: 'Fresh vegetables',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_produce',
      ),
      const SubcategoryModel(
        id: 'produce_fruits',
        title: 'Fruits',
        description: 'Fresh fruits',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_produce',
      ),
      const SubcategoryModel(
        id: 'produce_herbs',
        title: 'Herbs',
        description: 'Fresh herbs and spices',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_produce',
      ),
      const SubcategoryModel(
        id: 'produce_packaged',
        title: 'Packaged',
        description: 'Pre-packaged produce items',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_produce',
      ),
    ];
  }

  Future<List<SubcategoryModel>> fetchSubcategories(
    String categoryId, {
    String? parentSubcategoryId,
  }) async {
    // For subcategories with parent (nested categories), use API with parent filter
    if (parentSubcategoryId != null) {
      // TODO: Implement API endpoint for nested subcategories if available
      // For now, return empty or implement nested logic
      return [];
    }

    // For all categories, fetch from API
    return _fetchSubcategoriesFromApi(categoryId);
  }

  Future<List<SubcategoryModel>> fetchCookingSubcategories() async {
    return [
      const SubcategoryModel(
        id: 'cooking_spices',
        title: 'Spices',
        description: 'Herbs and spices',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_cooking',
      ),
      const SubcategoryModel(
        id: 'cooking_condiments',
        title: 'Condiments',
        description: 'Sauces and condiments',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_cooking',
      ),
      const SubcategoryModel(
        id: 'cooking_baking',
        title: 'Baking',
        description: 'Baking ingredients',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_cooking',
      ),
      const SubcategoryModel(
        id: 'cooking_canned',
        title: 'Canned Foods',
        description: 'Canned and preserved foods',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_cooking',
      ),
    ];
  }

  Future<List<SubcategoryModel>> fetchMeatsSubcategories() async {
    return [
      const SubcategoryModel(
        id: 'meats_chicken',
        title: 'Chicken',
        description: 'Fresh chicken and poultry',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_meats',
      ),
      const SubcategoryModel(
        id: 'meats_beef',
        title: 'Beef',
        description: 'Fresh beef cuts',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_meats',
      ),
      const SubcategoryModel(
        id: 'meats_fish',
        title: 'Fish & Seafood',
        description: 'Fresh fish and seafood',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_meats',
      ),
      const SubcategoryModel(
        id: 'meats_processed',
        title: 'Processed Meats',
        description: 'Sausages, bacon, and deli meats',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_meats',
      ),
    ];
  }

  Future<List<SubcategoryModel>> fetchOilsSubcategories() async {
    return [
      const SubcategoryModel(
        id: 'oils_cooking',
        title: 'Cooking Oils',
        description: 'Cooking and frying oils',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_oils',
      ),
      const SubcategoryModel(
        id: 'oils_olive',
        title: 'Olive Oil',
        description: 'Extra virgin and regular olive oil',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_oils',
      ),
      const SubcategoryModel(
        id: 'oils_specialty',
        title: 'Specialty Oils',
        description: 'Coconut, sesame, and other specialty oils',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_oils',
      ),
      const SubcategoryModel(
        id: 'oils_vinegar',
        title: 'Vinegar',
        description: 'Cooking vinegars and dressings',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_oils',
      ),
    ];
  }

  Future<List<SubcategoryModel>> fetchDairySubcategories() async {
    return [
      const SubcategoryModel(
        id: 'dairy_milk',
        title: 'Milk',
        description: 'Fresh milk and alternatives',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_dairy',
      ),
      const SubcategoryModel(
        id: 'dairy_cheese',
        title: 'Cheese',
        description: 'Various types of cheese',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_dairy',
      ),
      const SubcategoryModel(
        id: 'dairy_yogurt',
        title: 'Yogurt',
        description: 'Greek yogurt, regular yogurt',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_dairy',
      ),
      const SubcategoryModel(
        id: 'dairy_eggs',
        title: 'Eggs',
        description: 'Fresh eggs and egg products',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_dairy',
      ),
    ];
  }

  Future<List<SubcategoryModel>> fetchGrainsSubcategories() async {
    return [
      const SubcategoryModel(
        id: 'grains_rice',
        title: 'Rice',
        description: 'Basmati, jasmine, and other rice varieties',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_grains',
      ),
      const SubcategoryModel(
        id: 'grains_flour',
        title: 'Flour',
        description: 'Wheat, almond, and specialty flours',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_grains',
      ),
      const SubcategoryModel(
        id: 'grains_cereal',
        title: 'Cereals',
        description: 'Breakfast cereals and oats',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_grains',
      ),
      const SubcategoryModel(
        id: 'grains_pasta',
        title: 'Pasta',
        description: 'Dried pasta and noodles',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_grains',
      ),
    ];
  }

  Future<List<ProductModel>> fetchProductsBySubcategory(
    String subcategoryId,
  ) async {
    return _productService.getProductsBySubcategory(subcategoryId);
  }

  Future<List<SubcategoryModel>> fetchPopularSubcategories(
    String categoryId,
  ) async {
    // All subcategories are popular, so just return all subcategories
    return fetchSubcategories(categoryId);
  }

  Future<List<ProductModel>> fetchFeaturedProducts(String categoryId) async {
    return _productService.getFeaturedProducts(categoryId);
  }

  Future<List<ProductModel>> fetchRecommendedProducts(String categoryId) async {
    return _productService.getRecommendedProducts(categoryId);
  }

  Future<List<ProductModel>> fetchProductsByMainCategory(
    String mainCategoryId,
  ) async {
    return _productService.getProductsByMainCategory(mainCategoryId);
  }

  Future<List<ProductModel>> fetchAllProductsByCategory(
    String categoryId,
  ) async {
    return _productService.getProductsByCategory(categoryId);
  }
}
