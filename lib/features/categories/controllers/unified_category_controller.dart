import 'package:get/get.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/home/data/models/shop_model.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';
import 'package:quikle_user/features/categories/data/services/category_service.dart';
import 'package:quikle_user/features/restaurants/data/models/restaurant_model.dart';
import 'package:quikle_user/features/restaurants/data/services/restaurant_service.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/profile/controllers/favorites_controller.dart';
import 'package:quikle_user/routes/app_routes.dart';

class UnifiedCategoryController extends GetxController {
  final CategoryService _categoryService = CategoryService();
  final RestaurantService _restaurantService = RestaurantService();
  final CartController _cartController = Get.find<CartController>();

  // Observables
  final isLoading = false.obs;
  final categoryTitle = ''.obs;
  final productsTitle = 'All Products'.obs;
  final sectionTitle = ''.obs; // Dynamic title for the selection section

  // Category management
  final availableSubcategories = <SubcategoryModel>[].obs;
  final filterSubcategories = <SubcategoryModel>[].obs;
  final allCategories =
      <SubcategoryModel>[].obs; // Always shows main categories
  final allProducts = <ProductModel>[].obs;
  final displayProducts = <ProductModel>[].obs;
  final filteredProducts = <ProductModel>[].obs; // For search/filter results
  final recommendedProducts =
      <ProductModel>[].obs; // Recommended products for non-grocery categories
  final shops = <String, ShopModel>{}.obs; // Shop data cache

  // Restaurant management (for food category)
  final topRestaurants = <RestaurantModel>[].obs;
  final categoryRestaurants = <RestaurantModel>[].obs;
  final showRestaurants = false.obs;

  // Selection state
  final selectedMainCategory = Rxn<SubcategoryModel>();
  final selectedSubcategory = Rxn<SubcategoryModel>();
  final selectedFilter = Rxn<String>();
  final showingAllProducts = false.obs;

  // Search and filter state
  final searchQuery = ''.obs;
  final selectedSortOption = 'relevance'.obs;
  final selectedFilters = <String>[].obs;
  final priceRange = RxList<double>([0.0, 100.0]);
  final showOnlyInStock = false.obs;

  // Category type
  late CategoryModel currentCategory;
  bool get isGroceryCategory =>
      currentCategory.id == '2'; // Grocery category ID
  bool get isFoodCategory => currentCategory.id == '1'; // Food category ID

  // Check if any subcategory is selected - if yes, show combined section
  bool get shouldShowCombinedSection => selectedSubcategory.value != null;

