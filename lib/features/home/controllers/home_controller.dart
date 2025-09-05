import 'package:get/get.dart';
import 'package:quikle_user/features/home/data/services/home_services.dart';
import '../data/models/category_model.dart';
import '../data/models/product_model.dart';

class HomeController extends GetxController {
  final HomeService _homeService = HomeService();

  // Observable variables
  final _selectedCategoryId = 0.obs; // 0 = "All"
  final _categories = <CategoryModel>[].obs;
  final _products = <ProductModel>[].obs;
  final _productSections = <ProductSectionModel>[].obs;
  final _filteredProducts = <ProductModel>[].obs;
  final _isLoading = false.obs;

  // Getters
  int get selectedCategoryId => _selectedCategoryId.value;
  List<CategoryModel> get categories => _categories;
  List<ProductModel> get products => _products;
  List<ProductSectionModel> get productSections => _productSections;
  List<ProductModel> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading.value;
  bool get isShowingAllCategories => _selectedCategoryId.value == 0;

  // Helper method to get category icon path by ID
  String? getCategoryIconPath(int categoryId) {
    try {
      final category = _categories.firstWhere((cat) => cat.id == categoryId);
      return category.iconPath;
    } catch (e) {
      return null; // Return null if category not found
    }
  }

  // Helper method to get category title by ID
  String? getCategoryTitle(int categoryId) {
    try {
      final category = _categories.firstWhere((cat) => cat.id == categoryId);
      return category.title;
    } catch (e) {
      return null; // Return null if category not found
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _isLoading.value = true;
    try {
      _categories.value = await _homeService.fetchCategories();
      _products.value = await _homeService.fetchAllProducts();
      await _loadContent();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadContent() async {
    if (_selectedCategoryId.value == 0) {
      // "All" category - show product sections (6 items each)
      _productSections.value = await _homeService.fetchProductSections();
      _filteredProducts.clear();
    } else {
      // Specific category - show filtered products
      _filteredProducts.value = _products
          .where((product) => product.categoryId == _selectedCategoryId.value)
          .toList();
      _productSections.clear();
    }
  }

  // Legacy methods for compatibility (kept for FutureBuilder if needed)
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

  // Handle actions
  void onNotificationPressed() {
    // Handle notification tap
  }

  void onSearchPressed() {
    // Handle search tap
  }

  Future<void> onCategoryPressed(CategoryModel category) async {
    _selectedCategoryId.value = category.id;
    await _loadContent();
  }

  void onProductPressed(ProductModel product) {
    // Handle product tap
  }

  void onAddToCartPressed(ProductModel product) {
    // Handle add to cart
    Get.snackbar(
      'Added to Cart',
      '${product.title} has been added to your cart.',
    );
  }

  void onFavoriteToggle(ProductModel product) {
    // Create updated product with toggled favorite state
    final updatedProduct = product.copyWith(isFavorite: !product.isFavorite);

    // Update the product in all lists
    _updateProductInLists(product, updatedProduct);

    // Show user feedback
    Get.snackbar(
      updatedProduct.isFavorite
          ? 'Added to Favorites'
          : 'Removed from Favorites',
      updatedProduct.isFavorite
          ? '${product.title} has been added to your favorites.'
          : '${product.title} has been removed from your favorites.',
      duration: const Duration(seconds: 2),
    );
  }

  // Helper method to update product in all relevant lists
  void _updateProductInLists(ProductModel oldProduct, ProductModel newProduct) {
    // Update in main products list
    final productIndex = _products.indexWhere(
      (p) =>
          p.title == oldProduct.title &&
          p.categoryId == oldProduct.categoryId &&
          p.price == oldProduct.price,
    );
    if (productIndex != -1) {
      _products[productIndex] = newProduct;
    }

    // Update in filtered products list
    final filteredIndex = _filteredProducts.indexWhere(
      (p) =>
          p.title == oldProduct.title &&
          p.categoryId == oldProduct.categoryId &&
          p.price == oldProduct.price,
    );
    if (filteredIndex != -1) {
      _filteredProducts[filteredIndex] = newProduct;
    }

    // Update in product sections
    for (
      int sectionIndex = 0;
      sectionIndex < _productSections.length;
      sectionIndex++
    ) {
      final section = _productSections[sectionIndex];
      final productInSectionIndex = section.products.indexWhere(
        (p) =>
            p.title == oldProduct.title &&
            p.categoryId == oldProduct.categoryId &&
            p.price == oldProduct.price,
      );

      if (productInSectionIndex != -1) {
        // Create a new list with updated product
        final updatedProducts = List<ProductModel>.from(section.products);
        updatedProducts[productInSectionIndex] = newProduct;

        // Create new section with updated products
        final updatedSection = ProductSectionModel(
          viewAllText: section.viewAllText,
          products: updatedProducts,
          categoryId: section.categoryId,
        );

        _productSections[sectionIndex] = updatedSection;
      }
    }

    // Trigger UI update
    update();
  }

  void onViewAllPressed(int categoryId) {
    // Handle view all tap for a specific category
    final category = _categories.firstWhere((cat) => cat.id == categoryId);
    onCategoryPressed(category);
  }

  void onShopNowPressed() {
    // Handle shop now tap
  }
}
