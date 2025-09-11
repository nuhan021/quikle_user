import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quikle_user/features/home/data/services/home_services.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/profile/controllers/favorites_controller.dart';
import 'package:quikle_user/routes/app_routes.dart';
import 'package:quikle_user/features/search/controllers/search_controller.dart';
import '../data/models/category_model.dart';
import '../data/models/product_model.dart';

class HomeController extends GetxController {
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
    if (_selectedCategoryId.value == '0') {
      _productSections.value = await _homeService.fetchProductSections();
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

  void onNotificationPressed() {
    // Handle notification tap
  }

  void onSearchPressed() {
    // Navigate to search screen
    Get.toNamed(AppRoute.getSearch());
  }

  Future<void> onVoiceSearchPressed() async {
    final speechToText = SpeechToText();

    try {
      // Request microphone permission
      final permissionStatus = await Permission.microphone.request();

      if (permissionStatus != PermissionStatus.granted) {
        Get.snackbar(
          'Permission Denied',
          'Microphone permission is required for voice search.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Initialize speech recognition
      final available = await speechToText.initialize(
        onError: (errorNotification) {
          Get.snackbar(
            'Voice Recognition Error',
            'Could not recognize speech. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        },
      );

      if (!available) {
        Get.snackbar(
          'Voice Search Unavailable',
          'Speech recognition is not available on this device.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return;
      }

      // Navigate to search screen with voice recognition
      Get.toNamed(AppRoute.getSearch());

      // Give some time for the screen transition, then start voice recognition
      await Future.delayed(const Duration(milliseconds: 500));

      // Find the search controller and start voice recognition
      await Future.delayed(const Duration(milliseconds: 300));
      final searchController = ProductSearchController.currentInstance;
      if (searchController != null) {
        await searchController.toggleVoiceRecognition();
      }
    } catch (e) {
      print('Error in voice search: $e');
      Get.snackbar(
        'Voice Search Error',
        'An error occurred while starting voice search.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> onCategoryPressed(CategoryModel category) async {
    // Navigate to unified category screen for all categories except "All"
    if (category.id != '0') {
      Get.toNamed(
        AppRoute.getUnifiedCategory(),
        arguments: {'category': category},
      );
    } else {
      // For "All" category, filter on the home page
      _selectedCategoryId.value = category.id;
      await _loadContent();
    }
  }

  void onProductPressed(ProductModel product) {
    // Navigate to product details screen
    Get.toNamed(AppRoute.getProductDetails(), arguments: product);
  }

  void onAddToCartPressed(ProductModel product) {
    // Handle add to cart using cart controller
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
    _updateProductInLists(product, updatedProduct);

    Get.snackbar(
      isFavorite ? 'Added to Favorites' : 'Removed from Favorites',
      isFavorite
          ? '${product.title} has been added to your favorites.'
          : '${product.title} has been removed from your favorites.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
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

    // Navigate to unified category screen for all categories except "All"
    if (categoryId != '0') {
      Get.toNamed(
        AppRoute.getUnifiedCategory(),
        arguments: {'category': category},
      );
    } else {
      // For "All" category, just filter on the home page
      onCategoryPressed(category);
    }
  }

  void onShopNowPressed() {
    // Handle shop now tap
  }
}
