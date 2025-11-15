import 'dart:async';
import 'dart:math';
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
import 'package:quikle_user/core/mixins/voice_search_mixin.dart';

class UnifiedCategoryController extends GetxController with VoiceSearchMixin {
  final CategoryService _categoryService = CategoryService();
  final RestaurantService _restaurantService = RestaurantService();
  final CartController _cartController = Get.find<CartController>();

  final isLoading = false.obs;
  final categoryTitle = ''.obs;
  final productsTitle = 'All Products'.obs;
  final sectionTitle = ''.obs;

  final availableSubcategories = <SubcategoryModel>[].obs;
  final filterSubcategories = <SubcategoryModel>[].obs;
  final allCategories = <SubcategoryModel>[].obs;
  final allProducts = <ProductModel>[].obs;
  final displayProducts = <ProductModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;
  final recommendedProducts = <ProductModel>[].obs;
  final shops = <String, ShopModel>{}.obs;

  final topRestaurants = <RestaurantModel>[].obs;
  final categoryRestaurants = <RestaurantModel>[].obs;
  final showRestaurants = false.obs;

  final selectedMainCategory = Rxn<SubcategoryModel>();
  final selectedSubcategory = Rxn<SubcategoryModel>();
  final selectedFilter = Rxn<String>();
  final showingAllProducts = false.obs;

  final searchQuery = ''.obs;
  final selectedSortOption = 'relevance'.obs;
  final selectedFilters = <String>[].obs;
  final priceRange = RxList<double>([0.0, 100.0]);
  final showOnlyInStock = false.obs;

  final currentPlaceholder = "Search products...".obs;
  Timer? _placeholderTimer;

  late CategoryModel currentCategory;
  bool get isGroceryCategory => currentCategory.id == '2';
  bool get isFoodCategory => currentCategory.id == '1';
  bool get isMedicineCategory => currentCategory.id == '3';

  bool get shouldShowCombinedSection => selectedSubcategory.value != null;

  Map<String, List<String>> get categoryPlaceholders => {
    '1': [
      'biryani',
      'pizza',
      'burger',
      'pasta',
      'sushi',
      'tacos',
      'noodles',
      'sandwich',
      'ice cream',
      'coffee',
    ],
    '2': [
      'rice',
      'milk',
      'bread',
      'fruits',
      'vegetables',
      'oil',
      'flour',
      'eggs',
      'cheese',
      'yogurt',
    ],
    '3': [
      'paracetamol',
      'vitamins',
      'cough syrup',
      'bandages',
      'antiseptic',
      'thermometer',
      'pain relief',
      'antibiotics',
      'first aid',
      'supplements',
    ],
    'default': [
      'products',
      'items',
      'essentials',
      'basics',
      'quality products',
    ],
  };

