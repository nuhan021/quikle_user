import 'package:quikle_user/core/utils/constants/image_path.dart';
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
      return _getFallbackFoodProducts(subcategoryId);
    } catch (e) {
      AppLoggerHelper.error('❌ Error fetching food products', e);
      return _getFallbackFoodProducts(subcategoryId);
    }
  }

  /// Fallback to static food products if API fails
  List<ProductModel> _getFallbackFoodProducts(String? subcategoryId) {
    AppLoggerHelper.warning('Using fallback static food products');
    if (subcategoryId != null) {
      return allProducts
          .where((p) => p.categoryId == '1' && p.subcategoryId == subcategoryId)
          .toList();
    }
    return allProducts.where((p) => p.categoryId == '1').toList();
  }

  /// Fetch medicine products from API
  /// [categoryId] - The category ID (6 for medicine)
  /// [subcategoryId] - Optional subcategory ID filter
  /// [offset] - Pagination offset (default: 0)
  /// [limit] - Number of items to fetch (default: 20)
  Future<List<ProductModel>> fetchMedicineProducts({
    String? subcategoryId,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
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
      return _getFallbackMedicineProducts(subcategoryId);
    } catch (e) {
      AppLoggerHelper.error('❌ Error fetching medicine products', e);
      return _getFallbackMedicineProducts(subcategoryId);
    }
  }

  /// Fallback to static medicine products if API fails
  List<ProductModel> _getFallbackMedicineProducts(String? subcategoryId) {
    AppLoggerHelper.warning('Using fallback static medicine products');
    if (subcategoryId != null) {
      return allProducts
          .where((p) => p.categoryId == '6' && p.subcategoryId == subcategoryId)
          .toList();
    }
    return allProducts.where((p) => p.categoryId == '6').toList();
  }

  /// Fetch groceries products from API
  /// [categoryId] - The category ID (2 for groceries)
  /// [subcategoryId] - Optional subcategory ID filter
  /// [offset] - Pagination offset (default: 0)
  /// [limit] - Number of items to fetch (default: 20)
  Future<List<ProductModel>> fetchGroceriesProducts({
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
        // backend may expect a subcategory or sub_subcategory param; try using 'subcategory'
        queryParams['subcategory'] = subcategoryId;
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
      return _getFallbackGroceriesProducts(subcategoryId);
    } catch (e) {
      AppLoggerHelper.error('❌ Error fetching groceries products', e);
      return _getFallbackGroceriesProducts(subcategoryId);
    }
  }

  /// Fallback to static groceries products if API fails
  List<ProductModel> _getFallbackGroceriesProducts(String? subcategoryId) {
    AppLoggerHelper.warning('Using fallback static groceries products');
    if (subcategoryId != null) {
      return allProducts
          .where((p) => p.categoryId == '2' && p.subcategoryId == subcategoryId)
          .toList();
    }
    return allProducts.where((p) => p.categoryId == '2').toList();
  }

  /// Fetch more products with pagination (for infinite scroll)
  /// Returns a tuple-like structure with products and hasMore flag
  Future<Map<String, dynamic>> fetchMoreProducts({
    required String categoryId,
    String? subcategoryId,
    required int offset,
    int limit = 20,
  }) async {
    print(
      '🔍 fetchMoreProducts - CategoryID: $categoryId, SubcategoryID: $subcategoryId, Offset: $offset, Limit: $limit',
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

      print('📦 Processing as STATIC category');
      final allCategoryProducts = subcategoryId != null
          ? allProducts
                .where(
                  (p) =>
                      p.categoryId == categoryId &&
                      p.subcategoryId == subcategoryId,
                )
                .toList()
          : allProducts.where((p) => p.categoryId == categoryId).toList();

      final products = allCategoryProducts.skip(offset).take(limit).toList();
      final hasMore = offset + limit < allCategoryProducts.length;

      print('✅ Static: Got ${products.length} products, hasMore: $hasMore');

      return {
        'products': products,
        'hasMore': hasMore,
        'nextOffset': offset + products.length,
      };
    }
  }

  // All products data - single source of truth
  List<ProductModel> get allProducts => [
    // ===================== FOOD CATEGORY (Category ID: 1) =====================
    // Biryani subcategory
    const ProductModel(
      id: 'food_biryani_1',
      title: 'Chicken Biryani',
      description: 'Aromatic basmati rice with tender chicken pieces',
      price: '\$18',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      subcategoryId: 'food_biryani',
      shopId: 'restaurant_1',
      rating: 4.8,
      weight: '2 portions',
      productType: 'main_course',
    ),
    const ProductModel(
      id: 'food_biryani_2',
      title: 'Mutton Biryani',
      description: 'Rich and flavorful mutton biryani',
      price: '\$22',
      imagePath: ImagePath.biryaniDish,
      categoryId: '1',
      subcategoryId: 'food_biryani',
      shopId: 'restaurant_2', // Spice Garden
      rating: 4.9,
      weight: '2 portions',
      productType: 'main_course',
    ),
    const ProductModel(
      id: 'food_biryani_3',
      title: 'Vegetable Biryani',
      description: 'Fragrant rice with mixed vegetables and spices',
      price: '\$15',
      imagePath: ImagePath.tandooriDish,
      categoryId: '1',
      subcategoryId: 'food_biryani',
      shopId: 'restaurant_3', // Royal Kitchen
      rating: 4.6,
      weight: '2 portions',
      productType: 'main_course',
    ),
    const ProductModel(
      id: 'food_biryani_4',
      title: 'Fish Biryani',
      description: 'Delicious fish biryani with aromatic spices',
      price: '\$20',
      imagePath: ImagePath.pizzaDish,
      categoryId: '1',
      subcategoryId: 'food_biryani',
      shopId: 'restaurant_4', // Curry House
      rating: 4.7,
      weight: '2 portions',
      productType: 'main_course',
    ),

    // Appetizers
    const ProductModel(
      id: 'food_appetizer_1',
      title: 'Chicken Wings',
      description: 'Crispy chicken wings with spicy sauce',
      price: '\$12',
      imagePath: ImagePath.burgerDish,
      categoryId: '1',
      subcategoryId: 'food_appetizer',
      shopId: 'restaurant_1', // Masala Mandir
      rating: 4.5,
      weight: '6 pieces',
      productType: 'appetizer',
    ),
    const ProductModel(
      id: 'food_appetizer_2',
      title: 'Vegetable Samosa',
      description: 'Crispy pastry filled with spiced vegetables',
      price: '\$8',
      imagePath: ImagePath.pastaDish,
      categoryId: '1',
      subcategoryId: 'food_appetizer',
      shopId: 'restaurant_2', // Spice Garden
      rating: 4.4,
      weight: '4 pieces',
      productType: 'appetizer',
    ),
    const ProductModel(
      id: 'food_appetizer_3',
      title: 'Paneer Tikka',
      description: 'Grilled cottage cheese with mint chutney',
      price: '\$10',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      subcategoryId: 'food_appetizer',
      shopId: 'restaurant_3', // Royal Kitchen
      rating: 4.6,
      weight: '8 pieces',
      productType: 'appetizer',
    ),

    // Main Course - Pasta
    const ProductModel(
      id: 'food_pasta_1',
      title: 'Spaghetti Carbonara',
      description: 'Creamy pasta with bacon and cheese',
      price: '\$16',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      subcategoryId: 'food_pasta',
      shopId: 'restaurant_5', // Italian Corner
      rating: 4.7,
      weight: '1 portion',
      productType: 'main_course',
    ),
    const ProductModel(
      id: 'food_pasta_2',
      title: 'Penne Arrabbiata',
      description: 'Spicy tomato pasta with herbs',
      price: '\$14',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      subcategoryId: 'food_pasta',
      shopId: 'restaurant_5', // Italian Corner
      rating: 4.5,
      weight: '1 portion',
      productType: 'main_course',
    ),
    const ProductModel(
      id: 'food_pizza_1',
      title: 'Margherita Pizza',
      description: 'Classic tomato sauce with fresh mozzarella',
      price: '\$16',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      subcategoryId: 'food_pizza',
      shopId: 'restaurant_6', // Pizza Palace
      rating: 4.7,
      weight: 'Medium size',
      productType: 'main_course',
    ),
    const ProductModel(
      id: 'food_pizza_2',
      title: 'Pepperoni Pizza',
      description: 'Classic pepperoni with mozzarella cheese',
      price: '\$18',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      subcategoryId: 'food_pizza',
      shopId: 'restaurant_6', // Pizza Palace
      rating: 4.6,
      weight: 'Medium size',
      productType: 'main_course',
    ),
    const ProductModel(
      id: 'food_burger_1',
      title: 'Classic Beef Burger',
      description: 'Juicy beef patty with lettuce and tomato',
      price: '\$14',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      subcategoryId: 'food_burger',
      shopId: 'restaurant_7', // Burger House
      rating: 4.5,
      weight: '1 burger',
      productType: 'main_course',
    ),
    const ProductModel(
      id: 'food_burger_2',
      title: 'Chicken Burger',
      description: 'Grilled chicken breast with special sauce',
      price: '\$12',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      subcategoryId: 'food_burger',
      shopId: 'restaurant_7', // Burger House
      rating: 4.4,
      weight: '1 burger',
      productType: 'main_course',
    ),

    // Breads
    const ProductModel(
      id: 'food_bread_1',
      title: 'Garlic Naan',
      description: 'Fresh baked garlic naan bread',
      price: '\$4',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      subcategoryId: 'food_bread',
      shopId: 'restaurant_1', // Masala Mandir
      rating: 4.6,
      weight: '2 pieces',
      productType: 'bread',
    ),
    const ProductModel(
      id: 'food_bread_2',
      title: 'Butter Roti',
      description: 'Soft whole wheat bread with butter',
      price: '\$3',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      subcategoryId: 'food_bread',
      shopId: 'restaurant_2', // Spice Garden
      rating: 4.3,
      weight: '3 pieces',
      productType: 'bread',
    ),

    // Desserts
    const ProductModel(
      id: 'food_dessert_1',
      title: 'Chocolate Ice Cream',
      description: 'Rich chocolate ice cream with nuts',
      price: '\$6',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      subcategoryId: 'food_dessert',
      shopId: 'restaurant_8', // Sweet Corner
      rating: 4.7,
      weight: '2 scoops',
      productType: 'dessert',
    ),
    const ProductModel(
      id: 'food_dessert_2',
      title: 'Gulab Jamun',
      description: 'Traditional Indian sweet in sugar syrup',
      price: '\$5',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      subcategoryId: 'food_dessert',
      shopId: 'restaurant_1', // Masala Mandir
      rating: 4.8,
      weight: '4 pieces',
      productType: 'dessert',
    ),

    // Beverages
    const ProductModel(
      id: 'food_beverage_1',
      title: 'Fresh Lime Soda',
      description: 'Refreshing lime soda with mint',
      price: '\$4',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      subcategoryId: 'food_beverage',
      shopId: 'restaurant_9', // Drinks Hub
      rating: 4.2,
      weight: '300ml',
      productType: 'beverage',
    ),
    const ProductModel(
      id: 'food_beverage_2',
      title: 'Mango Lassi',
      description: 'Creamy yogurt drink with mango flavor',
      price: '\$5',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      subcategoryId: 'food_beverage',
      shopId: 'restaurant_2', // Spice Garden
      rating: 4.5,
      weight: '250ml',
      productType: 'beverage',
    ),

    // ===================== GROCERIES CATEGORY (Category ID: 2) =====================
    const ProductModel(
      id: 'food_sandwich_1',
      title: 'Club Sandwich',
      description: 'Triple layer sandwich with chicken and bacon',
      price: '\$12',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      subcategoryId: 'food_sandwich',
      shopId: 'restaurant_10', // Sandwich Station
      rating: 4.4,
      weight: '1 sandwich',
      productType: 'main_course',
    ),
    const ProductModel(
      id: 'food_salad_1',
      title: 'Caesar Salad',
      description: 'Fresh romaine with Caesar dressing',
      price: '\$10',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      subcategoryId: 'food_salad',
      shopId: 'restaurant_11', // Fresh Greens
      rating: 4.3,
      weight: 'Large bowl',
      productType: 'appetizer',
    ),

    // ===================== GROCERY CATEGORY (Category ID: 2) =====================

    // Produce - Vegetables subcategory
    const ProductModel(
      id: 'produce_vegetables_1',
      title: 'Fresh Tomatoes',
      description: 'Organic red tomatoes',
      price: '\$3',
      imagePath: ImagePath.milk,
      categoryId: '2',
      subcategoryId: 'produce_vegetables',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '1kg',
      productType: 'vegetable',
    ),
    const ProductModel(
      id: 'produce_vegetables_2',
      title: 'Green Spinach',
      description: 'Fresh organic spinach leaves',
      price: '\$2',
      imagePath: ImagePath.riceIcon,
      categoryId: '2',
      subcategoryId: 'produce_vegetables',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '500g',
      productType: 'vegetable',
    ),
    const ProductModel(
      id: 'produce_vegetables_3',
      title: 'Red Onions',
      description: 'Fresh red onions',
      price: '\$2',
      imagePath: ImagePath.banana,
      categoryId: '2',
      subcategoryId: 'produce_vegetables',
      shopId: 'shop_2',
      rating: 4.4,
      weight: '1kg',
      productType: 'vegetable',
    ),
    const ProductModel(
      id: 'produce_vegetables_4',
      title: 'Green Capsicum',
      description: 'Fresh bell peppers',
      price: '\$4',
      imagePath: ImagePath.bread,
      categoryId: '2',
      subcategoryId: 'produce_vegetables',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '500g',
    ),
    const ProductModel(
      id: 'produce_vegetables_5',
      title: 'Fresh Carrots',
      description: 'Organic carrots',
      price: '\$2',
      imagePath: ImagePath.chickenBreast,
      categoryId: '2',
      subcategoryId: 'produce_vegetables',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '1kg',
    ),
    const ProductModel(
      id: 'produce_vegetables_6',
      title: 'Cauliflower',
      description: 'Fresh cauliflower head',
      price: '\$3',
      imagePath: ImagePath.eggs,
      categoryId: '2',
      subcategoryId: 'produce_vegetables',
      shopId: 'shop_2',
      rating: 4.4,
      weight: '1 piece',
    ),

    // Produce - Fruits subcategory
    const ProductModel(
      id: 'produce_fruits_1',
      title: 'Fresh Bananas',
      description: 'Sweet yellow bananas',
      price: '\$2',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'produce_fruits',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '1kg',
    ),
    const ProductModel(
      id: 'produce_fruits_2',
      title: 'Red Apples',
      description: 'Crispy red apples',
      price: '\$4',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'produce_fruits',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '1kg',
    ),
    const ProductModel(
      id: 'produce_fruits_3',
      title: 'Fresh Oranges',
      description: 'Juicy navel oranges',
      price: '\$3',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'produce_fruits',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '1kg',
    ),
    const ProductModel(
      id: 'produce_fruits_4',
      title: 'Green Grapes',
      description: 'Sweet seedless grapes',
      price: '\$5',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'produce_fruits',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '500g',
    ),
    const ProductModel(
      id: 'produce_fruits_5',
      title: 'Fresh Mangoes',
      description: 'Ripe mangoes',
      price: '\$6',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'produce_fruits',
      shopId: 'shop_2',
      rating: 4.8,
      weight: '1kg',
    ),
    const ProductModel(
      id: 'produce_fruits_6',
      title: 'Avocados',
      description: 'Fresh ripe avocados',
      price: '\$7',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'produce_fruits',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '3 pieces',
    ),

    // Produce - Herbs subcategory
    const ProductModel(
      id: 'produce_herbs_1',
      title: 'Fresh Cilantro',
      description: 'Fresh coriander leaves',
      price: '\$1',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'produce_herbs',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '100g',
    ),
    const ProductModel(
      id: 'produce_herbs_2',
      title: 'Fresh Mint',
      description: 'Fresh mint leaves',
      price: '\$1',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'produce_herbs',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '100g',
    ),
    const ProductModel(
      id: 'produce_herbs_3',
      title: 'Fresh Basil',
      description: 'Sweet basil leaves',
      price: '\$2',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'produce_herbs',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '50g',
    ),

    // Cooking - Spices subcategory
    const ProductModel(
      id: 'cooking_spices_1',
      title: 'Turmeric Powder',
      description: 'Pure turmeric powder',
      price: '\$3',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'cooking_spices',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '200g',
    ),
    const ProductModel(
      id: 'cooking_spices_2',
      title: 'Red Chili Powder',
      description: 'Hot red chili powder',
      price: '\$4',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'cooking_spices',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '200g',
    ),
    const ProductModel(
      id: 'cooking_spices_3',
      title: 'Cumin Seeds',
      description: 'Whole cumin seeds',
      price: '\$5',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'cooking_spices',
      shopId: 'shop_2',
      rating: 4.8,
      weight: '100g',
    ),
    const ProductModel(
      id: 'cooking_spices_4',
      title: 'Garam Masala',
      description: 'Traditional spice blend',
      price: '\$6',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'cooking_spices',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '100g',
    ),

    // Cooking - Condiments subcategory
    const ProductModel(
      id: 'cooking_condiments_1',
      title: 'Tomato Ketchup',
      description: 'Premium tomato ketchup',
      price: '\$3',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'cooking_condiments',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '400g',
    ),
    const ProductModel(
      id: 'cooking_condiments_2',
      title: 'Soy Sauce',
      description: 'Dark soy sauce',
      price: '\$4',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'cooking_condiments',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '500ml',
    ),
    const ProductModel(
      id: 'cooking_condiments_3',
      title: 'Mustard Sauce',
      description: 'Dijon mustard',
      price: '\$5',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'cooking_condiments',
      shopId: 'shop_2',
      rating: 4.4,
      weight: '250g',
    ),

    // Dairy - Milk subcategory
    const ProductModel(
      id: 'dairy_milk_1',
      title: 'Whole Milk',
      description: 'Fresh whole milk',
      price: '\$4',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'dairy_milk',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '1 liter',
    ),
    const ProductModel(
      id: 'dairy_milk_2',
      title: 'Skim Milk',
      description: 'Low-fat skim milk',
      price: '\$4',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'dairy_milk',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '1 liter',
    ),
    const ProductModel(
      id: 'dairy_milk_3',
      title: 'Almond Milk',
      description: 'Unsweetened almond milk',
      price: '\$6',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'dairy_milk',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '1 liter',
    ),

    // Dairy - Cheese subcategory
    const ProductModel(
      id: 'dairy_cheese_1',
      title: 'Cheddar Cheese',
      description: 'Aged cheddar cheese block',
      price: '\$8',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'dairy_cheese',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '400g',
    ),
    const ProductModel(
      id: 'dairy_cheese_2',
      title: 'Mozzarella Cheese',
      description: 'Fresh mozzarella',
      price: '\$7',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'dairy_cheese',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '250g',
    ),
    const ProductModel(
      id: 'dairy_cheese_3',
      title: 'Cream Cheese',
      description: 'Soft cream cheese',
      price: '\$5',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'dairy_cheese',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '200g',
    ),

    // Dairy - Yogurt subcategory
    const ProductModel(
      id: 'dairy_yogurt_1',
      title: 'Greek Yogurt',
      description: 'Plain Greek yogurt',
      price: '\$5',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'dairy_yogurt',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '500g',
    ),
    const ProductModel(
      id: 'dairy_yogurt_2',
      title: 'Strawberry Yogurt',
      description: 'Fruit yogurt with strawberry',
      price: '\$4',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'dairy_yogurt',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '400g',
    ),

    // Dairy - Eggs subcategory
    const ProductModel(
      id: 'dairy_eggs_1',
      title: 'Free Range Eggs',
      description: 'Farm fresh free range eggs',
      price: '\$6',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'dairy_eggs',
      shopId: 'shop_2',
      rating: 4.8,
      weight: '12 pieces',
    ),
    const ProductModel(
      id: 'dairy_eggs_2',
      title: 'Organic Eggs',
      description: 'Certified organic eggs',
      price: '\$8',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'dairy_eggs',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '12 pieces',
    ),

    // Grains - Rice subcategory
    const ProductModel(
      id: 'grains_rice_1',
      title: 'Basmati Rice',
      description: 'Long grain basmati rice',
      price: '\$8',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'grains_rice',
      shopId: 'shop_2',
      rating: 4.8,
      weight: '2kg',
    ),
    const ProductModel(
      id: 'grains_rice_2',
      title: 'Jasmine Rice',
      description: 'Fragrant jasmine rice',
      price: '\$7',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'grains_rice',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '2kg',
    ),
    const ProductModel(
      id: 'grains_rice_3',
      title: 'Brown Rice',
      description: 'Healthy brown rice',
      price: '\$6',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'grains_rice',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '1kg',
    ),

    // Grains - Flour subcategory
    const ProductModel(
      id: 'grains_flour_1',
      title: 'Wheat Flour',
      description: 'Premium all-purpose flour',
      price: '\$4',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'grains_flour',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '1kg',
    ),
    const ProductModel(
      id: 'grains_flour_2',
      title: 'Almond Flour',
      description: 'Fine almond flour',
      price: '\$12',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'grains_flour',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '500g',
    ),

    // Grains - Cereal subcategory
    const ProductModel(
      id: 'grains_cereal_1',
      title: 'Oats',
      description: 'Rolled oats for breakfast',
      price: '\$5',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'grains_cereal',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '500g',
    ),
    const ProductModel(
      id: 'grains_cereal_2',
      title: 'Corn Flakes',
      description: 'Crispy corn flakes',
      price: '\$4',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'grains_cereal',
      shopId: 'shop_2',
      rating: 4.4,
      weight: '400g',
    ),

    // Meats - Chicken subcategory
    const ProductModel(
      id: 'meats_chicken_1',
      title: 'Chicken Breast',
      description: 'Fresh boneless chicken breast',
      price: '\$12',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'meats_chicken',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '1kg',
    ),
    const ProductModel(
      id: 'meats_chicken_2',
      title: 'Chicken Thighs',
      description: 'Fresh chicken thighs',
      price: '\$10',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'meats_chicken',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '1kg',
    ),
    const ProductModel(
      id: 'meats_chicken_3',
      title: 'Whole Chicken',
      description: 'Fresh whole chicken',
      price: '\$15',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'meats_chicken',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '1.5kg',
    ),

    // Meats - Beef subcategory
    const ProductModel(
      id: 'meats_beef_1',
      title: 'Ground Beef',
      description: 'Fresh ground beef',
      price: '\$15',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'meats_beef',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '500g',
    ),
    const ProductModel(
      id: 'meats_beef_2',
      title: 'Beef Steak',
      description: 'Premium beef steaks',
      price: '\$25',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'meats_beef',
      shopId: 'shop_2',
      rating: 4.8,
      weight: '400g',
    ),

    // Meats - Fish subcategory
    const ProductModel(
      id: 'meats_fish_1',
      title: 'Salmon Fillet',
      description: 'Fresh salmon fillet',
      price: '\$20',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'meats_fish',
      shopId: 'shop_2',
      rating: 4.8,
      weight: '500g',
    ),
    const ProductModel(
      id: 'meats_fish_2',
      title: 'Shrimp',
      description: 'Fresh large shrimp',
      price: '\$18',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'meats_fish',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '500g',
    ),

    // Oils - Cooking subcategory
    const ProductModel(
      id: 'oils_cooking_1',
      title: 'Sunflower Oil',
      description: 'Refined sunflower cooking oil',
      price: '\$6',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'oils_cooking',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '1 liter',
    ),
    const ProductModel(
      id: 'oils_cooking_2',
      title: 'Canola Oil',
      description: 'Heart healthy canola oil',
      price: '\$7',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'oils_cooking',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '1 liter',
    ),

    // Oils - Olive Oil subcategory
    const ProductModel(
      id: 'oils_olive_1',
      title: 'Extra Virgin Olive Oil',
      description: 'Premium extra virgin olive oil',
      price: '\$12',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'oils_olive',
      shopId: 'shop_2',
      rating: 4.8,
      weight: '500ml',
    ),
    const ProductModel(
      id: 'oils_olive_2',
      title: 'Regular Olive Oil',
      description: 'Pure olive oil for cooking',
      price: '\$8',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'oils_olive',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '500ml',
    ),

    // Legacy grocery products (keeping for compatibility)
    const ProductModel(
      id: 'grocery_vegetables_1',
      title: 'Fresh Tomatoes',
      description: 'Organic red tomatoes',
      price: '\$3',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'grocery_vegetables',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '1kg',
    ),
    const ProductModel(
      id: 'grocery_vegetables_2',
      title: 'Green Spinach',
      description: 'Fresh organic spinach leaves',
      price: '\$2',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'grocery_vegetables',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '500g',
    ),
    const ProductModel(
      id: 'grocery_fruits_1',
      title: 'Fresh Banana',
      description: 'Sweet yellow bananas',
      price: '\$2',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'grocery_fruits',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '1kg bunch',
    ),
    const ProductModel(
      id: 'grocery_fruits_2',
      title: 'Red Apples',
      description: 'Crispy red apples',
      price: '\$4',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'grocery_fruits',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '1kg',
    ),
    const ProductModel(
      id: 'grocery_dairy_1',
      title: 'Organic Milk',
      description: 'Fresh organic milk',
      price: '\$5',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'grocery_dairy',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '1 liter',
    ),
    const ProductModel(
      id: 'grocery_dairy_2',
      title: 'Cheddar Cheese',
      description: 'Aged cheddar cheese block',
      price: '\$8',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'grocery_dairy',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '400g',
    ),
    const ProductModel(
      id: 'grocery_grains_1',
      title: 'Wheat Flour',
      description: 'Premium wheat flour',
      price: '\$4',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'grocery_grains',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '1kg pack',
    ),
    const ProductModel(
      id: 'grocery_grains_2',
      title: 'Basmati Rice',
      description: 'Long grain basmati rice',
      price: '\$6',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'grocery_grains',
      shopId: 'shop_2',
      rating: 4.8,
      weight: '2kg pack',
    ),
    const ProductModel(
      id: 'grocery_meat_1',
      title: 'Chicken Breast',
      description: 'Fresh boneless chicken breast',
      price: '\$12',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'grocery_meat',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '1kg',
    ),
    const ProductModel(
      id: 'grocery_beverages_1',
      title: 'Orange Juice',
      description: 'Fresh squeezed orange juice',
      price: '\$4',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      subcategoryId: 'grocery_beverages',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '1 liter',
    ),

    // ===================== MEDICINE CATEGORY (Category ID: 6) =====================
    // OTC Pain Relief
    const ProductModel(
      id: 'medicine_pain_1',
      title: 'Paracetamol',
      description: 'Pain relief tablets',
      price: '\$5',
      imagePath: ImagePath.paracetamol,
      categoryId: '6',
      subcategoryId: 'medicine_otc',
      shopId: 'shop_3',
      rating: 4.4,
      weight: '20 tablets',
      isOTC: true,
    ),
    const ProductModel(
      id: 'medicine_pain_2',
      title: 'Aspirin',
      description: 'Anti-inflammatory pain reliever',
      price: '\$6',
      imagePath: ImagePath.antacid,
      categoryId: '6',
      subcategoryId: 'medicine_otc',
      shopId: 'shop_3',
      rating: 4.3,
      weight: '30 tablets',
      isOTC: true,
    ),
    // OTC Vitamins
    const ProductModel(
      id: 'medicine_vitamins_1',
      title: 'Vitamin C',
      description: 'Immune support vitamins',
      price: '\$8',
      imagePath: ImagePath.syrup,
      categoryId: '6',
      subcategoryId: 'medicine_vitamins',
      shopId: 'shop_3',
      rating: 4.7,
      weight: '60 capsules',
      isOTC: true,
    ),
    const ProductModel(
      id: 'medicine_vitamins_2',
      title: 'Multivitamin',
      description: 'Complete daily vitamin supplement',
      price: '\$12',
      imagePath: ImagePath.vitaminC,
      categoryId: '6',
      subcategoryId: 'medicine_vitamins',
      shopId: 'shop_3',
      rating: 4.6,
      weight: '90 tablets',
      isOTC: true,
    ),
    // OTC Cold & Flu
    const ProductModel(
      id: 'medicine_cold_1',
      title: 'Throat Lozenges',
      description: 'Soothing throat lozenges',
      price: '\$4',
      imagePath: ImagePath.vitaminC,
      categoryId: '6',
      subcategoryId: 'medicine_otc',
      shopId: 'shop_3',
      rating: 4.2,
      weight: '12 pieces',
      isOTC: true,
    ),
    const ProductModel(
      id: 'medicine_cold_2',
      title: 'Nasal Spray',
      description: 'Decongestant nasal spray',
      price: '\$7',
      imagePath: ImagePath.allergy,
      categoryId: '6',
      subcategoryId: 'medicine_otc',
      shopId: 'shop_3',
      rating: 4.1,
      weight: '15ml',
      isOTC: true,
    ),
    // First Aid Supplies
    const ProductModel(
      id: 'medicine_firstaid_1',
      title: 'First Aid Kit',
      description: 'Complete first aid supplies',
      price: '\$15',
      imagePath: ImagePath.vitaminC,
      categoryId: '6',
      subcategoryId: 'medicine_firstaid',
      shopId: 'shop_3',
      rating: 4.6,
      weight: '1 kit',
      isOTC: true,
    ),
    const ProductModel(
      id: 'medicine_firstaid_2',
      title: 'Bandages',
      description: 'Adhesive bandages pack',
      price: '\$3',
      imagePath: ImagePath.vitaminC,
      categoryId: '6',
      subcategoryId: 'medicine_firstaid',
      shopId: 'shop_3',
      rating: 4.4,
      weight: '20 pieces',
      isOTC: true,
    ),
    // OTC Digestive Health
    const ProductModel(
      id: 'medicine_antiseptic_1',
      title: 'Antiseptic Cream',
      description: 'Wound healing antiseptic',
      price: '\$6',
      imagePath: ImagePath.vitaminC,
      categoryId: '6',
      subcategoryId: 'medicine_otc',
      shopId: 'shop_3',
      rating: 4.5,
      weight: '25g tube',
      isOTC: true,
    ),
    const ProductModel(
      id: 'medicine_digestion_1',
      title: 'Antacid Tablets',
      description: 'Relief from acidity and heartburn',
      price: '\$5',
      imagePath: ImagePath.vitaminC,
      categoryId: '6',
      subcategoryId: 'medicine_otc',
      shopId: 'shop_3',
      rating: 4.3,
      weight: '10 tablets',
      isOTC: true,
    ),

    // ===================== CLEANING CATEGORY (Category ID: 4) =====================
    const ProductModel(
      id: 'cleaning_household_1',
      title: 'All Purpose Cleaner',
      description: 'Multi-surface cleaning spray',
      price: '\$8',
      imagePath: ImagePath.cleaningSpray,
      categoryId: '3',
      subcategoryId: 'cleaning_household',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '500ml',
    ),
    const ProductModel(
      id: 'cleaning_household_2',
      title: 'Glass Cleaner',
      description: 'Streak-free glass cleaning solution',
      price: '\$6',
      imagePath: ImagePath.glassCleaner,
      categoryId: '3',
      subcategoryId: 'cleaning_household',
      shopId: 'shop_2',
      rating: 4.4,
      weight: '400ml',
    ),
    const ProductModel(
      id: 'cleaning_bathroom_1',
      title: 'Bathroom Cleaner',
      description: 'Specialized bathroom cleaning solution',
      price: '\$9',
      imagePath: ImagePath.dishWashing,
      categoryId: '3',
      subcategoryId: 'cleaning_bathroom',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '750ml',
    ),
    const ProductModel(
      id: 'cleaning_bathroom_2',
      title: 'Toilet Bowl Cleaner',
      description: 'Powerful toilet cleaning gel',
      price: '\$7',
      imagePath: ImagePath.mop,
      categoryId: '3',
      subcategoryId: 'cleaning_bathroom',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '500ml',
    ),
    const ProductModel(
      id: 'cleaning_kitchen_1',
      title: 'Dish Soap',
      description: 'Effective dishwashing liquid',
      price: '\$6',
      imagePath: ImagePath.cleaningIcon,
      categoryId: '3',
      subcategoryId: 'cleaning_kitchen',
      shopId: 'shop_2',
      rating: 4.4,
      weight: '500ml',
    ),
    const ProductModel(
      id: 'cleaning_kitchen_2',
      title: 'Kitchen Degreaser',
      description: 'Heavy duty grease remover',
      price: '\$10',
      imagePath: ImagePath.cleaningIcon,
      categoryId: '3',
      subcategoryId: 'cleaning_kitchen',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '600ml',
    ),
    const ProductModel(
      id: 'cleaning_laundry_1',
      title: 'Laundry Detergent',
      description: 'Concentrated laundry washing powder',
      price: '\$12',
      imagePath: ImagePath.cleaningIcon,
      categoryId: '3',
      subcategoryId: 'cleaning_laundry',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '2kg pack',
    ),
    const ProductModel(
      id: 'cleaning_laundry_2',
      title: 'Fabric Softener',
      description: 'Gentle fabric conditioning liquid',
      price: '\$8',
      imagePath: ImagePath.cleaningIcon,
      categoryId: '3',
      subcategoryId: 'cleaning_laundry',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '1 liter',
    ),
    const ProductModel(
      id: 'cleaning_floor_1',
      title: 'Floor Cleaner',
      description: 'Multi-surface floor cleaning solution',
      price: '\$9',
      imagePath: ImagePath.cleaningIcon,
      categoryId: '3',
      subcategoryId: 'cleaning_floor',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '1 liter',
    ),
    const ProductModel(
      id: 'cleaning_disinfectant_1',
      title: 'Disinfectant Spray',
      description: 'Kills 99.9% of germs and bacteria',
      price: '\$11',
      imagePath: ImagePath.cleaningIcon,
      categoryId: '3',
      subcategoryId: 'cleaning_disinfectant',
      shopId: 'shop_2',
      rating: 4.8,
      weight: '400ml',
    ),

    // ===================== PERSONAL CARE CATEGORY (Category ID: 4) =====================
    const ProductModel(
      id: 'personal_skincare_1',
      title: 'Face Moisturizer',
      description: 'Hydrating face cream',
      price: '\$12',
      imagePath: ImagePath.lipBalm,
      categoryId: '4',
      subcategoryId: 'personal_skincare',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '100ml',
    ),
    const ProductModel(
      id: 'personal_skincare_2',
      title: 'Face Wash',
      description: 'Gentle daily face cleanser',
      price: '\$8',
      imagePath: ImagePath.shampoo,
      categoryId: '4',
      subcategoryId: 'personal_skincare',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '150ml',
    ),
    const ProductModel(
      id: 'personal_haircare_1',
      title: 'Hair Shampoo',
      description: 'Nourishing hair shampoo',
      price: '\$10',
      imagePath: ImagePath.moisturizer,
      categoryId: '4',
      subcategoryId: 'personal_haircare',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '400ml',
    ),
    const ProductModel(
      id: 'personal_haircare_2',
      title: 'Hair Conditioner',
      description: 'Deep conditioning hair treatment',
      price: '\$12',
      imagePath: ImagePath.deodorant,
      categoryId: '4',
      subcategoryId: 'personal_haircare',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '350ml',
    ),
    const ProductModel(
      id: 'personal_oral_1',
      title: 'Toothpaste',
      description: 'Fluoride toothpaste for oral care',
      price: '\$5',
      imagePath: ImagePath.personalCareIcon,
      categoryId: '4',
      subcategoryId: 'personal_oral',
      shopId: 'shop_2',
      rating: 4.4,
      weight: '100g',
    ),
    const ProductModel(
      id: 'personal_oral_2',
      title: 'Mouthwash',
      description: 'Antibacterial mouthwash',
      price: '\$7',
      imagePath: ImagePath.personalCareIcon,
      categoryId: '4',
      subcategoryId: 'personal_oral',
      shopId: 'shop_2',
      rating: 4.3,
      weight: '500ml',
    ),
    const ProductModel(
      id: 'personal_body_1',
      title: 'Body Soap',
      description: 'Moisturizing body soap bar',
      price: '\$4',
      imagePath: ImagePath.personalCareIcon,
      categoryId: '4',
      subcategoryId: 'personal_body',
      shopId: 'shop_2',
      rating: 4.2,
      weight: '125g',
    ),
    const ProductModel(
      id: 'personal_body_2',
      title: 'Body Lotion',
      description: 'Hydrating body moisturizer',
      price: '\$9',
      imagePath: ImagePath.personalCareIcon,
      categoryId: '4',
      subcategoryId: 'personal_body',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '250ml',
    ),
    const ProductModel(
      id: 'personal_deodorant_1',
      title: 'Deodorant Spray',
      description: '24-hour protection deodorant',
      price: '\$6',
      imagePath: ImagePath.personalCareIcon,
      categoryId: '4',
      subcategoryId: 'personal_deodorant',
      shopId: 'shop_2',
      rating: 4.4,
      weight: '200ml',
    ),
    const ProductModel(
      id: 'personal_hygiene_1',
      title: 'Hand Sanitizer',
      description: 'Alcohol-based hand sanitizer',
      price: '\$5',
      imagePath: ImagePath.personalCareIcon,
      categoryId: '4',
      subcategoryId: 'personal_hygiene',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '100ml',
    ),

    // ===================== PET SUPPLIES CATEGORY (Category ID: 5) =====================
    const ProductModel(
      id: 'pet_food_1',
      title: 'Dog Food',
      description: 'Premium dry dog food',
      price: '\$22',
      imagePath: ImagePath.dogFood,
      categoryId: '5',
      subcategoryId: 'pet_food',
      shopId: 'shop_2',
      rating: 4.8,
      weight: '5kg',
    ),
    const ProductModel(
      id: 'pet_food_2',
      title: 'Cat Food',
      description: 'Nutritious wet cat food',
      price: '\$18',
      imagePath: ImagePath.catFood,
      categoryId: '5',
      subcategoryId: 'pet_food',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '12 cans',
    ),
    const ProductModel(
      id: 'pet_toys_1',
      title: 'Cat Toy',
      description: 'Interactive cat toy',
      price: '\$8',
      imagePath: ImagePath.catFood,
      categoryId: '5',
      subcategoryId: 'pet_toys',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '1 piece',
    ),
    const ProductModel(
      id: 'pet_toys_2',
      title: 'Dog Chew Toy',
      description: 'Durable rubber chew toy',
      price: '\$12',
      imagePath: ImagePath.dogBed,
      categoryId: '5',
      subcategoryId: 'pet_toys',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '1 piece',
    ),
    const ProductModel(
      id: 'pet_health_1',
      title: 'Pet Shampoo',
      description: 'Gentle pet grooming shampoo',
      price: '\$12',
      imagePath: ImagePath.petSuppliesIcon,
      categoryId: '5',
      subcategoryId: 'pet_health',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '250ml',
    ),
    const ProductModel(
      id: 'pet_health_2',
      title: 'Flea Treatment',
      description: 'Effective flea and tick prevention',
      price: '\$15',
      imagePath: ImagePath.petSuppliesIcon,
      categoryId: '5',
      subcategoryId: 'pet_health',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '3 doses',
    ),
    const ProductModel(
      id: 'pet_accessories_1',
      title: 'Dog Leash',
      description: 'Strong and comfortable dog leash',
      price: '\$14',
      imagePath: ImagePath.petSuppliesIcon,
      categoryId: '5',
      subcategoryId: 'pet_accessories',
      shopId: 'shop_2',
      rating: 4.4,
      weight: '1 piece',
    ),
    const ProductModel(
      id: 'pet_accessories_2',
      title: 'Pet Bed',
      description: 'Comfortable pet sleeping bed',
      price: '\$25',
      imagePath: ImagePath.petSuppliesIcon,
      categoryId: '5',
      subcategoryId: 'pet_accessories',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '1 piece',
    ),
    const ProductModel(
      id: 'pet_treats_1',
      title: 'Dog Treats',
      description: 'Healthy training treats for dogs',
      price: '\$9',
      imagePath: ImagePath.petSuppliesIcon,
      categoryId: '5',
      subcategoryId: 'pet_treats',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '200g',
    ),
    const ProductModel(
      id: 'pet_litter_1',
      title: 'Cat Litter',
      description: 'Clumping cat litter',
      price: '\$16',
      imagePath: ImagePath.petSuppliesIcon,
      categoryId: '5',
      subcategoryId: 'pet_litter',
      shopId: 'shop_2',
      rating: 4.3,
      weight: '10kg',
    ),

    // ===================== CUSTOM CATEGORY (Category ID: 7) =====================
    const ProductModel(
      id: 'custom_electronics_1',
      title: 'Wireless Headphones',
      description: 'High-quality wireless headphones',
      price: '\$45',
      imagePath: ImagePath.earbuds,
      categoryId: '7',
      subcategoryId: 'custom_electronics',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '1 piece',
    ),
    const ProductModel(
      id: 'custom_electronics_2',
      title: 'Phone Charger',
      description: 'Fast charging USB cable',
      price: '\$15',
      imagePath: ImagePath.tShirt,
      categoryId: '7',
      subcategoryId: 'custom_electronics',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '1 piece',
    ),
    const ProductModel(
      id: 'custom_books_1',
      title: 'Programming Book',
      description: 'Learn programming fundamentals',
      price: '\$25',
      imagePath: ImagePath.waterBottle,
      categoryId: '7',
      subcategoryId: 'custom_books',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '1 book',
    ),
    const ProductModel(
      id: 'custom_books_2',
      title: 'Cookbook',
      description: 'Delicious recipes for home cooking',
      price: '\$20',
      imagePath: ImagePath.ledLamp,
      categoryId: '7',
      subcategoryId: 'custom_books',
      shopId: 'shop_2',
      rating: 4.4,
      weight: '1 book',
    ),
    const ProductModel(
      id: 'custom_gifts_1',
      title: 'Gift Basket',
      description: 'Assorted gift items in a basket',
      price: '\$30',
      imagePath: ImagePath.customIcon,
      categoryId: '7',
      subcategoryId: 'custom_gifts',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '1 basket',
    ),
    const ProductModel(
      id: 'custom_gifts_2',
      title: 'Greeting Cards',
      description: 'Beautiful greeting cards set',
      price: '\$8',
      imagePath: ImagePath.customIcon,
      categoryId: '7',
      subcategoryId: 'custom_gifts',
      shopId: 'shop_2',
      rating: 4.2,
      weight: '5 cards',
    ),
    const ProductModel(
      id: 'custom_stationery_1',
      title: 'Notebook Set',
      description: 'Premium quality notebooks',
      price: '\$12',
      imagePath: ImagePath.customIcon,
      categoryId: '7',
      subcategoryId: 'custom_stationery',
      shopId: 'shop_2',
      rating: 4.3,
      weight: '3 pieces',
    ),
    const ProductModel(
      id: 'custom_stationery_2',
      title: 'Pen Set',
      description: 'Professional writing pen set',
      price: '\$18',
      imagePath: ImagePath.customIcon,
      categoryId: '7',
      subcategoryId: 'custom_stationery',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '5 pens',
    ),
    const ProductModel(
      id: 'custom_home_1',
      title: 'Scented Candles',
      description: 'Relaxing aromatherapy candles',
      price: '\$16',
      imagePath: ImagePath.customIcon,
      categoryId: '7',
      subcategoryId: 'custom_home',
      shopId: 'shop_2',
      rating: 4.4,
      weight: '2 pieces',
    ),
    const ProductModel(
      id: 'custom_sports_1',
      title: 'Water Bottle',
      description: 'Insulated sports water bottle',
      price: '\$14',
      imagePath: ImagePath.customIcon,
      categoryId: '7',
      subcategoryId: 'custom_sports',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '1 piece',
    ),
  ];

  // Helper methods for accessing products
  Future<List<ProductModel>> getProductsByCategory(
    String categoryId, {
    int limit = 100,
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
      return await fetchMedicineProducts(limit: limit);
    }

    // For other categories, use static data
    return allProducts
        .where((product) => product.categoryId == categoryId)
        .take(limit)
        .toList();
  }

  Future<List<ProductModel>> getProductsBySubcategory(
    String subcategoryId, {
    int limit = 100,
  }) async {
    // Extract category ID if this is a food subcategory
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

    // For other categories, use static data
    return allProducts
        .where((product) => product.subcategoryId == subcategoryId)
        .take(limit)
        .toList();
  }

  List<ProductModel> getProductsByMainCategory(String mainCategoryId) {
    if (mainCategoryId == 'grocery_produce') {
      return allProducts
          .where(
            (product) => product.subcategoryId?.startsWith('produce_') == true,
          )
          .toList();
    } else if (mainCategoryId == 'grocery_cooking') {
      return allProducts
          .where(
            (product) => product.subcategoryId?.startsWith('cooking_') == true,
          )
          .toList();
    } else if (mainCategoryId == 'grocery_meats') {
      return allProducts
          .where(
            (product) => product.subcategoryId?.startsWith('meats_') == true,
          )
          .toList();
    } else if (mainCategoryId == 'grocery_oils') {
      return allProducts
          .where(
            (product) => product.subcategoryId?.startsWith('oils_') == true,
          )
          .toList();
    }
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