  @override
  void onInit() {
    super.onInit();

    // Get category from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['category'] != null) {
      currentCategory = args['category'] as CategoryModel;
      categoryTitle.value = currentCategory.title;
      _loadCategoryData();
    }
  }

  // Get shop data for a product
  ShopModel? getShopForProduct(ProductModel product) {
    return shops[product.shopId];
  }

  Future<void> _loadShopData() async {
    try {
      // Create a map of static shop data for now
      shops.clear();
      shops['shop_1'] = const ShopModel(
        id: 'shop_1',
        name: 'Tandoori Tarang',
        image: 'assets/icons/profile.png',
        deliveryTime: '30-35 min',
        rating: 4.8,
        address: '123 Food Street, City',
        isOpen: true,
      );
      shops['shop_2'] = const ShopModel(
        id: 'shop_2',
        name: 'Fresh Market',
        image: 'assets/icons/profile.png',
        deliveryTime: '25-30 min',
        rating: 4.6,
        address: '456 Market Lane, City',
        isOpen: true,
      );
      shops['shop_3'] = const ShopModel(
        id: 'shop_3',
        name: 'Health Plus Pharmacy',
        image: 'assets/icons/profile.png',
        deliveryTime: '15-20 min',
        rating: 4.9,
        address: '789 Health Ave, City',
        isOpen: true,
      );
    } catch (e) {
      print('Error loading shop data: $e');
    }
  }

  Future<void> _loadCategoryData() async {
    try {
      isLoading.value = true;

      // Load shop data first
      await _loadShopData();

      if (isGroceryCategory) {
        // For groceries: Load main categories first
        await _loadGroceryMainCategories();
      } else if (isFoodCategory) {
        // For food: Load subcategories and top restaurants
        await _loadFoodCategoryData();
      } else {
        // For other categories: Load subcategories directly
        await _loadCategorySubcategories();
      }
    } catch (e) {
      print('Error loading category data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadFoodCategoryData() async {
    // Load food subcategories
    await _loadCategorySubcategories();

    // Load top restaurants
    final restaurants = await _restaurantService.getTopRestaurants(limit: 25);
    topRestaurants.value = restaurants;
    showRestaurants.value = true;
  }

  Future<void> _loadGroceryMainCategories() async {
    final mainCategories = await _categoryService.fetchGroceryMainCategories();
    allCategories.value = mainCategories; // Always keep main categories
    availableSubcategories.value = mainCategories;
    sectionTitle.value = 'Select Category';

    // Auto-select first category if available
    if (mainCategories.isNotEmpty) {
      selectedMainCategory.value = mainCategories.first;

      // Load subcategories for the first category
      final subCategories = await _categoryService.fetchSubcategories(
        currentCategory.id,
        parentSubcategoryId: mainCategories.first.id,
      );
      filterSubcategories.value = subCategories;

      // Load products for the first category
      final products = await _categoryService.fetchProductsByMainCategory(
        mainCategories.first.id,
      );
      allProducts.value = products;
      displayProducts.value = products;
      productsTitle.value = 'All ${mainCategories.first.title}';
    }
  }

  Future<void> _loadCategorySubcategories() async {
    final subcategories = await _categoryService.fetchSubcategories(
      currentCategory.id,
    );
    allCategories.value = subcategories; // Always keep main categories
    availableSubcategories.value = subcategories;
    sectionTitle.value = 'Popular Items';

    // Auto-select first subcategory if available
    if (subcategories.isNotEmpty) {
      selectedSubcategory.value = subcategories.first;

      // Load products for the first subcategory
      final products = await _categoryService.fetchAllProductsByCategory(
        currentCategory.id,
      );
      allProducts.value = products;

      // Filter products by first subcategory
      final filteredProducts = products
          .where(
            (product) =>
                product.subcategoryId != null &&
                product.subcategoryId == subcategories.first.id,
          )
          .toList();
      displayProducts.value = filteredProducts;
      productsTitle.value = '${subcategories.first.title} Items';
    }

    // Load recommended products for non-grocery categories
    if (!isGroceryCategory) {
      await _loadRecommendedProducts();
    }
  }

  Future<void> _loadRecommendedProducts() async {
    try {
      final products = await _categoryService.fetchRecommendedProducts(
        currentCategory.id,
      );
      recommendedProducts.value = products;
    } catch (e) {
      print('Error loading recommended products: $e');
    }
  }

  void onSubcategoryTap(SubcategoryModel subcategory) async {
    try {
      isLoading.value = true;

      if (isGroceryCategory) {
        // Check if this is a main category selection (from the first row)
        if (allCategories.contains(subcategory)) {
          // Main category selection
          selectedMainCategory.value = subcategory;
          selectedSubcategory.value = null;
          selectedFilter.value = null;

          // Load subcategories for the selected main category
          final subCategories = await _categoryService.fetchSubcategories(
            currentCategory.id,
            parentSubcategoryId: subcategory.id,
          );
          filterSubcategories.value = subCategories;

          // Load all products for this main category
          final products = await _categoryService.fetchProductsByMainCategory(
            subcategory.id,
          );
          allProducts.value = products;
          displayProducts.value = products;
          productsTitle.value = 'All ${subcategory.title}';
        } else {
          // Subcategory selection (from the second row)
          selectedSubcategory.value = subcategory;
          applyFilter(subcategory.id);
        }
      } else if (isFoodCategory) {
        // For food categories: Select subcategory and filter products (like biryani items)
        selectedSubcategory.value = subcategory;
        final filteredProducts = allProducts
            .where(
              (product) =>
                  product.subcategoryId != null &&
                  product.subcategoryId == subcategory.id,
            )
            .toList();
        displayProducts.value = filteredProducts;
        productsTitle.value = '${subcategory.title} Items';
      } else {
        // For non-grocery categories: Select subcategory and filter products
        selectedSubcategory.value = subcategory;
        final filteredProducts = allProducts
            .where(
              (product) =>
                  product.subcategoryId != null &&
                  product.subcategoryId == subcategory.id,
            )
            .toList();
        displayProducts.value = filteredProducts;
        productsTitle.value = '${subcategory.title} Items ';
      }
    } catch (e) {
      print('Error loading subcategory: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilter(String? subcategoryId) {
    selectedFilter.value = subcategoryId;

    if (subcategoryId == null) {
      // Show all products for the main category
      displayProducts.value = allProducts;
      productsTitle.value = selectedMainCategory.value != null
          ? 'All ${selectedMainCategory.value!.title}'
          : 'All Products';
    } else {
      // Filter products by subcategory
      final filteredProducts = allProducts
          .where(
            (product) =>
                product.subcategoryId != null &&
                product.subcategoryId == subcategoryId,
          )
          .toList();
      displayProducts.value = filteredProducts;

      // Update title
      final selectedSubcat = filterSubcategories.firstWhereOrNull(
        (subcat) => subcat.id == subcategoryId,
      );
      productsTitle.value = selectedSubcat != null
          ? '${selectedSubcat.title} Items '
          : 'Filtered Products';
    }
  }

  void resetToMainCategories() async {
    if (!isGroceryCategory) return;

    try {
      isLoading.value = true;

      selectedMainCategory.value = null;
      selectedSubcategory.value = null;
      selectedFilter.value = null;
      filterSubcategories.clear();

      // Reload main categories and auto-select first one
      await _loadGroceryMainCategories();
    } catch (e) {
      print('Error resetting to main categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onProductTap(ProductModel product) {
    // Navigate to product details
    Get.toNamed(AppRoute.getProductDetails(), arguments: product);
  }

  void onAddToCart(ProductModel product) {
    _cartController.addToCart(product);
    Get.snackbar(
      'Added to Cart',
      '${product.title} has been added to your cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void onFavoriteToggle(ProductModel product) {
    // Update global favorites
    if (FavoritesController.isProductFavorite(product.id)) {
      FavoritesController.removeFromGlobalFavorites(product.id);
    } else {
      FavoritesController.addToGlobalFavorites(product.id);
    }

    // Update local product lists to reflect the change
    final isFavorite = FavoritesController.isProductFavorite(product.id);
    final updatedProduct = product.copyWith(isFavorite: isFavorite);
    _updateProductInLists(updatedProduct);

    Get.snackbar(
      isFavorite ? 'Added to Favorites' : 'Removed from Favorites',
      '${updatedProduct.title} ${isFavorite ? 'added to' : 'removed from'} favorites',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _updateProductInLists(ProductModel updatedProduct) {
    // Update in all products list
    final allIndex = allProducts.indexWhere((p) => p.id == updatedProduct.id);
    if (allIndex != -1) {
      allProducts[allIndex] = updatedProduct;
    }

    // Update in display products list
    final displayIndex = displayProducts.indexWhere(
      (p) => p.id == updatedProduct.id,
    );
    if (displayIndex != -1) {
      displayProducts[displayIndex] = updatedProduct;
    }

    // Update in recommended products list
    final recommendedIndex = recommendedProducts.indexWhere(
      (p) => p.id == updatedProduct.id,
    );
    if (recommendedIndex != -1) {
      recommendedProducts[recommendedIndex] = updatedProduct;
    }
  }

  // Navigation helper for back button
  void onBackPressed() {
    if (isGroceryCategory && selectedMainCategory.value != null) {
      // Go back to main categories
      resetToMainCategories();
    } else {
      Get.back();
    }
  }

  // Show all products functionality
  void showAllProducts() {
    showingAllProducts.value = !showingAllProducts.value;
    if (showingAllProducts.value) {
      // Reset any subcategory filter to show all products
      selectedSubcategory.value = null;
      displayProducts.value = allProducts;
      productsTitle.value = '${currentCategory.title} - All Items';
    } else {
      if (selectedSubcategory.value != null) {
        final filteredProducts = allProducts
            .where(
              (product) =>
                  product.subcategoryId != null &&
                  product.subcategoryId == selectedSubcategory.value!.id,
            )
            .toList();
        displayProducts.value = filteredProducts;
        productsTitle.value = selectedSubcategory.value!.title;
      } else {
        displayProducts.value = allProducts;
        productsTitle.value = '${currentCategory.title} Items';
      }
    }
  }

  // Search functionality
  void onSearchChanged(String query) {
    searchQuery.value = query;
    _applyFiltersAndSearch();
  }

  // Sort functionality
  void onSortChanged(String sortOption) {
    selectedSortOption.value = sortOption;
    _applySorting();
  }

  // Filter functionality
  void onFilterChanged(List<String> filters) {
    selectedFilters.value = filters;
    _applyFiltersAndSearch();
  }

  void onPriceRangeChanged(List<double> range) {
    priceRange.value = range;
    _applyFiltersAndSearch();
  }

  void onStockFilterChanged(bool showOnlyInStock) {
    this.showOnlyInStock.value = showOnlyInStock;
    _applyFiltersAndSearch();
  }

  void _applyFiltersAndSearch() {
    List<ProductModel> products = allProducts.toList();

    // Apply search query
    if (searchQuery.value.isNotEmpty) {
      products = products.where((product) {
        return product.title.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ) ||
            product.description.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            );
      }).toList();
    }

    // Apply category/subcategory filter
    if (isGroceryCategory) {
      if (selectedMainCategory.value != null &&
          selectedSubcategory.value != null) {
        products = products
            .where(
              (product) =>
                  product.subcategoryId == selectedSubcategory.value!.id,
            )
            .toList();
      } else if (selectedMainCategory.value != null) {
        products = products
            .where(
              (product) =>
                  product.subcategoryId?.startsWith(
                    selectedMainCategory.value!.id.replaceAll('grocery_', ''),
                  ) ==
                  true,
            )
            .toList();
      }
    } else {
      if (selectedSubcategory.value != null) {
        products = products
            .where(
              (product) =>
                  product.subcategoryId == selectedSubcategory.value!.id,
            )
            .toList();
      }
    }

    // Apply price range filter
    products = products.where((product) {
      final price = double.tryParse(product.price.replaceAll('\$', '')) ?? 0.0;
      return price >= priceRange[0] && price <= priceRange[1];
    }).toList();

    // Apply additional filters based on selectedFilters
    for (String filter in selectedFilters) {
      switch (filter) {
        case 'rating_4_plus':
          products = products
              .where((product) => product.rating >= 4.0)
              .toList();
          break;
        case 'fast_delivery':
          // This would require shop data integration
          break;
        case 'discount':
          // This would require discount data in product model
          break;
      }
    }

    filteredProducts.value = products;
    displayProducts.value = products;
    _applySorting();
  }

  void _applySorting() {
    List<ProductModel> products = displayProducts.toList();

    switch (selectedSortOption.value) {
      case 'price_low_high':
        products.sort((a, b) {
          final priceA = double.tryParse(a.price.replaceAll('\$', '')) ?? 0.0;
          final priceB = double.tryParse(b.price.replaceAll('\$', '')) ?? 0.0;
          return priceA.compareTo(priceB);
        });
        break;
      case 'price_high_low':
        products.sort((a, b) {
          final priceA = double.tryParse(a.price.replaceAll('\$', '')) ?? 0.0;
          final priceB = double.tryParse(b.price.replaceAll('\$', '')) ?? 0.0;
          return priceB.compareTo(priceA);
        });
        break;
      case 'rating':
        products.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'name_a_z':
        products.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'name_z_a':
        products.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'relevance':
      default:
        // Keep original order for relevance
        break;
    }

    displayProducts.value = products;
  }

  // Clear all filters
  void clearFilters() {
    searchQuery.value = '';
    selectedSortOption.value = 'relevance';
    selectedFilters.clear();
    priceRange.value = [0.0, 100.0];
    showOnlyInStock.value = false;

    // Reset to show products based on current category/subcategory selection
    if (selectedSubcategory.value != null) {
      final filteredProducts = allProducts
          .where(
            (product) =>
                product.subcategoryId != null &&
                product.subcategoryId == selectedSubcategory.value!.id,
          )
          .toList();
      displayProducts.value = filteredProducts;
    } else {
      displayProducts.value = allProducts;
    }
  }

  void onRestaurantTap(RestaurantModel restaurant) {
    // Navigate to restaurant menu
    Get.toNamed(
      '/restaurant-menu',
      arguments: {
        'restaurant': restaurant,
        'categoryId': '',
        'categoryName': '',
      },
    );
  }
}
