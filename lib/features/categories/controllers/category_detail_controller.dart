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

  late final CategoryModel category;

  final isLoading = false.obs;
  final categoryTitle = ''.obs;
  final popularSubcategories = <SubcategoryModel>[].obs;
  final allSubcategories = <SubcategoryModel>[].obs;
  final featuredProducts = <ProductModel>[].obs;
  final recommendedProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _cartController = Get.find<CartController>();

    category = Get.arguments as CategoryModel;
    categoryTitle.value = category.title;

    _loadCategoryData();
  }

  Future<void> _loadCategoryData() async {
    isLoading.value = true;
    try {
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
        final subcategories = await _categoryService
            .fetchGroceryMainCategories();
        popularSubcategories.value = subcategories;
      } else {
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
        final produceSubcategories = await _categoryService
            .fetchProduceSubcategories();
        allSubcategories.value = produceSubcategories;
      } else {
        allSubcategories.clear();
      }
    } catch (e) {
      print('Error loading all subcategories: $e');
    }
  }

  Future<void> _loadFeaturedProducts() async {
    try {
      if (category.id == '2') {
        final allSubcategories = <SubcategoryModel>[];

        final produceSubcategories = await _categoryService
            .fetchProduceSubcategories();
        allSubcategories.addAll(produceSubcategories);

        featuredProducts.clear();
      } else {
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
    Get.toNamed(
      AppRoute.getSubcategoryProducts(),
      arguments: {'subcategory': subcategory, 'category': category},
    );
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

    final featuredIndex = featuredProducts.indexWhere(
      (p) => p.id == product.id,
    );
    if (featuredIndex != -1) {
      featuredProducts[featuredIndex] = updatedProduct;
    }

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
