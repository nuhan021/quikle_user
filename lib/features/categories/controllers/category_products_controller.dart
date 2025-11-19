import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/home/data/models/shop_model.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';
import 'package:quikle_user/features/categories/data/services/category_service.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/profile/controllers/favorites_controller.dart';
import 'package:quikle_user/routes/app_routes.dart';
import 'package:quikle_user/core/mixins/voice_search_mixin.dart';
import 'package:quikle_user/core/data/services/product_data_service.dart';

class CategoryProductsController extends GetxController with VoiceSearchMixin {
  final CategoryService _categoryService = CategoryService();
  final ProductDataService _productDataService = ProductDataService();
  final CartController _cartController = Get.find<CartController>();

  final isLoading = false.obs;
  final categoryTitle = ''.obs;
  final subcategories = <SubcategoryModel>[].obs;
  final allProducts = <ProductModel>[].obs;
  final displayProducts = <ProductModel>[].obs;
  final shops = <String, ShopModel>{}.obs;

  final selectedSubcategory = Rxn<SubcategoryModel>();
  final searchQuery = ''.obs;

  // Pagination state
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final currentOffset = 0.obs;

  final currentPlaceholder = "Search products...".obs;
  Timer? _placeholderTimer;

  late CategoryModel currentCategory;
  late SubcategoryModel currentMainCategory;
  bool get isGroceryCategory => currentCategory.id == '2';

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
    if (args != null) {
      currentCategory = args['category'] as CategoryModel;
      currentMainCategory = args['mainCategory'] as SubcategoryModel;
      categoryTitle.value = currentMainCategory.title;
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

      final subCategories = await _categoryService.fetchSubcategories(
        currentCategory.id,
        parentSubcategoryId: currentMainCategory.id,
      );
      subcategories.value = subCategories;

      // For groceries category (2), fetch from API with pagination
      if (currentCategory.id == '2') {
        print('🛒 Loading groceries subcategory data from API');
        final products = await _productDataService.getProductsBySubcategory(
          currentMainCategory.id, // subcategory ID
          categoryId: currentCategory.id,
          limit: 12, // Initial load: 12 items
        );
        allProducts.value = products;
        displayProducts.value = products;
        currentOffset.value = products.length;
        hasMore.value =
            products.length >= 12; // If we got 12, there might be more
        print('✅ Loaded ${products.length} products initially');
      } else {
        // For other categories, use the old method
        final products = await _categoryService.fetchProductsByMainCategory(
          currentMainCategory.id,
        );
        allProducts.value = products;
        displayProducts.value = products;
      }
    } catch (e) {
      print('Error loading category data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onSubcategoryTap(SubcategoryModel? subcategory) async {
    if (subcategory == null) {
      // "All" option selected - show all products from subcategory
      selectedSubcategory.value = null;

      if (currentCategory.id == '2') {
        // For groceries, reload all products for the main subcategory with pagination
        try {
          isLoading.value = true;
          currentOffset.value = 0;
          hasMore.value = true;

          print(
            '🛒 Reloading all products for subcategory: ${currentMainCategory.id}',
          );

          final products = await _productDataService.getProductsBySubcategory(
            currentMainCategory.id,
            categoryId: currentCategory.id,
            limit: 12, // Load 12 initially
          );

          displayProducts.value = products;
          currentOffset.value = products.length;
          hasMore.value = products.length >= 12;

          print('✅ Loaded ${products.length} products for "All"');
        } catch (e) {
          print('❌ Error loading all products: $e');
        } finally {
          isLoading.value = false;
        }
      } else {
        displayProducts.value = allProducts;
      }
      return;
    }

    if (selectedSubcategory.value?.id == subcategory.id) {
      selectedSubcategory.value = null;

      if (currentCategory.id == '2') {
        // Reload all products
        try {
          isLoading.value = true;
          currentOffset.value = 0;
          hasMore.value = true;

          final products = await _productDataService.getProductsBySubcategory(
            currentMainCategory.id,
            categoryId: currentCategory.id,
            limit: 12,
          );

          displayProducts.value = products;
          currentOffset.value = products.length;
          hasMore.value = products.length >= 10;
        } catch (e) {
          print('❌ Error: $e');
        } finally {
          isLoading.value = false;
        }
      } else {
        displayProducts.value = allProducts;
      }
      return;
    }

    selectedSubcategory.value = subcategory;

    // For groceries category (2), fetch from API with sub_subcategory parameter
    if (currentCategory.id == '2') {
      try {
        isLoading.value = true;
        currentOffset.value = 0;
        hasMore.value = true;

        print(
          '🛒 Fetching products for sub_subcategory: ${subcategory.id} under subcategory: ${currentMainCategory.id}',
        );

        final products = await _productDataService.getProductsBySubcategory(
          currentMainCategory.id, // This is the subcategory ID
          categoryId: currentCategory.id,
          subSubcategoryId: subcategory.id, // This is the sub_subcategory ID
          limit: 12, // Load 10 initially
        );

        displayProducts.value = products;
        currentOffset.value = products.length;
        hasMore.value =
            products.length >= 12; // If we got 10, there might be more

        print('✅ Loaded ${products.length} products for sub_subcategory');
      } catch (e) {
        print('❌ Error loading sub_subcategory products: $e');
        // Fallback to filter from allProducts
        _filterProductsBySubcategory(subcategory.id);
      } finally {
        isLoading.value = false;
      }
    } else {
      // For other categories, filter from existing products
      _filterProductsBySubcategory(subcategory.id);
    }
  }

  void _filterProductsBySubcategory(String subcategoryId) {
    displayProducts.value = allProducts
        .where((product) => product.subcategoryId == subcategoryId)
        .toList();
  }

  Future<void> loadMoreProducts() async {
    // Only load more for groceries category
    if (currentCategory.id != '2') {
      return;
    }

    if (isLoadingMore.value || !hasMore.value) {
      print(
        '⏭️ Skipping loadMore - isLoadingMore: ${isLoadingMore.value}, hasMore: ${hasMore.value}',
      );
      return;
    }

    try {
      isLoadingMore.value = true;
      final offset = displayProducts.length;
      print('📥 Loading more products - Offset: $offset');

      final result = await _productDataService.fetchMoreProducts(
        categoryId: currentCategory.id,
        subcategoryId: currentMainCategory.id,
        subSubcategoryId: selectedSubcategory.value?.id,
        offset: offset,
        limit: 15,
      );

      final newProducts = result['products'] as List<ProductModel>;
      hasMore.value = result['hasMore'] as bool;

      if (newProducts.isNotEmpty) {
        displayProducts.addAll(newProducts);
        currentOffset.value = displayProducts.length;
        print(
          '✅ Loaded ${newProducts.length} more products. Total: ${displayProducts.length}',
        );
      } else {
        print('⚠️ No more products to load');
        hasMore.value = false;
      }
    } catch (e) {
      print('❌ Error loading more products: $e');
      hasMore.value = false;
    } finally {
      isLoadingMore.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      if (selectedSubcategory.value != null) {
        _filterProductsBySubcategory(selectedSubcategory.value!.id);
      } else {
        displayProducts.value = allProducts;
      }
      return;
    }

    List<ProductModel> baseProducts = selectedSubcategory.value != null
        ? allProducts
              .where(
                (product) =>
                    product.subcategoryId == selectedSubcategory.value!.id,
              )
              .toList()
        : allProducts;

    displayProducts.value = baseProducts
        .where(
          (product) =>
              product.title.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  void onProductTap(ProductModel product) {
    Get.toNamed(AppRoute.getProductDetails(), arguments: product);
  }

  void onAddToCart(ProductModel product) {
    _cartController.addToCart(product);
  }

  void onFavoriteToggle(ProductModel product) {
    final favController = Get.find<FavoritesController>();
    favController.toggleFavorite(product);
  }

  Future<void> onVoiceSearchPressed() async {
    await startVoiceSearch(navigateToSearch: true);
  }
}