  List<String> get currentCategoryPlaceholders {
    return categoryPlaceholders[currentCategory.id] ??
        categoryPlaceholders['default']!;
  }

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['category'] != null) {
      currentCategory = args['category'] as CategoryModel;
      categoryTitle.value = currentCategory.title;
      _startPlaceholderRotation();
      _loadCategoryData();
    }
  }

  @override
  void onClose() {
    _placeholderTimer?.cancel();
    super.onClose();
  }

  void _startPlaceholderRotation() {
    final placeholders = currentCategoryPlaceholders;
    if (placeholders.isNotEmpty) {
      final randomIndex = Random().nextInt(placeholders.length);
      final randomItem = placeholders[randomIndex];
      currentPlaceholder.value = "Search for '$randomItem'";
    }

    _placeholderTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      final placeholders = currentCategoryPlaceholders;
      if (placeholders.isNotEmpty) {
        final randomIndex = Random().nextInt(placeholders.length);
        final randomItem = placeholders[randomIndex];
        currentPlaceholder.value = "Search for '$randomItem'";
      }
    });
  }

  ShopModel? getShopForProduct(ProductModel product) {
    return shops[product.shopId];
  }

  Future<void> _loadShopData() async {
    try {
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

      await _loadShopData();

      if (isGroceryCategory) {
        await _loadGroceryMainCategories();
      } else if (isFoodCategory) {
        await _loadFoodCategoryData();
      } else {
        await _loadCategorySubcategories();
      }
    } catch (e) {
      print('Error loading category data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadFoodCategoryData() async {
    await _loadCategorySubcategories();

    final restaurants = await _restaurantService.getTopRestaurants(limit: 25);
    topRestaurants.value = restaurants;
    showRestaurants.value = true;
  }

  Future<void> _loadGroceryMainCategories() async {
    // Use the same API method as other categories
    final mainCategories = await _categoryService.fetchSubcategories(
      currentCategory.id,
    );

    allCategories.value = mainCategories;
    availableSubcategories.value = mainCategories;
    sectionTitle.value = 'Select Category';

    final products = await _categoryService.fetchAllProductsByCategory(
      currentCategory.id,
    );
    allProducts.value = products;
    displayProducts.value = products;
    productsTitle.value = 'All ${currentCategory.title}';

    selectedMainCategory.value = null;
    filterSubcategories.clear();
  }

  Future<void> _loadCategorySubcategories() async {
    final subcategories = await _categoryService.fetchSubcategories(
      currentCategory.id,
    );
    allCategories.value = subcategories;
    availableSubcategories.value = subcategories;
    sectionTitle.value = 'Popular Items';

    final products = await _categoryService.fetchAllProductsByCategory(
      currentCategory.id,
    );
    allProducts.value = products;

    displayProducts.value = products;
    productsTitle.value = 'All ${currentCategory.title}';

    selectedSubcategory.value = null;

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

  void onSubcategoryTap(SubcategoryModel? subcategory) async {
    try {
      isLoading.value = true;

      // Handle "All" option
      if (subcategory == null) {
        selectedSubcategory.value = null;
        showingAllProducts.value = false;
        displayProducts.value = allProducts;
        productsTitle.value = 'All Items';
        isLoading.value = false;
        return;
      }

      if (isGroceryCategory) {
        if (allCategories.contains(subcategory)) {
          Get.toNamed(
            AppRoute.getCategoryProducts(),
            arguments: {
              'category': currentCategory,
              'mainCategory': subcategory,
            },
          );
          return;
        } else {
          selectedSubcategory.value = subcategory;
          showingAllProducts.value = false;
          applyFilter(subcategory.id);
        }
      } else if (isFoodCategory) {
        selectedSubcategory.value = subcategory;
        showingAllProducts.value = false;
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
        selectedSubcategory.value = subcategory;
        showingAllProducts.value = false;
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
      displayProducts.value = allProducts;
      productsTitle.value = selectedMainCategory.value != null
          ? 'All ${selectedMainCategory.value!.title}'
          : 'All Products';
    } else {
      final filteredProducts = allProducts
          .where(
            (product) =>
                product.subcategoryId != null &&
                product.subcategoryId == subcategoryId,
          )
          .toList();
      displayProducts.value = filteredProducts;

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

      await _loadGroceryMainCategories();
    } catch (e) {
      print('Error resetting to main categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onProductTap(ProductModel product) {
    Get.toNamed(AppRoute.getProductDetails(), arguments: product);
  }

  void onAddToCart(ProductModel product) {
    _cartController.addToCart(product);
  }

  void onFavoriteToggle(ProductModel product) {
    if (FavoritesController.isProductFavorite(product.id)) {
      FavoritesController.removeFromGlobalFavorites(product.id);
    } else {
      FavoritesController.addToGlobalFavorites(product.id);
    }

    final isFavorite = FavoritesController.isProductFavorite(product.id);
    final updatedProduct = product.copyWith(isFavorite: isFavorite);
    _updateProductInLists(updatedProduct);

    // Get.snackbar(
    //   isFavorite ? 'Added to Favorites' : 'Removed from Favorites',
    //   '${updatedProduct.title} ${isFavorite ? 'added to' : 'removed from'} favorites',
    //   snackPosition: SnackPosition.BOTTOM,
    //   duration: const Duration(seconds: 2),
    // );
  }

  void _updateProductInLists(ProductModel updatedProduct) {
    final allIndex = allProducts.indexWhere((p) => p.id == updatedProduct.id);
    if (allIndex != -1) {
      allProducts[allIndex] = updatedProduct;
    }

    final displayIndex = displayProducts.indexWhere(
      (p) => p.id == updatedProduct.id,
    );
    if (displayIndex != -1) {
      displayProducts[displayIndex] = updatedProduct;
    }

    final recommendedIndex = recommendedProducts.indexWhere(
      (p) => p.id == updatedProduct.id,
    );
    if (recommendedIndex != -1) {
      recommendedProducts[recommendedIndex] = updatedProduct;
    }
  }

  void onBackPressed() {
    if (isGroceryCategory) {
      if (selectedSubcategory.value != null) {
        clearSubcategorySelection();
      } else if (selectedMainCategory.value != null) {
        clearMainCategorySelection();
      } else {
        Get.back();
      }
    } else {
      if (selectedSubcategory.value != null) {
        clearSubcategorySelection();
      } else {
        Get.back();
      }
    }
  }

  void showAllProducts() {
    showingAllProducts.value = !showingAllProducts.value;
    if (showingAllProducts.value) {
      if (isGroceryCategory) {
        if (selectedSubcategory.value != null) {
          final filteredProducts = allProducts
              .where(
                (product) =>
                    product.subcategoryId != null &&
                    product.subcategoryId == selectedSubcategory.value!.id,
              )
              .toList();
          displayProducts.value = filteredProducts;
          productsTitle.value =
              '${selectedSubcategory.value!.title} - All Items';
        } else if (selectedMainCategory.value != null) {
          displayProducts.value = allProducts;
          productsTitle.value =
              '${selectedMainCategory.value!.title} - All Items';
        } else {
          displayProducts.value = allProducts;
          productsTitle.value = '${currentCategory.title} - All Items';
        }
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
          productsTitle.value =
              '${selectedSubcategory.value!.title} - All Items';
        } else {
          displayProducts.value = allProducts;
          productsTitle.value = '${currentCategory.title} - All Items';
        }
      }
    } else {
      if (isGroceryCategory) {
        if (selectedSubcategory.value != null) {
          final filteredProducts = allProducts
              .where(
                (product) =>
                    product.subcategoryId != null &&
                    product.subcategoryId == selectedSubcategory.value!.id,
              )
              .toList();
          displayProducts.value = filteredProducts;
          productsTitle.value = '${selectedSubcategory.value!.title} Items';
        } else if (selectedMainCategory.value != null) {
          displayProducts.value = allProducts;
          productsTitle.value = 'All ${selectedMainCategory.value!.title}';
        } else {
          displayProducts.value = allProducts;
          productsTitle.value = 'All ${currentCategory.title}';
        }
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
          productsTitle.value = '${selectedSubcategory.value!.title} Items';
        } else {
          displayProducts.value = allProducts;
          productsTitle.value = 'All ${currentCategory.title}';
        }
      }
    }
  }

  void clearSubcategorySelection() {
    selectedSubcategory.value = null;
    showingAllProducts.value = false;

    if (isGroceryCategory && selectedMainCategory.value != null) {
      displayProducts.value = allProducts;
      productsTitle.value = 'All ${selectedMainCategory.value!.title}';
    } else {
      displayProducts.value = allProducts;
      productsTitle.value = 'All ${currentCategory.title}';
    }
  }

  void clearMainCategorySelection() {
    selectedMainCategory.value = null;
    selectedSubcategory.value = null;
    showingAllProducts.value = false;
    filterSubcategories.clear();
    displayProducts.value = allProducts;
    productsTitle.value = 'All ${currentCategory.title}';
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _applyFiltersAndSearch();
  }

  void onSortChanged(String sortOption) {
    selectedSortOption.value = sortOption;
    _applySorting();
  }

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

    products = products.where((product) {
      final price = double.tryParse(product.price.replaceAll('\$', '')) ?? 0.0;
      return price >= priceRange[0] && price <= priceRange[1];
    }).toList();

    for (String filter in selectedFilters) {
      switch (filter) {
        case 'rating_4_plus':
          products = products
              .where((product) => product.rating >= 4.0)
              .toList();
          break;
        case 'fast_delivery':
          break;
        case 'discount':
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
        break;
    }

    displayProducts.value = products;
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedSortOption.value = 'relevance';
    selectedFilters.clear();
    priceRange.value = [0.0, 100.0];
    showOnlyInStock.value = false;

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
    Get.toNamed(
      '/restaurant-menu',
      arguments: {
        'restaurant': restaurant,
        'categoryId': '',
        'categoryName': '',
      },
    );
  }

  Future<void> onVoiceSearchPressed() async {
    await startVoiceSearch(navigateToSearch: true);
  }
}
