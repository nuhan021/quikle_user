import 'package:get/get.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/restaurants/data/models/restaurant_model.dart';
import 'package:quikle_user/features/restaurants/data/services/restaurant_products_service.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/profile/controllers/favorites_controller.dart';
import 'package:quikle_user/routes/app_routes.dart';

class RestaurantPageController extends GetxController {
  final RestaurantProductsService _productsService =
      RestaurantProductsService();

  late RestaurantModel restaurant;

  final allProducts = <ProductModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;

  final selectedCategory = 'All'.obs;
  final categories = <String>['All'].obs;
  final Map<String, int> _categoryIdMap =
      {}; // Maps category name to subcategory ID

  int _currentOffset = 0;
  final int _limit = 20;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  void _initializeData() {
    final args = Get.arguments as Map<String, dynamic>;
    restaurant = args['restaurant'];

    // Build categories from restaurant cuisines with ID mapping
    final cuisineNames = restaurant.cuisines.map((c) => c.name).toList();
    categories.value = ['All', ...cuisineNames];

    // Create map of category name to subcategory ID
    for (final cuisine in restaurant.cuisines) {
      _categoryIdMap[cuisine.name] = cuisine.id;
    }

    loadProducts();
  }

  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      _currentOffset = 0;
      hasMore.value = true;
      allProducts.clear();
    }

    if (isLoading.value || isLoadingMore.value) return;

    try {
      if (_currentOffset == 0) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      AppLoggerHelper.debug(
        '📥 Loading products for restaurant ${restaurant.vendorId} (offset: $_currentOffset) Vendor ID:${restaurant.vendorId}',
      );

      final products = await _productsService.getRestaurantProducts(
        vendorId: restaurant.vendorId,
        offset: _currentOffset,
        limit: _limit,
      );

      if (products.isEmpty) {
        hasMore.value = false;
      } else {
        allProducts.addAll(products);
        _currentOffset += products.length;

        // Check if we got fewer items than requested (means no more items)
        if (products.length < _limit) {
          hasMore.value = false;
        }
      }

      filterProducts(selectedCategory.value);

      AppLoggerHelper.debug(
        '✅ Loaded ${products.length} products. Total: ${allProducts.length}',
      );
    } catch (e) {
      AppLoggerHelper.error('❌ Error loading restaurant products', e);
      Get.snackbar(
        'Error',
        'Failed to load products',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void filterProducts(String category) {
    AppLoggerHelper.debug(
      '🔍 Filtering by category: $category (current: ${selectedCategory.value})',
    );
    selectedCategory.value = category;

    if (category == 'All') {
      filteredProducts.value = allProducts;
    } else {
      // Get the subcategory ID for this category
      final subcategoryId = _categoryIdMap[category];

      if (subcategoryId != null) {
        filteredProducts.value = allProducts.where((product) {
          // Match by subcategory ID
          return product.subcategoryId?.toString() == subcategoryId.toString();
        }).toList();

        AppLoggerHelper.debug(
          'Filtered ${filteredProducts.length} products for category: $category (subcategory_id: $subcategoryId)',
        );
      } else {
        filteredProducts.value = [];
        AppLoggerHelper.warning(
          'No subcategory ID found for category: $category',
        );
      }
    }

    AppLoggerHelper.debug(
      '✅ Selected category is now: ${selectedCategory.value}',
    );
  }

  void loadMoreProducts() {
    if (!hasMore.value || isLoadingMore.value) return;
    loadProducts();
  }

  void onProductTap(ProductModel product) {
    Get.toNamed(AppRoute.getProductDetails(), arguments: product);
  }

  void onAddToCart(ProductModel product) {
    try {
      Get.find<CartController>().addToCart(product);
    } catch (e) {
      AppLoggerHelper.error('Error adding to cart', e);
    }
  }

  void onFavoriteToggle(ProductModel product) {
    try {
      Get.find<FavoritesController>().toggleFavorite(product);

      // Update the product in lists
      final isFav = FavoritesController.isProductFavorite(product.id);
      final updated = product.copyWith(isFavorite: isFav);

      final idx = allProducts.indexWhere((p) => p.id == product.id);
      if (idx != -1) {
        allProducts[idx] = updated;
      }

      final fIdx = filteredProducts.indexWhere((p) => p.id == product.id);
      if (fIdx != -1) {
        filteredProducts[fIdx] = updated;
      }
    } catch (e) {
      AppLoggerHelper.error('Error toggling favorite', e);
    }
  }
}
