import 'package:get/get.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';
import 'package:quikle_user/features/categories/data/services/category_service.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/routes/app_routes.dart';

class MainCategoryProductsController extends GetxController {
  final CategoryService _categoryService = CategoryService();
  late final CartController _cartController;

  // Arguments from navigation
  late final SubcategoryModel subcategory;
  late final CategoryModel category;
  late final bool showAllProducts;

  // Observables
  final isLoading = false.obs;
  final subcategoryTitle = ''.obs;
  final subcategoryDescription = ''.obs;
  final products = <ProductModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;
  final availableSubcategories = <SubcategoryModel>[].obs;
  final selectedFilter = Rxn<String>(); // null means "All"

  @override
  void onInit() {
    super.onInit();
    _cartController = Get.find<CartController>();

    // Get arguments from navigation
    final arguments = Get.arguments as Map<String, dynamic>;
    subcategory = arguments['subcategory'] as SubcategoryModel;
    category = arguments['category'] as CategoryModel;
    showAllProducts = arguments['showAllProducts'] as bool? ?? false;

    subcategoryTitle.value = subcategory.title;
    subcategoryDescription.value = subcategory.description;

    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      if (showAllProducts) {
        // Load all products from all subcategories of this main category
        await _loadAllProductsFromMainCategory();
      } else {
        // Load products from specific subcategory
        final productList = await _categoryService.fetchProductsBySubcategory(
          subcategory.id,
        );
        products.value = productList;
        filteredProducts.value = productList;
      }
    } catch (e) {
      print('Error loading products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadAllProductsFromMainCategory() async {
    try {
      // Use the service method to get all products for this main category
      final allProducts = await _categoryService.fetchProductsByMainCategory(
        subcategory.id,
      );

      // Also load the subcategories for filtering
      List<SubcategoryModel> subcategories = [];
      if (subcategory.id == 'grocery_produce') {
        subcategories = await _categoryService.fetchProduceSubcategories();
      }
      // TODO: Add other main categories (cooking, meats, oils, etc.)

      products.value = allProducts;
      filteredProducts.value = allProducts;
      availableSubcategories.value = subcategories;
    } catch (e) {
      print('Error loading all products from main category: $e');
    }
  }

  void filterBySubcategory(String? subcategoryId) {
    selectedFilter.value = subcategoryId;

    if (subcategoryId == null) {
      // Show all products
      filteredProducts.value = products;
    } else {
      // Filter by specific subcategory
      filteredProducts.value = products
          .where((product) => product.subcategoryId == subcategoryId)
          .toList();
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
    // Handle favorite toggle
    final updatedProduct = product.copyWith(isFavorite: !product.isFavorite);

    // Update in products list
    final productIndex = products.indexWhere((p) => p.id == product.id);
    if (productIndex != -1) {
      products[productIndex] = updatedProduct;
    }

    // Update in filtered products list
    final filteredIndex = filteredProducts.indexWhere(
      (p) => p.id == product.id,
    );
    if (filteredIndex != -1) {
      filteredProducts[filteredIndex] = updatedProduct;
    }

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
}
