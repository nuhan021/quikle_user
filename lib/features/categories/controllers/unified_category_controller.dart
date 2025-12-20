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
import 'package:quikle_user/features/profile/controllers/favorites_controller.dart';
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
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['category'] != null) {
      currentCategory = args['category'] as CategoryModel;
      categoryTitle.value = currentCategory.title;
      _startPlaceholderRotation();

      // Check if subcategories are preloaded from categories screen
      if (args.containsKey('preloadedSubcategories')) {
        final preloadedSubs =
            args['preloadedSubcategories'] as List<SubcategoryModel>;
        print(
          '✅ Using preloaded subcategories (${preloadedSubs.length} items) - skipping API call',
        );
        _loadCategoryDataWithPreloadedSubcategories(preloadedSubs);
      } else {
        _loadCategoryData();
      }

      // Check if we should auto-select a subcategory
      if (args.containsKey('autoSelectSubcategory')) {
        final autoSelectSub = args['autoSelectSubcategory'] as SubcategoryModel;
        // Delay the selection until after data is loaded
        Future.delayed(const Duration(milliseconds: 500), () {
          onSubcategoryTap(autoSelectSub);
        });
      }
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

  /// Load category data using preloaded subcategories (skip subcategory API call)
  Future<void> _loadCategoryDataWithPreloadedSubcategories(
    List<SubcategoryModel> preloadedSubcategories,
  ) async {
    try {
      isLoading.value = true;

      await _loadShopData();

      if (isGroceryCategory) {
        // For grocery, use preloaded main categories
        allCategories.value = preloadedSubcategories;
        availableSubcategories.value = preloadedSubcategories;
        sectionTitle.value = 'Select Category';
        selectedMainCategory.value = null;
        filterSubcategories.clear();

        // Still need to fetch products
        await _fetchProductsForGrocery();
      } else if (isFoodCategory) {
        // For food, use preloaded subcategories
        allCategories.value = preloadedSubcategories;
        availableSubcategories.value = preloadedSubcategories;
        sectionTitle.value = 'Popular Items';
        selectedSubcategory.value = null;

        // Fetch products and restaurants
        await Future.wait([_fetchProductsForCategory(), _loadRestaurants()]);
      } else {
        // For other categories, use preloaded subcategories
        allCategories.value = preloadedSubcategories;
        availableSubcategories.value = preloadedSubcategories;
        sectionTitle.value = 'Popular Items';
        selectedSubcategory.value = null;

        // Fetch products
        await _fetchProductsForCategory();
      }
    } catch (e) {
      print('Error loading category data with preloaded subcategories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Helper: Fetch products for grocery category
  Future<void> _fetchProductsForGrocery() async {
    try {
      // Try cache first
      final cachedProducts = await _cacheService.getCachedProducts(
        categoryId: currentCategory.id,
      );

      if (cachedProducts != null) {
        allProducts.value = cachedProducts;
        displayProducts.value = cachedProducts;
        productsTitle.value = 'All ${currentCategory.title}';
        currentOffset.value = 0;
        hasMore.value = true;

        // Refresh in background
        _refreshProductsInBackground();
        return;
      }

      // Fetch from API
      final products = await _categoryService.fetchAllProductsByCategory(
        currentCategory.id,
        limit: 9,
      );

      allProducts.value = products;
      displayProducts.value = products;
      productsTitle.value = 'All ${currentCategory.title}';
      currentOffset.value = 0;
      hasMore.value = true;

      // Cache products
      await _cacheService.cacheProducts(
        categoryId: currentCategory.id,
        products: products,
      );
    } catch (e) {
      print('Error fetching products for grocery: $e');
    }
  }

  /// Helper: Fetch products for regular category
  Future<void> _fetchProductsForCategory() async {
    try {
      // Try cache first
      final cachedProducts = await _cacheService.getCachedProducts(
        categoryId: currentCategory.id,
      );

      if (cachedProducts != null) {
        allProducts.value = cachedProducts;
        displayProducts.value = cachedProducts;
        productsTitle.value = 'All ${currentCategory.title}';
        currentOffset.value = 0;
        hasMore.value = true;

        // Refresh in background
        _refreshProductsInBackground();
        return;
      }

      // Fetch from API
      final products = await _categoryService.fetchAllProductsByCategory(
        currentCategory.id,
        limit: 9,
      );

      allProducts.value = products;
      displayProducts.value = products;
      productsTitle.value = 'All ${currentCategory.title}';
      currentOffset.value = 0;
      hasMore.value = true;

      // Cache products
      await _cacheService.cacheProducts(
        categoryId: currentCategory.id,
        products: products,
      );
    } catch (e) {
      print('Error fetching products for category: $e');
    }
  }

  /// Helper: Load restaurants for food category
  Future<void> _loadRestaurants() async {
    try {
      final restaurants = await _restaurantService.getTopRestaurants(limit: 25);
      topRestaurants.value = restaurants;
      showRestaurants.value = true;
    } catch (e) {
      print('Error loading restaurants: $e');
    }
  }

  /// Helper: Refresh products in background
  Future<void> _refreshProductsInBackground() async {
    try {
      final products = await _categoryService.fetchAllProductsByCategory(
        currentCategory.id,
        limit: 9,
      );

      // Only update if data changed
      if (products.length != allProducts.length) {
        allProducts.value = products;
        displayProducts.value = products;

        // Update cache
        await _cacheService.cacheProducts(
          categoryId: currentCategory.id,
          products: products,
        );
      }
    } catch (e) {
      print('Error refreshing products in background: $e');
    }
  }

  Future<void> _loadFoodCategoryData() async {
    await _loadCategorySubcategories();

    final restaurants = await _restaurantService.getTopRestaurants(limit: 25);
    topRestaurants.value = restaurants;
    showRestaurants.value = true;
  }

  Future<void> _loadGroceryMainCategories() async {
    // Try to get cached data in parallel
    final results = await Future.wait([
      _cacheService.getCachedSubcategories(categoryId: currentCategory.id),
      _cacheService.getCachedProducts(categoryId: currentCategory.id),
    ]);

    final cachedSubcategories = results[0] as List<SubcategoryModel>?;
    final cachedProducts = results[1] as List<ProductModel>?;

    // If we have both cached data, use it immediately
    if (cachedSubcategories != null && cachedProducts != null) {
      print('✅ Using cached data for category: ${currentCategory.id}');
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

      // Fetch fresh data in background to update cache
      _refreshGroceryDataInBackground();
      return;
    }

    // If no cache, fetch from API in parallel
    print(
      '🌐 No cache found, fetching from API for category: ${currentCategory.id}',
    );

    // Fetch BOTH subcategories and products concurrently using Future.wait
    final apiResults = await Future.wait([
      _categoryService.fetchSubcategories(currentCategory.id),
      _categoryService.fetchAllProductsByCategory(currentCategory.id, limit: 9),
    ]);

    final mainCategories = apiResults[0] as List<SubcategoryModel>;
    final products = apiResults[1] as List<ProductModel>;

    // Update all data at once
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

    // Cache both in parallel
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

  /// Refresh grocery data in background (after showing cached data)
  Future<void> _refreshGroceryDataInBackground() async {
    try {
      // Fetch both subcategories and products in parallel
      final results = await Future.wait([
        _categoryService.fetchSubcategories(currentCategory.id),
        _categoryService.fetchAllProductsByCategory(
          currentCategory.id,
          limit: 9,
        ),
      ]);

      final mainCategories = results[0] as List<SubcategoryModel>;
      final products = results[1] as List<ProductModel>;

      // Update cache with fresh data in parallel
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

      // Only update UI if data has changed
      if (mainCategories.length != allCategories.length ||
          products.length != allProducts.length) {
        allCategories.value = mainCategories;
        availableSubcategories.value = mainCategories;
        allProducts.value = products;
        displayProducts.value = products;
      }
    } catch (e) {
      print('Error refreshing grocery data in background: $e');
    }
  }

  Future<void> _loadCategorySubcategories() async {
    // Try to get cached data in parallel
    final results = await Future.wait([
      _cacheService.getCachedSubcategories(categoryId: currentCategory.id),
      _cacheService.getCachedProducts(categoryId: currentCategory.id),
    ]);

    final cachedSubcategories = results[0] as List<SubcategoryModel>?;
    final cachedProducts = results[1] as List<ProductModel>?;

    // If we have both cached data, use it immediately
    if (cachedSubcategories != null && cachedProducts != null) {
      print('✅ Using cached data for category: ${currentCategory.id}');
      allCategories.value = cachedSubcategories;
      availableSubcategories.value = cachedSubcategories;
      sectionTitle.value = 'Popular Items';

      allProducts.value = cachedProducts;
      displayProducts.value = cachedProducts;
      productsTitle.value = 'All ${currentCategory.title}';

      selectedSubcategory.value = null;
      currentOffset.value = 0;
      hasMore.value = true;

      // Fetch fresh data in background to update cache
      _refreshCategoryDataInBackground();
      return;
    }

    // If no cache, fetch from API
    print(
      '🌐 No cache found, fetching from API for category: ${currentCategory.id}',
    );

    // Fetch BOTH subcategories and products concurrently using Future.wait
    final apiResults = await Future.wait([
      _categoryService.fetchSubcategories(currentCategory.id),
      _categoryService.fetchAllProductsByCategory(currentCategory.id, limit: 9),
    ]);

    final subcategories = apiResults[0] as List<SubcategoryModel>;
    final products = apiResults[1] as List<ProductModel>;

    // Update all data at once
    allCategories.value = subcategories;
    availableSubcategories.value = subcategories;
    sectionTitle.value = 'Popular Items';
    selectedSubcategory.value = null;
    currentOffset.value = 0;
    hasMore.value = true;

    allProducts.value = products;
    displayProducts.value = products;
    productsTitle.value = 'All ${currentCategory.title}';

    // Cache both in parallel
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

    // TODO: Recommended products will come from API later
    // if (!isGroceryCategory) {
    //   await _loadRecommendedProducts();
    // }
  }

  /// Refresh category data in background (after showing cached data)
  Future<void> _refreshCategoryDataInBackground() async {
    try {
      // Fetch both subcategories and products in parallel
      final results = await Future.wait([
        _categoryService.fetchSubcategories(currentCategory.id),
        _categoryService.fetchAllProductsByCategory(
          currentCategory.id,
          limit: 9,
        ),
      ]);

      final subcategories = results[0] as List<SubcategoryModel>;
      final products = results[1] as List<ProductModel>;

      // Update cache with fresh data in parallel
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

      // Only update UI if data has changed
      if (subcategories.length != allCategories.length ||
          products.length != allProducts.length) {
        allCategories.value = subcategories;
        availableSubcategories.value = subcategories;
        allProducts.value = products;
        displayProducts.value = products;
      }
    } catch (e) {
      print('Error refreshing category data in background: $e');
    }
  }

  // TODO: Re-enable when recommended products API is ready
  // Future<void> _loadRecommendedProducts() async {
  //   try {
  //     final products = await _categoryService.fetchRecommendedProducts(
  //       currentCategory.id,
  //       limit: 8, // Only load 8 recommended products
  //     );
  //     recommendedProducts.value = products;
  //   } catch (e) {
  //     print('Error loading recommended products: $e');
  //   }
  // }

  void onSubcategoryTap(SubcategoryModel? subcategory) async {
    try {
      // Handle "All" option
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

      // Check if we already have products for this subcategory
      final existingProducts = allProducts
          .where((p) => p.subcategoryId == subcategory.id)
          .toList();

      if (existingProducts.isNotEmpty) {
        // We already have products for this subcategory, just filter them
        print(
          '✅ Filtering existing products for subcategory: ${subcategory.id}',
        );
        selectedSubcategory.value = subcategory;
        showingAllProducts.value = false;
        currentOffset.value = 0;
        hasMore.value = existingProducts.length > 9;
        displayProducts.value = existingProducts.take(9).toList();
        productsTitle.value = '${subcategory.title} Items';
        return;
      }

      // Try to get cached products for this subcategory
      final cachedProducts = await _cacheService.getCachedProducts(
        categoryId: currentCategory.id,
        subcategoryId: subcategory.id,
      );

      if (cachedProducts != null) {
        print('✅ Using cached products for subcategory: ${subcategory.id}');
        selectedSubcategory.value = subcategory;
        showingAllProducts.value = false;
        currentOffset.value = 0;
        hasMore.value = true;

        // Add to allProducts if not already there
        for (var product in cachedProducts) {
          if (!allProducts.any((p) => p.id == product.id)) {
            allProducts.add(product);
          }
        }
        displayProducts.value = cachedProducts;
        productsTitle.value = '${subcategory.title} Items';

        // Fetch fresh data in background
        _refreshSubcategoryDataInBackground(subcategory);
        return;
      }

      // If we don't have cached products, fetch from API
      print('🌐 Fetching products from API for subcategory: ${subcategory.id}');
      isLoadingProducts.value = true;

      if (isFoodCategory) {
        // For food category, fetch only 9 products for the subcategory
        selectedSubcategory.value = subcategory;
        showingAllProducts.value = false;
        currentOffset.value = 0;
        hasMore.value = true;

        final products = await _productDataService.getProductsBySubcategory(
          subcategory.id,
          limit: 9,
          categoryId: currentCategory.id, // Pass category ID
        );
        // Add to allProducts if not already there
        for (var product in products) {
          if (!allProducts.any((p) => p.id == product.id)) {
            allProducts.add(product);
          }
        }
        displayProducts.value = products;
        productsTitle.value = '${subcategory.title} Items';

        // Cache the fetched products
        await _cacheService.cacheProducts(
          categoryId: currentCategory.id,
          subcategoryId: subcategory.id,
          products: products,
        );
      } else if (isMedicineCategory) {
        // For medicine category, fetch only 9 products for the subcategory
        selectedSubcategory.value = subcategory;
        showingAllProducts.value = false;
        currentOffset.value = 0;
        hasMore.value = true;

        final products = await _productDataService.getProductsBySubcategory(
          subcategory.id,
          limit: 9,
          categoryId: currentCategory.id, // Pass category ID
        );
        // Add to allProducts if not already there
        for (var product in products) {
          if (!allProducts.any((p) => p.id == product.id)) {
            allProducts.add(product);
          }
        }
        displayProducts.value = products;
        productsTitle.value = '${subcategory.title} Items';

        // Cache the fetched products
        await _cacheService.cacheProducts(
          categoryId: currentCategory.id,
          subcategoryId: subcategory.id,
          products: products,
        );
      } else if (currentCategory.id == '2' ||
          currentCategory.id == '3' ||
          currentCategory.id == '4' ||
          currentCategory.id == '5') {
        // For groceries/cleaning/personal/pet categories, fetch from API
        selectedSubcategory.value = subcategory;
        showingAllProducts.value = false;
        currentOffset.value = 0;
        hasMore.value = true;

        final products = await _productDataService.getProductsBySubcategory(
          subcategory.id,
          limit: 9,
          categoryId: currentCategory.id, // Pass category ID
        );
        // Add to allProducts if not already there
        for (var product in products) {
          if (!allProducts.any((p) => p.id == product.id)) {
            allProducts.add(product);
          }
        }
        displayProducts.value = products;
        productsTitle.value = '${subcategory.title} Items';

        // Cache the fetched products
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
    } catch (e) {
      print('Error loading subcategory: $e');
    } finally {
      isLoadingProducts.value = false;
    }
  }

  /// Refresh subcategory data in background (after showing cached data)
  Future<void> _refreshSubcategoryDataInBackground(
    SubcategoryModel subcategory,
  ) async {
    try {
      final products = await _productDataService.getProductsBySubcategory(
        subcategory.id,
        limit: 9,
        categoryId: currentCategory.id,
      );

      // Update cache with fresh data
      await _cacheService.cacheProducts(
        categoryId: currentCategory.id,
        subcategoryId: subcategory.id,
        products: products,
      );

      // Only update UI if we're still on the same subcategory and data has changed
      if (selectedSubcategory.value?.id == subcategory.id &&
          products.length != displayProducts.length) {
        // Add to allProducts if not already there
        for (var product in products) {
          if (!allProducts.any((p) => p.id == product.id)) {
            allProducts.add(product);
          }
        }
        displayProducts.value = products;
      }
    } catch (e) {
      print('Error refreshing subcategory data in background: $e');
    }
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
    Get.find<FavoritesController>().toggleFavorite(product);

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

  Future<void> showAllProducts() async {
    print(
      '🎬 showAllProducts called - current state: ${showingAllProducts.value}',
    );
    showingAllProducts.value = !showingAllProducts.value;

    if (showingAllProducts.value) {
      print('📖 Showing ALL products mode');
      // Load more products when showing all
      currentOffset.value = 0;
      hasMore.value = true;

      // For API-driven categories (food, medicine, groceries, cleaning, personal, pet)
      // we already have the initial products loaded, just set the flag to enable pagination
      if (isFoodCategory ||
          isMedicineCategory ||
          currentCategory.id == '2' ||
          currentCategory.id == '3' ||
          currentCategory.id == '4' ||
          currentCategory.id == '5') {
        print('✅ API-driven category - pagination enabled');
        // Keep current displayProducts, pagination will add more on scroll
        if (selectedSubcategory.value != null) {
          productsTitle.value =
              '${selectedSubcategory.value!.title} - All Items';
        } else {
          productsTitle.value = '${currentCategory.title} - All Items';
        }
        return;
      }

      // For static categories, show all loaded products
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
      print('📕 Hiding ALL products mode - back to 9 items');
      // Reset to initial 9 products
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

  void clearSubcategorySelection() {
    selectedSubcategory.value = null;
    showingAllProducts.value = false;

    // Reset pagination state for API-driven categories
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

    // Reset pagination state for API-driven categories
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

    // For API-driven categories, refetch with proper pagination reset
    if (isFoodCategory ||
        isMedicineCategory ||
        currentCategory.id == '2' ||
        currentCategory.id == '3' ||
        currentCategory.id == '4' ||
        currentCategory.id == '5') {
      currentOffset.value = 0;
      hasMore.value = true;

      if (selectedSubcategory.value != null) {
        // Keep the first 9 items of the current subcategory
        displayProducts.value = allProducts.take(9).toList();
      } else {
        displayProducts.value = allProducts.take(9).toList();
      }
    } else {
      // For static categories, filter from allProducts
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

  /// Force refresh data and update cache
  Future<void> refreshData() async {
    try {
      isLoading.value = true;

      // Clear cache for current category
      await _cacheService.clearCache(
        categoryId: currentCategory.id,
        subcategoryId: selectedSubcategory.value?.id,
      );

      // Reload data
      if (isGroceryCategory) {
        await _loadGroceryMainCategories();
      } else if (isFoodCategory) {
        await _loadFoodCategoryData();
      } else {
        await _loadCategorySubcategories();
      }
    } catch (e) {
      print('Error refreshing data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more products with pagination (for infinite scroll)
  Future<void> loadMoreProducts() async {
    print(
      '🔄 loadMoreProducts called - isLoadingMore: ${isLoadingMore.value}, hasMore: ${hasMore.value}',
    );

    if (isLoadingMore.value || !hasMore.value) {
      print(
        '❌ Skipping loadMoreProducts - isLoadingMore: ${isLoadingMore.value}, hasMore: ${hasMore.value}',
      );
      return;
    }

    try {
      isLoadingMore.value = true;

      final nextOffset = displayProducts.length;
      print(
        '📊 Fetching more products - Category: ${currentCategory.id}, Subcategory: ${selectedSubcategory.value?.id}, Offset: $nextOffset, Limit: 20',
      );

      final result = await _productDataService.fetchMoreProducts(
        categoryId: currentCategory.id,
        subcategoryId: selectedSubcategory.value?.id,
        offset: nextOffset,
        limit: 20,
      );

      final newProducts = result['products'] as List<ProductModel>;
      hasMore.value = result['hasMore'] as bool;

      print(
        '✅ Received ${newProducts.length} products, hasMore: ${hasMore.value}',
      );

      if (newProducts.isNotEmpty) {
        allProducts.addAll(newProducts);
        // Apply current filters and sorting to new products
        _applyFiltersAndSearch();
        print('📦 Total products now: ${displayProducts.length}');
      } else {
        print('⚠️ No new products received');
      }
    } catch (e) {
      print('❌ Error loading more products: $e');
    } finally {
      isLoadingMore.value = false;
      print(
        '🏁 loadMoreProducts completed - isLoadingMore: ${isLoadingMore.value}',
      );
    }
  }
}
