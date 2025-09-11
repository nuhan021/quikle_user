import 'package:get/get.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/core/data/services/product_data_service.dart';

class FavoritesController extends GetxController {
  // Static set to track favorite product IDs across the app
  static final RxSet<String> _globalFavoriteIds = <String>{}.obs;

  // Observable list of favorite products
  final RxList<ProductModel> _favoriteProducts = <ProductModel>[].obs;

  // Getter for favorite products
  List<ProductModel> get favoriteProducts => _favoriteProducts;

  // Loading state
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Static methods to manage favorites globally
  static bool isProductFavorite(String productId) {
    return _globalFavoriteIds.contains(productId);
  }

  static void addToGlobalFavorites(String productId) {
    _globalFavoriteIds.add(productId);
  }

  static void removeFromGlobalFavorites(String productId) {
    _globalFavoriteIds.remove(productId);
  }

  static Set<String> get globalFavoriteIds => _globalFavoriteIds;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();

    // Listen to global favorites changes
    ever(_globalFavoriteIds, (Set<String> favoriteIds) {
      refreshFavorites();
    });
  }

  // Load favorites from available products in the app
  void loadFavorites() {
    try {
      _isLoading.value = true;

      // Initialize with some sample favorites if none exist
      if (_globalFavoriteIds.isEmpty) {
        _initializeSampleFavorites();
      }

      // Load favorite products based on global favorite IDs
      refreshFavorites();
    } catch (e) {
      print('Error loading favorites: $e');
      // Fallback to empty list
      _favoriteProducts.clear();
    } finally {
      _isLoading.value = false;
    }
  }

  // Initialize some sample favorites for demo purposes
  void _initializeSampleFavorites() {
    final sampleFavoriteIds = [
      'produce_fruits_1', // Fresh Bananas
      'dairy_yogurt_1', // Greek Yogurt
      'produce_fruits_2', // Fresh Apples
      'food_pizza_1', // Margherita Pizza
      'produce_fruits_6', // Avocados
      'dairy_milk_1', // Whole Milk
    ];

    _globalFavoriteIds.addAll(sampleFavoriteIds);
  }

  // Create some sample favorite products for demonstration
  void _createSampleFavorites() {
    final List<ProductModel> sampleFavorites = [
      const ProductModel(
        id: 'produce_fruits_1',
        title: 'Fresh Bananas',
        description: 'Sweet yellow bananas',
        price: '\$2',
        imagePath: 'assets/icons/groceries.png',
        categoryId: '2',
        subcategoryId: 'produce_fruits',
        shopId: 'shop_2',
        rating: 4.6,
        weight: '1kg',
        isFavorite: true,
      ),
      const ProductModel(
        id: 'dairy_yogurt_1',
        title: 'Greek Yogurt',
        description: 'Plain Greek yogurt',
        price: '\$5',
        imagePath: 'assets/icons/groceries.png',
        categoryId: '2',
        subcategoryId: 'dairy_yogurt',
        shopId: 'shop_2',
        rating: 4.7,
        weight: '500g',
        isFavorite: true,
      ),
      const ProductModel(
        id: 'produce_fruits_2',
        title: 'Fresh Apples',
        description: 'Crisp red apples',
        price: '\$4',
        imagePath: 'assets/icons/groceries.png',
        categoryId: '2',
        subcategoryId: 'produce_fruits',
        shopId: 'shop_2',
        rating: 4.8,
        weight: '1kg',
        isFavorite: true,
      ),
      const ProductModel(
        id: 'dairy_milk_1',
        title: 'Whole Milk',
        description: 'Fresh whole milk',
        price: '\$4',
        imagePath: 'assets/icons/groceries.png',
        categoryId: '2',
        subcategoryId: 'dairy_milk',
        shopId: 'shop_2',
        rating: 4.6,
        weight: '1 liter',
        isFavorite: true,
      ),
      const ProductModel(
        id: 'food_pizza_1',
        title: 'Margherita Pizza',
        description: 'Classic Italian pizza with fresh basil',
        price: '\$16',
        imagePath: 'assets/icons/food.png',
        categoryId: '1',
        subcategoryId: 'food_pizza',
        shopId: 'shop_1',
        rating: 4.8,
        weight: '350g',
        isFavorite: true,
      ),
      const ProductModel(
        id: 'produce_fruits_6',
        title: 'Avocados',
        description: 'Fresh ripe avocados',
        price: '\$7',
        imagePath: 'assets/icons/groceries.png',
        categoryId: '2',
        subcategoryId: 'produce_fruits',
        shopId: 'shop_2',
        rating: 4.6,
        weight: '3 pieces',
        isFavorite: true,
      ),
    ];

    _favoriteProducts.assignAll(sampleFavorites);
  }

  // Refresh favorites from the global favorite IDs and product data service
  void refreshFavorites() {
    try {
      final ProductDataService productService = ProductDataService();
      final allProducts = productService.allProducts;

      // Filter products based on global favorite IDs
      final favoriteList = allProducts
          .where((product) => _globalFavoriteIds.contains(product.id))
          .map((product) => product.copyWith(isFavorite: true))
          .toList();

      _favoriteProducts.assignAll(favoriteList);
    } catch (e) {
      print('Error refreshing favorites: $e');
      // Fallback to sample favorites
      _createSampleFavorites();
    }
  }

  // Add product to favorites
  void addToFavorites(ProductModel product) {
    addToGlobalFavorites(product.id);
    refreshFavorites();
  }

  // Remove product from favorites
  void removeFromFavorites(String productId) {
    removeFromGlobalFavorites(productId);
    refreshFavorites();
  }

  // Toggle favorite status
  void toggleFavorite(ProductModel product) {
    if (isProductFavorite(product.id)) {
      removeFromFavorites(product.id);
    } else {
      addToFavorites(product);
    }
  }

  // Clear all favorites
  void clearAllFavorites() {
    _globalFavoriteIds.clear();
    _favoriteProducts.clear();
  }

  // Check if product is favorite
  bool isFavorite(String productId) {
    return isProductFavorite(productId);
  }
}
