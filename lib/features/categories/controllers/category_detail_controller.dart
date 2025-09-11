import 'package:get/get.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';
import 'package:quikle_user/features/categories/data/services/category_service.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/profile/controllers/favorites_controller.dart';
import 'package:quikle_user/routes/app_routes.dart';

class CategoryDetailController extends GetxController {
  final CategoryService _categoryService = CategoryService();
  late final CartController _cartController;

  // Arguments from navigation
  late final CategoryModel category;

  // Observables
  final isLoading = false.obs;
  final categoryTitle = ''.obs;
  final popularSubcategories = <SubcategoryModel>[].obs;
  final allSubcategories =
      <SubcategoryModel>[].obs; // All subcategories of selected category
  final featuredProducts = <ProductModel>[].obs;
  final recommendedProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _cartController = Get.find<CartController>();

    // Get category from arguments
    category = Get.arguments as CategoryModel;
    categoryTitle.value = category.title;

    _loadCategoryData();
  }

  Future<void> _loadCategoryData() async {
    isLoading.value = true;
    try {
      // Load data in parallel
      await Future.wait([
        _loadPopularSubcategories(),
        _loadAllSubcategories(),
        _loadFeaturedProducts(),
        _loadRecommendedProducts(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadPopularSubcategories() async {
    try {
      if (category.id == '2') {
        // For groceries, load main categories as popular items
        final subcategories = await _categoryService
            .fetchGroceryMainCategories();
        popularSubcategories.value = subcategories;
      } else {
        // For food, load popular subcategories
        final subcategories = await _categoryService.fetchPopularSubcategories(
          category.id,
        );
        popularSubcategories.value = subcategories;
      }
    } catch (e) {
      print('Error loading popular subcategories: $e');
    }
  }

  Future<void> _loadAllSubcategories() async {
    try {
      if (category.id == '2') {
        // For groceries, load all subcategories (vegetables, fruits, etc.)
        final produceSubcategories = await _categoryService
            .fetchProduceSubcategories();
        allSubcategories.value = produceSubcategories;

        // TODO: Add subcategories for other main categories like Cooking, Meats, etc.
      } else {
        // For food, this might be empty or contain additional subcategories
        allSubcategories.clear();
      }
    } catch (e) {
      print('Error loading all subcategories: $e');
    }
  }

  Future<void> _loadFeaturedProducts() async {
    try {
      if (category.id == '2') {
        // For groceries, load all subcategories of main categories
        final allSubcategories = <SubcategoryModel>[];

        // Load subcategories for each main category
        final produceSubcategories = await _categoryService
            .fetchProduceSubcategories();
        allSubcategories.addAll(produceSubcategories);

        // You can add more subcategories for other main categories here
        // final cookingSubcategories = await _categoryService.fetchCookingSubcategories();
        // allSubcategories.addAll(cookingSubcategories);

        // Convert subcategories to show as "featured" section
        featuredProducts.clear();
        // We'll use the subcategories in a different way - see the modified screen
      } else {
        // For food, load featured products
        final products = await _categoryService.fetchFeaturedProducts(
          category.id,
        );
        featuredProducts.value = products;
      }
    } catch (e) {
      print('Error loading featured products: $e');
    }
  }

  Future<void> _loadRecommendedProducts() async {
    try {
      final products = await _categoryService.fetchRecommendedProducts(
        category.id,
      );
      recommendedProducts.value = products;
    } catch (e) {
      print('Error loading recommended products: $e');
    }
  }

  void onSubcategoryTap(SubcategoryModel subcategory) {
    if (category.id == '2') {
      // For groceries
      if (subcategory.parentSubcategoryId == null) {
        // This is a main category (Produce, Cooking, Meats)
        // Navigate to show all products of this main category
        Get.toNamed(
          AppRoute.getMainCategoryProducts(),
          arguments: {
            'subcategory': subcategory,
            'category': category,
            'showAllProducts': true, // Show all products from all subcategories
          },
        );
      } else {
        // This is a specific subcategory (Vegetables, Fruits)
        // Navigate to show products of this specific subcategory
        Get.toNamed(
          AppRoute.getSubcategoryProducts(),
          arguments: {'subcategory': subcategory, 'category': category},
        );
      }
    } else {
      // For food categories, go directly to products
      Get.toNamed(
        AppRoute.getSubcategoryProducts(),
        arguments: {'subcategory': subcategory, 'category': category},
      );
    }
  }

  void onProductTap(ProductModel product) {
    // Navigate to product details screen
    Get.toNamed(AppRoute.getProductDetails(), arguments: product);
  }

  void onAddToCart(ProductModel product) {
    // Add product to cart
    _cartController.addToCart(product);
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

    // Update in featured products
    final featuredIndex = featuredProducts.indexWhere(
      (p) => p.id == product.id,
    );
    if (featuredIndex != -1) {
      featuredProducts[featuredIndex] = updatedProduct;
    }

    // Update in recommended products
    final recommendedIndex = recommendedProducts.indexWhere(
      (p) => p.id == product.id,
    );
    if (recommendedIndex != -1) {
      recommendedProducts[recommendedIndex] = updatedProduct;
    }

    Get.snackbar(
      isFavorite ? 'Added to Favorites' : 'Removed from Favorites',
      isFavorite
          ? '${product.title} has been added to your favorites.'
          : '${product.title} has been removed from your favorites.',
      duration: const Duration(seconds: 2),
    );
  }
}
