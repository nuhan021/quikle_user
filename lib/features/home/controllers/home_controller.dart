import 'package:get/get.dart';
import 'package:quikle_user/core/services/suggested_products_service.dart';
import 'package:quikle_user/features/home/data/services/home_services.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/profile/controllers/favorites_controller.dart';
import 'package:quikle_user/routes/app_routes.dart';
import 'package:quikle_user/core/mixins/voice_search_mixin.dart';
import '../data/models/category_model.dart';
import '../data/models/product_model.dart';

class HomeController extends GetxController with VoiceSearchMixin {
  final HomeService _homeService = HomeService();
  late final CartController _cartController;
  final _selectedCategoryId = '0'.obs;
  final _categories = <CategoryModel>[].obs;
  final _products = <ProductModel>[].obs;
  final _productSections = <ProductSectionModel>[].obs;
  final _filteredProducts = <ProductModel>[].obs;
  final _isLoading = false.obs;
  String get selectedCategoryId => _selectedCategoryId.value;
  List<CategoryModel> get categories => _categories;
  List<ProductModel> get products => _products;
  List<ProductSectionModel> get productSections => _productSections;
  List<ProductModel> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading.value;
  bool get isShowingAllCategories => _selectedCategoryId.value == '0';
  String? getCategoryIconPath(String categoryId) {
    try {
      final category = _categories.firstWhere((cat) => cat.id == categoryId);
      return category.iconPath;
    } catch (e) {
      return null;
    }
  }

  String? getCategoryTitle(String categoryId) {
    try {
      final category = _categories.firstWhere((cat) => cat.id == categoryId);
      return category.title;
    } catch (e) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _cartController = Get.find<CartController>();
    _loadInitialData();
  }

  Future<void> saveFCMToken() async {
    try {
      await _homeService.saveFCMToken();
    } catch (e) {
      print('Error saving FCM Token: $e');
    }
  }

  Future<void> _loadInitialData() async {
    _isLoading.value = true;
    try {
      _categories.value = await _homeService.fetchCategories();

      // Sort categories to ensure All, Food, Groceries, Medicine are first
      List<CategoryModel> sortedCategories = [];
      sortedCategories.addAll(_categories.where((c) => c.title == 'All'));
      sortedCategories.addAll(_categories.where((c) => c.title == 'Food'));
      sortedCategories.addAll(_categories.where((c) => c.title == 'Groceries'));
      sortedCategories.addAll(_categories.where((c) => c.title == 'Medicine'));
      sortedCategories.addAll(
        _categories.where(
          (c) => !['All', 'Food', 'Groceries', 'Medicine'].contains(c.title),
        ),
      );
      _categories.value = sortedCategories;
      _products.value = await _homeService.fetchAllProducts();
      await _loadContent();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    return _loadInitialData();
  }

  Future<void> _loadContent() async {
    // Preload suggested products
    final suggestedProductsService = Get.put(SuggestedProductsService());
    await suggestedProductsService.preloadSuggestedProducts();
    if (_selectedCategoryId.value == '0') {
      _productSections.value = await _homeService.fetchProductSections();
      // Sort product sections by category order
      _productSections.sort((a, b) {
        final catA = _categories.indexWhere((c) => c.id == a.categoryId);
        final catB = _categories.indexWhere((c) => c.id == b.categoryId);
        return catA.compareTo(catB);
      });
      _filteredProducts.clear();
    } else {
      _filteredProducts.value = _products
          .where((product) => product.categoryId == _selectedCategoryId.value)
          .toList();
      _productSections.clear();
    }
  }

  Future<List<CategoryModel>> fetchCategories() async {
    return _categories.isNotEmpty
        ? _categories
        : await _homeService.fetchCategories();
  }

  Future<List<ProductModel>> fetchProducts() async {
    return _filteredProducts.isNotEmpty
        ? _filteredProducts
        : await _homeService.fetchAllProducts();
  }

  Future<List<ProductSectionModel>> fetchProductSections() async {
    return _productSections.isNotEmpty
        ? _productSections
        : await _homeService.fetchProductSections();
  }

  void onNotificationPressed() {}

  void onSearchPressed() {
    Get.toNamed(AppRoute.getSearch());
  }

  Future<void> onVoiceSearchPressed() async {
    await startVoiceSearch(navigateToSearch: true);
  }

  Future<void> onCategoryPressed(CategoryModel category) async {
    if (category.id != '0') {
      Get.toNamed(
        AppRoute.getUnifiedCategory(),
        arguments: {'category': category},
      );
    } else {
      _selectedCategoryId.value = category.id;
      await _loadContent();
    }
  }

  void onProductPressed(ProductModel product) {
    Get.toNamed(AppRoute.getProductDetails(), arguments: product);
  }

  void onAddToCartPressed(ProductModel product) {
    _cartController.addToCart(product);
  }

  void onFavoriteToggle(ProductModel product) {
    Get.find<FavoritesController>().toggleFavorite(product);

    final isFavorite = FavoritesController.isProductFavorite(product.id);
    final updatedProduct = product.copyWith(isFavorite: isFavorite);
    _updateProductInLists(product, updatedProduct);

    // Get.snackbar(
    //   isFavorite ? 'Added to Favorites' : 'Removed from Favorites',
    //   isFavorite
    //       ? '${product.title} has been added to your favorites.'
    //       : '${product.title} has been removed from your favorites.',
    //   snackPosition: SnackPosition.BOTTOM,
    //   duration: const Duration(seconds: 2),
    // );
  }

  void _updateProductInLists(ProductModel oldProduct, ProductModel newProduct) {
    final productIndex = _products.indexWhere((p) => p.id == oldProduct.id);
    if (productIndex != -1) {
      _products[productIndex] = newProduct;
    }
    final filteredIndex = _filteredProducts.indexWhere(
      (p) => p.id == oldProduct.id,
    );
    if (filteredIndex != -1) {
      _filteredProducts[filteredIndex] = newProduct;
    }
    for (
      int sectionIndex = 0;
      sectionIndex < _productSections.length;
      sectionIndex++
    ) {
      final section = _productSections[sectionIndex];
      final productInSectionIndex = section.products.indexWhere(
        (p) => p.id == oldProduct.id,
      );

      if (productInSectionIndex != -1) {
        final updatedProducts = List<ProductModel>.from(section.products);
        updatedProducts[productInSectionIndex] = newProduct;
        final updatedSection = ProductSectionModel(
          id: section.id,
          viewAllText: section.viewAllText,
          products: updatedProducts,
          categoryId: section.categoryId,
        );

        _productSections[sectionIndex] = updatedSection;
      }
    }
    update();
  }

  void onViewAllPressed(String categoryId) {
    final category = _categories.firstWhere((cat) => cat.id == categoryId);

    if (categoryId != '0') {
      Get.toNamed(
        AppRoute.getUnifiedCategory(),
        arguments: {'category': category},
      );
    } else {
      onCategoryPressed(category);
    }
  }

  void onShopNowPressed() {}
}
