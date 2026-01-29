import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/home/data/models/shop_model.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';
import 'package:quikle_user/features/categories/data/services/category_service.dart';
import 'package:quikle_user/core/data/services/product_data_service.dart';
import 'package:quikle_user/core/data/services/category_cache_service.dart';
import 'package:quikle_user/features/restaurants/data/models/restaurant_model.dart';
import 'package:quikle_user/features/restaurants/data/services/restaurant_service.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/profile/favorites/controllers/favorites_controller.dart';
import 'package:quikle_user/routes/app_routes.dart';
import 'package:quikle_user/core/mixins/voice_search_mixin.dart';

class UnifiedCategoryController extends GetxController with VoiceSearchMixin {
  final CategoryService _categoryService = CategoryService();
  final ProductDataService _productDataService = ProductDataService();
  final RestaurantService _restaurantService = RestaurantService();
  final CategoryCacheService _cacheService = CategoryCacheService();
  final CartController _cartController = Get.find<CartController>();

  final isLoading = false.obs;
  final isLoadingProducts = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final currentOffset = 0.obs;
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
  bool get isMedicineCategory => currentCategory.id == '6';

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
  Future<void> onInit() async {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['category'] != null) {
      currentCategory = args['category'] as CategoryModel;
      categoryTitle.value = currentCategory.title;
      _startPlaceholderRotation();

      if (args.containsKey('preloadedSubcategories')) {
        final preloadedSubs =
            args['preloadedSubcategories'] as List<SubcategoryModel>;
        await _loadCategoryDataWithPreloadedSubcategories(preloadedSubs);
      } else {
        await _loadCategoryData();
      }

      // Start background prefetch while this controller/screen is active.
      // Prefetch will continue until the controller is closed (onClose).
      _startAutoFetchingPages();

      if (args.containsKey('autoSelectSubcategory')) {
        final autoSelectSub = args['autoSelectSubcategory'] as SubcategoryModel;
        Future.delayed(const Duration(milliseconds: 500), () {
          onSubcategoryTap(autoSelectSub);
        });
      }
    }
  }

  @override
  void onClose() {
    _placeholderTimer?.cancel();
    _stopAutoFetchingPages();
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
    } catch (_) {}
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
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadCategoryDataWithPreloadedSubcategories(
    List<SubcategoryModel> preloadedSubcategories,
  ) async {
    try {
      isLoading.value = true;

      await _loadShopData();

      if (isGroceryCategory) {
        allCategories.value = preloadedSubcategories;
        availableSubcategories.value = preloadedSubcategories;
        sectionTitle.value = 'Select Category';
        selectedMainCategory.value = null;
        filterSubcategories.clear();

        await _fetchProductsForGrocery();
      } else if (isFoodCategory) {
        allCategories.value = preloadedSubcategories;
        availableSubcategories.value = preloadedSubcategories;
        sectionTitle.value = 'Popular Items';
        selectedSubcategory.value = null;

        await Future.wait([_fetchProductsForCategory(), _loadRestaurants()]);
      } else {
        allCategories.value = preloadedSubcategories;
        availableSubcategories.value = preloadedSubcategories;
        sectionTitle.value = 'Popular Items';
        selectedSubcategory.value = null;

        await _fetchProductsForCategory();
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchProductsForGrocery() async {
    try {
      final cachedProducts = await _cacheService.getCachedProducts(
        categoryId: currentCategory.id,
      );

      if (cachedProducts != null) {
        allProducts.value = cachedProducts;
        displayProducts.value = cachedProducts;
        productsTitle.value = 'All ${currentCategory.title}';
        currentOffset.value = 0;
        hasMore.value = true;

        _refreshProductsInBackground();
        return;
      }

      final products = await _categoryService.fetchAllProductsByCategory(
        currentCategory.id,
        limit: 9,
      );

      allProducts.value = products;
      displayProducts.value = products;
      productsTitle.value = 'All ${currentCategory.title}';
      currentOffset.value = 0;
      hasMore.value = true;

      await _cacheService.cacheProducts(
        categoryId: currentCategory.id,
        products: products,
      );
    } catch (_) {}
  }

  Future<void> _fetchProductsForCategory() async {
    try {
      final cachedProducts = await _cacheService.getCachedProducts(
        categoryId: currentCategory.id,
      );

      if (cachedProducts != null) {
        allProducts.value = cachedProducts;
        displayProducts.value = cachedProducts;
        productsTitle.value = 'All ${currentCategory.title}';
        currentOffset.value = 0;
        hasMore.value = true;

        _refreshProductsInBackground();
        return;
      }

      final products = await _categoryService.fetchAllProductsByCategory(
        currentCategory.id,
        limit: 9,
      );

      allProducts.value = products;
      displayProducts.value = products;
      productsTitle.value = 'All ${currentCategory.title}';
      currentOffset.value = 0;
      hasMore.value = true;

      await _cacheService.cacheProducts(
        categoryId: currentCategory.id,
        products: products,
      );
    } catch (_) {}
  }

  Future<void> _loadRestaurants() async {
    try {
      final restaurants = await _restaurantService.getTopRestaurants(limit: 25);
      topRestaurants.value = restaurants;
      showRestaurants.value = true;
    } catch (_) {}
  }

  Future<void> _refreshProductsInBackground() async {
    try {
      final products = await _categoryService.fetchAllProductsByCategory(
        currentCategory.id,
        limit: 9,
      );

      if (products.length != allProducts.length) {
        allProducts.value = products;
        displayProducts.value = products;

        await _cacheService.cacheProducts(
          categoryId: currentCategory.id,
          products: products,
        );
      }
    } catch (_) {}
  }

  Future<void> _loadFoodCategoryData() async {
    await _loadCategorySubcategories();

    final restaurants = await _restaurantService.getTopRestaurants(limit: 25);
    topRestaurants.value = restaurants;
    showRestaurants.value = true;
  }

  Future<void> _loadGroceryMainCategories() async {
    final results = await Future.wait([
      _cacheService.getCachedSubcategories(categoryId: currentCategory.id),
      _cacheService.getCachedProducts(categoryId: currentCategory.id),
    ]);

    final cachedSubcategories = results[0] as List<SubcategoryModel>?;
    final cachedProducts = results[1] as List<ProductModel>?;

    if (cachedSubcategories != null && cachedProducts != null) {
      allCategories.value = cachedSubcategories;
      availableSubcategories.value = cachedSubcategories;
      sectionTitle.value = 'Select Category';

      allProducts.value = cachedProducts;
      displayProducts.value = cachedProducts;
      productsTitle.value = 'All ${currentCategory.title}';

      selectedMainCategory.value = null;
      filterSubcategories.clear();
      currentOffset.value = 0;
      hasMore.value = true;

      _refreshGroceryDataInBackground();
      return;
    }

    final apiResults = await Future.wait([
      _categoryService.fetchSubcategories(currentCategory.id),
      _categoryService.fetchAllProductsByCategory(currentCategory.id, limit: 9),
    ]);

    final mainCategories = apiResults[0] as List<SubcategoryModel>;
    final products = apiResults[1] as List<ProductModel>;

    allCategories.value = mainCategories;
    availableSubcategories.value = mainCategories;
    sectionTitle.value = 'Select Category';
    selectedMainCategory.value = null;
    filterSubcategories.clear();
    currentOffset.value = 0;
    hasMore.value = true;

    allProducts.value = products;
    displayProducts.value = products;
    productsTitle.value = 'All ${currentCategory.title}';

    await Future.wait([
      _cacheService.cacheSubcategories(
        categoryId: currentCategory.id,
        subcategories: mainCategories,
      ),
      _cacheService.cacheProducts(
        categoryId: currentCategory.id,
        products: products,
      ),
    ]);
  }

  Future<void> _refreshGroceryDataInBackground() async {
    try {
      final results = await Future.wait([
        _categoryService.fetchSubcategories(currentCategory.id),
        _categoryService.fetchAllProductsByCategory(
          currentCategory.id,
          limit: 9,
        ),
      ]);

      final mainCategories = results[0] as List<SubcategoryModel>;
      final products = results[1] as List<ProductModel>;

      await Future.wait([
        _cacheService.cacheSubcategories(
          categoryId: currentCategory.id,
          subcategories: mainCategories,
        ),
        _cacheService.cacheProducts(
          categoryId: currentCategory.id,
          products: products,
        ),
      ]);

      if (mainCategories.length != allCategories.length ||
          products.length != allProducts.length) {
        allCategories.value = mainCategories;
        availableSubcategories.value = mainCategories;
        allProducts.value = products;
        displayProducts.value = products;
      }
    } catch (_) {}
  }

  Future<void> _loadCategorySubcategories() async {
    final results = await Future.wait([
      _cacheService.getCachedSubcategories(categoryId: currentCategory.id),
      _cacheService.getCachedProducts(categoryId: currentCategory.id),
    ]);

    final cachedSubcategories = results[0] as List<SubcategoryModel>?;
    final cachedProducts = results[1] as List<ProductModel>?;

    if (cachedSubcategories != null && cachedProducts != null) {
      allCategories.value = cachedSubcategories;
      availableSubcategories.value = cachedSubcategories;
      sectionTitle.value = 'Popular Items';

      allProducts.value = cachedProducts;
      displayProducts.value = cachedProducts;
      productsTitle.value = 'All ${currentCategory.title}';

      selectedSubcategory.value = null;
      currentOffset.value = 0;
      hasMore.value = true;

      _refreshCategoryDataInBackground();
      return;
    }

    final apiResults = await Future.wait([
      _categoryService.fetchSubcategories(currentCategory.id),
      _categoryService.fetchAllProductsByCategory(currentCategory.id, limit: 9),
    ]);

    final subcategories = apiResults[0] as List<SubcategoryModel>;
    final products = apiResults[1] as List<ProductModel>;

    allCategories.value = subcategories;
    availableSubcategories.value = subcategories;
    sectionTitle.value = 'Popular Items';
    selectedSubcategory.value = null;
    currentOffset.value = 0;
    hasMore.value = true;

    allProducts.value = products;
    displayProducts.value = products;
    productsTitle.value = 'All ${currentCategory.title}';

    await Future.wait([
      _cacheService.cacheSubcategories(
        categoryId: currentCategory.id,
        subcategories: subcategories,
      ),
      _cacheService.cacheProducts(
        categoryId: currentCategory.id,
        products: products,
      ),
    ]);
  }

  Future<void> _refreshCategoryDataInBackground() async {
    try {
      final results = await Future.wait([
        _categoryService.fetchSubcategories(currentCategory.id),
        _categoryService.fetchAllProductsByCategory(
          currentCategory.id,
          limit: 9,
        ),
      ]);

      final subcategories = results[0] as List<SubcategoryModel>;
      final products = results[1] as List<ProductModel>;

      await Future.wait([
        _cacheService.cacheSubcategories(
          categoryId: currentCategory.id,
          subcategories: subcategories,
        ),
        _cacheService.cacheProducts(
          categoryId: currentCategory.id,
          products: products,
        ),
      ]);

      if (subcategories.length != allCategories.length ||
          products.length != allProducts.length) {
        allCategories.value = subcategories;
        availableSubcategories.value = subcategories;
        allProducts.value = products;
        displayProducts.value = products;
      }
    } catch (_) {}
  }

  void onSubcategoryTap(SubcategoryModel? subcategory) async {
    try {
      if (subcategory == null) {
        selectedSubcategory.value = null;
        showingAllProducts.value = false;
        displayProducts.value = allProducts.take(9).toList();
        productsTitle.value = 'All Items';
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
          return;
        }
      }

      final existingProducts = allProducts
          .where((p) => p.subcategoryId == subcategory.id)
          .toList();

      if (existingProducts.isNotEmpty) {
        selectedSubcategory.value = subcategory;
        showingAllProducts.value = false;
        currentOffset.value = 0;
        hasMore.value = existingProducts.length > 9;
        displayProducts.value = existingProducts.take(9).toList();
        productsTitle.value = '${subcategory.title} Items';
        return;
      }

      final cachedProducts = await _cacheService.getCachedProducts(
        categoryId: currentCategory.id,
        subcategoryId: subcategory.id,
      );

      if (cachedProducts != null) {
        selectedSubcategory.value = subcategory;
        showingAllProducts.value = false;
        currentOffset.value = 0;
        hasMore.value = true;

        for (var product in cachedProducts) {
          if (!allProducts.any((p) => p.id == product.id)) {
            allProducts.add(product);
          }
        }
        displayProducts.value = cachedProducts;
        productsTitle.value = '${subcategory.title} Items';

        _refreshSubcategoryDataInBackground(subcategory);
        return;
      }

      isLoadingProducts.value = true;

      if (isFoodCategory) {
        selectedSubcategory.value = subcategory;
        showingAllProducts.value = false;
        currentOffset.value = 0;
        hasMore.value = true;

        final products = await _productDataService.getProductsBySubcategory(
          subcategory.id,
          limit: 9,
          categoryId: currentCategory.id,
        );
        for (var product in products) {
          if (!allProducts.any((p) => p.id == product.id)) {
            allProducts.add(product);
          }
        }
        displayProducts.value = products;
        productsTitle.value = '${subcategory.title} Items';

        await _cacheService.cacheProducts(
          categoryId: currentCategory.id,
          subcategoryId: subcategory.id,
          products: products,
        );
      } else if (isMedicineCategory) {
        selectedSubcategory.value = subcategory;
        showingAllProducts.value = false;
        currentOffset.value = 0;
        hasMore.value = true;

        final products = await _productDataService.getProductsBySubcategory(
          subcategory.id,
          limit: 9,
          categoryId: currentCategory.id,
        );
        for (var product in products) {
          if (!allProducts.any((p) => p.id == product.id)) {
            allProducts.add(product);
          }
        }
        displayProducts.value = products;
        productsTitle.value = '${subcategory.title} Items';

        await _cacheService.cacheProducts(
          categoryId: currentCategory.id,
          subcategoryId: subcategory.id,
          products: products,
        );
      } else if (currentCategory.id == '2' ||
          currentCategory.id == '3' ||
          currentCategory.id == '4' ||
          currentCategory.id == '5') {
        selectedSubcategory.value = subcategory;
        showingAllProducts.value = false;
        currentOffset.value = 0;
        hasMore.value = true;

        final products = await _productDataService.getProductsBySubcategory(
          subcategory.id,
          limit: 9,
          categoryId: currentCategory.id,
        );
        for (var product in products) {
          if (!allProducts.any((p) => p.id == product.id)) {
            allProducts.add(product);
          }
        }
        displayProducts.value = products;
        productsTitle.value = '${subcategory.title} Items';

        await _cacheService.cacheProducts(
          categoryId: currentCategory.id,
          subcategoryId: subcategory.id,
          products: products,
        );
      } else {
        selectedSubcategory.value = subcategory;
        showingAllProducts.value = false;
        final filteredProducts = allProducts
            .where(
              (product) =>
                  product.subcategoryId != null &&
                  product.subcategoryId == subcategory.id,
            )
            .take(9)
            .toList();
        displayProducts.value = filteredProducts;
        productsTitle.value = '${subcategory.title} Items ';
      }
    } catch (_) {
    } finally {
      isLoadingProducts.value = false;
    }
  }

  Future<void> _refreshSubcategoryDataInBackground(
    SubcategoryModel subcategory,
  ) async {
    try {
      final products = await _productDataService.getProductsBySubcategory(
        subcategory.id,
        limit: 9,
        categoryId: currentCategory.id,
      );

      await _cacheService.cacheProducts(
        categoryId: currentCategory.id,
        subcategoryId: subcategory.id,
        products: products,
      );

      if (selectedSubcategory.value?.id == subcategory.id &&
          products.length != displayProducts.length) {
        for (var product in products) {
          if (!allProducts.any((p) => p.id == product.id)) {
            allProducts.add(product);
          }
        }
        displayProducts.value = products;
      }
    } catch (_) {}
  }

  void applyFilter(String? subcategoryId) {
    selectedFilter.value = subcategoryId;

    if (subcategoryId == null) {
      displayProducts.value = allProducts.take(9).toList();
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
          .take(9)
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
    } catch (_) {
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
    Get.find<FavoritesController>().toggleFavorite(product);

    final isFavorite = FavoritesController.isProductFavorite(product.id);
    final updatedProduct = product.copyWith(isFavorite: isFavorite);
    _updateProductInLists(updatedProduct);
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

  Future<void> showAllProducts() async {
    showingAllProducts.value = !showingAllProducts.value;

    if (showingAllProducts.value) {
      currentOffset.value = 0;
      hasMore.value = true;

      if (isFoodCategory ||
          isMedicineCategory ||
          currentCategory.id == '2' ||
          currentCategory.id == '3' ||
          currentCategory.id == '4' ||
          currentCategory.id == '5') {
        if (selectedSubcategory.value != null) {
          productsTitle.value =
              '${selectedSubcategory.value!.title} - All Items';
        } else {
          productsTitle.value = '${currentCategory.title} - All Items';
        }
        // _startAutoFetchingPages(); // Removed to prevent duplicate calls
        return;
      }

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
      _stopAutoFetchingPages();
      if (isGroceryCategory) {
        if (selectedSubcategory.value != null) {
          final filteredProducts = allProducts
              .where(
                (product) =>
                    product.subcategoryId != null &&
                    product.subcategoryId == selectedSubcategory.value!.id,
              )
              .take(9)
              .toList();
          displayProducts.value = filteredProducts;
          productsTitle.value = '${selectedSubcategory.value!.title} Items';
        } else if (selectedMainCategory.value != null) {
          displayProducts.value = allProducts.take(9).toList();
          productsTitle.value = 'All ${selectedMainCategory.value!.title}';
        } else {
          displayProducts.value = allProducts.take(9).toList();
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
              .take(9)
              .toList();
          displayProducts.value = filteredProducts;
          productsTitle.value = '${selectedSubcategory.value!.title} Items';
        } else {
          displayProducts.value = allProducts.take(9).toList();
          productsTitle.value = 'All ${currentCategory.title}';
        }
      }
    }
  }

  bool _autoFetching = false;

  void _startAutoFetchingPages() {
    if (_autoFetching) return;
    _autoFetching = true;
    Future(() async {
      while (_autoFetching && hasMore.value) {
        try {
          // Only trigger a load when the controller is not already loading more
          if (!isLoadingMore.value) {
            await loadMoreProducts();
          }
        } catch (_) {}
        await Future.delayed(
          showingAllProducts.value
              ? const Duration(milliseconds: 300)
              : const Duration(seconds: 2),
        );
      }
      _autoFetching = false;
    });
  }

  void _stopAutoFetchingPages() {
    _autoFetching = false;
  }

  void clearSubcategorySelection() {
    selectedSubcategory.value = null;
    showingAllProducts.value = false;

    // _stopAutoFetchingPages(); // Removed to allow continuous fetching

    if (isFoodCategory ||
        isMedicineCategory ||
        currentCategory.id == '2' ||
        currentCategory.id == '3' ||
        currentCategory.id == '4' ||
        currentCategory.id == '5') {
      currentOffset.value = 0;
      hasMore.value = true;
    }

    if (isGroceryCategory && selectedMainCategory.value != null) {
      displayProducts.value = allProducts.take(9).toList();
      productsTitle.value = 'All ${selectedMainCategory.value!.title}';
    } else {
      displayProducts.value = allProducts.take(9).toList();
      productsTitle.value = 'All ${currentCategory.title}';
    }
  }

  void clearMainCategorySelection() {
    selectedMainCategory.value = null;
    selectedSubcategory.value = null;
    showingAllProducts.value = false;
    filterSubcategories.clear();

    if (isFoodCategory ||
        isMedicineCategory ||
        currentCategory.id == '2' ||
        currentCategory.id == '3' ||
        currentCategory.id == '4' ||
        currentCategory.id == '5') {
      currentOffset.value = 0;
      hasMore.value = true;
    }

    displayProducts.value = allProducts.take(9).toList();
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

    for (String filter in selectedFilters) {
      switch (filter) {
        case 'below_99':
          products = products.where((product) {
            final price =
                double.tryParse(
                  product.price.replaceAll('₹', '').replaceAll('৳', ''),
                ) ??
                0.0;
            return price < 99;
          }).toList();
          break;
        case '100_199':
          products = products.where((product) {
            final price =
                double.tryParse(
                  product.price.replaceAll('₹', '').replaceAll('৳', ''),
                ) ??
                0.0;
            return price >= 100 && price <= 199;
          }).toList();
          break;
        case '200_499':
          products = products.where((product) {
            final price =
                double.tryParse(
                  product.price.replaceAll('₹', '').replaceAll('৳', ''),
                ) ??
                0.0;
            return price >= 200 && price <= 499;
          }).toList();
          break;
        case 'above_500':
          products = products.where((product) {
            final price =
                double.tryParse(
                  product.price.replaceAll('₹', '').replaceAll('৳', ''),
                ) ??
                0.0;
            return price >= 500;
          }).toList();
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
          final priceA = double.tryParse(a.price.replaceAll('₹', '')) ?? 0.0;
          final priceB = double.tryParse(b.price.replaceAll('₹', '')) ?? 0.0;
          return priceA.compareTo(priceB);
        });
        break;
      case 'price_high_low':
        products.sort((a, b) {
          final priceA = double.tryParse(a.price.replaceAll('₹', '')) ?? 0.0;
          final priceB = double.tryParse(b.price.replaceAll('₹', '')) ?? 0.0;
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

    if (isFoodCategory ||
        isMedicineCategory ||
        currentCategory.id == '2' ||
        currentCategory.id == '3' ||
        currentCategory.id == '4' ||
        currentCategory.id == '5') {
      currentOffset.value = 0;
      hasMore.value = true;

      if (selectedSubcategory.value != null) {
        displayProducts.value = allProducts.take(9).toList();
      } else {
        displayProducts.value = allProducts.take(9).toList();
      }
    } else {
      if (selectedSubcategory.value != null) {
        final filteredProducts = allProducts
            .where(
              (product) =>
                  product.subcategoryId != null &&
                  product.subcategoryId == selectedSubcategory.value!.id,
            )
            .take(9)
            .toList();
        displayProducts.value = filteredProducts;
      } else {
        displayProducts.value = allProducts.take(9).toList();
      }
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

  Future<void> refreshData() async {
    try {
      isLoading.value = true;

      await _cacheService.clearCache(
        categoryId: currentCategory.id,
        subcategoryId: selectedSubcategory.value?.id,
      );

      if (isGroceryCategory) {
        await _loadGroceryMainCategories();
      } else if (isFoodCategory) {
        await _loadFoodCategoryData();
      } else {
        await _loadCategorySubcategories();
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreProducts() async {
    if (isLoadingMore.value || !hasMore.value) {
      return;
    }

    try {
      isLoadingMore.value = true;

      final nextOffset = displayProducts.length;
      // Prefer cached prefetched products if available to avoid network calls
      final cachedProducts = await _cacheService.getCachedProducts(
        categoryId: currentCategory.id,
        subcategoryId: selectedSubcategory.value?.id,
      );

      if (cachedProducts != null && cachedProducts.length > nextOffset) {
        final take = min(cachedProducts.length - nextOffset, 20);
        final slice = cachedProducts.sublist(nextOffset, nextOffset + take);

        if (slice.isNotEmpty) {
          allProducts.addAll(slice);
          _applyFiltersAndSearch();
        }

        // If cache still has more items beyond what we just consumed, indicate hasMore
        hasMore.value = cachedProducts.length > nextOffset + slice.length;
        return;
      }

      // No cached items to serve for this offset, fall back to network
      final result = await _productDataService.fetchMoreProducts(
        categoryId: currentCategory.id,
        subcategoryId: selectedSubcategory.value?.id,
        offset: nextOffset,
        limit: 20,
      );

      final newProducts = result['products'] as List<ProductModel>;
      hasMore.value = result['hasMore'] as bool;

      if (newProducts.isNotEmpty) {
        allProducts.addAll(newProducts);
        _applyFiltersAndSearch();
      }
    } catch (_) {
    } finally {
      isLoadingMore.value = false;
    }
  }
}
