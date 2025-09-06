import 'package:get/get.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';
import 'package:quikle_user/features/categories/data/services/category_service.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';

class UnifiedCategoryController extends GetxController {
  final CategoryService _categoryService = CategoryService();
  final CartController _cartController = Get.find<CartController>();

  // Observables
  final isLoading = false.obs;
  final categoryTitle = ''.obs;
  final productsTitle = 'All Products'.obs;
  final sectionTitle = ''.obs; // Dynamic title for the selection section

  // Category management
  final availableSubcategories = <SubcategoryModel>[].obs;
  final filterSubcategories = <SubcategoryModel>[].obs;
  final allProducts = <ProductModel>[].obs;
  final displayProducts = <ProductModel>[].obs;

  // Selection state
  final selectedMainCategory = Rxn<SubcategoryModel>();
  final selectedSubcategory = Rxn<SubcategoryModel>();
  final selectedFilter = Rxn<String>();
  final showingAllProducts = false.obs;

  // Category type
  late CategoryModel currentCategory;
  bool get isGroceryCategory =>
      currentCategory.id == '2'; // Grocery category ID

  // Check if any subcategory is selected - if yes, show combined section
  bool get shouldShowCombinedSection => selectedSubcategory.value != null;

  @override
  void onInit() {
    super.onInit();

    // Get category from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['category'] != null) {
      currentCategory = args['category'] as CategoryModel;
      categoryTitle.value = currentCategory.title;
      _loadCategoryData();
    }
  }

  Future<void> _loadCategoryData() async {
    try {
      isLoading.value = true;

      if (isGroceryCategory) {
        // For groceries: Load main categories first
        await _loadGroceryMainCategories();
      } else {
        // For other categories: Load subcategories directly
        await _loadCategorySubcategories();
      }
    } catch (e) {
      print('Error loading category data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadGroceryMainCategories() async {
    final mainCategories = await _categoryService.fetchGroceryMainCategories();
    availableSubcategories.value = mainCategories;
    sectionTitle.value = 'Select Category';

    // Load all products for the grocery category to show in sections
    final products = await _categoryService.fetchAllProductsByCategory(
      currentCategory.id,
    );
    allProducts.value = products;
    displayProducts.value = products; // Show all products initially

    // Don't auto-select any main category initially - show all products in separate sections
    selectedSubcategory.value = null;
    productsTitle.value = '${currentCategory.title} Items';
  }

  Future<void> _loadCategorySubcategories() async {
    final subcategories = await _categoryService.fetchSubcategories(
      currentCategory.id,
    );
    availableSubcategories.value = subcategories;
    sectionTitle.value = 'Popular Items';

    // For non-grocery categories, immediately load all products
    final products = await _categoryService.fetchAllProductsByCategory(
      currentCategory.id,
    );
    allProducts.value = products;
    displayProducts.value = products; // Show all products initially

    // Don't auto-select any subcategory initially - show all products in separate sections
    selectedSubcategory.value = null;
    productsTitle.value = '${currentCategory.title} Items';
  }

  void onSubcategoryTap(SubcategoryModel subcategory) async {
    try {
      isLoading.value = true;

      if (isGroceryCategory) {
        if (selectedMainCategory.value == null) {
          // First level: Main category selection (e.g., Produce)
          selectedMainCategory.value = subcategory;
          selectedSubcategory.value = null;
          selectedFilter.value = null;

          // Load subcategories for the selected main category
          final subCategories = await _categoryService.fetchSubcategories(
            currentCategory.id,
            parentSubcategoryId: subcategory.id,
          );
          filterSubcategories.value = subCategories;

          // Load all products for this main category
          final products = await _categoryService.fetchProductsByMainCategory(
            subcategory.id,
          );
          allProducts.value = products;
          displayProducts.value = products;
          productsTitle.value = 'All ${subcategory.title}';

          // Keep available subcategories but update them to show the subcategories instead
          availableSubcategories.value = subCategories;
          sectionTitle.value = 'Select from ${subcategory.title}';
        } else {
          // Second level: Subcategory selection (e.g., Vegetables)
          selectedSubcategory.value = subcategory;
          applyFilter(subcategory.id);
        }
      } else {
        // For non-grocery categories: Select subcategory and filter products
        selectedSubcategory.value = subcategory;
        final filteredProducts = allProducts
            .where(
              (product) =>
                  product.subcategoryId != null &&
                  product.subcategoryId == subcategory.id,
            )
            .toList();
        displayProducts.value = filteredProducts;
        productsTitle.value = '${subcategory.title} Items for you';
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
      // Show all products for the main category
      displayProducts.value = allProducts;
      productsTitle.value = selectedMainCategory.value != null
          ? 'All ${selectedMainCategory.value!.title}'
          : 'All Products';
    } else {
      // Filter products by subcategory
      final filteredProducts = allProducts
          .where(
            (product) =>
                product.subcategoryId != null &&
                product.subcategoryId == subcategoryId,
          )
          .toList();
      displayProducts.value = filteredProducts;

      // Update title
      final selectedSubcat = filterSubcategories.firstWhereOrNull(
        (subcat) => subcat.id == subcategoryId,
      );
      productsTitle.value = selectedSubcat != null
          ? '${selectedSubcat.title} Items for you'
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
      displayProducts.clear();
      allProducts.clear();

      // Reload main categories
      await _loadGroceryMainCategories();
    } catch (e) {
      print('Error resetting to main categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onProductTap(ProductModel product) {
    // Navigate to product details
    Get.toNamed('/product-details', arguments: {'product': product});
  }

  void onAddToCart(ProductModel product) {
    _cartController.addToCart(product);
    Get.snackbar(
      'Added to Cart',
      '${product.title} has been added to your cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void onFavoriteToggle(ProductModel product) {
    final updatedProduct = product.copyWith(isFavorite: !product.isFavorite);

    // Update in all lists
    _updateProductInLists(updatedProduct);

    Get.snackbar(
      updatedProduct.isFavorite
          ? 'Added to Favorites'
          : 'Removed from Favorites',
      '${updatedProduct.title} ${updatedProduct.isFavorite ? 'added to' : 'removed from'} favorites',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _updateProductInLists(ProductModel updatedProduct) {
    // Update in all products list
    final allIndex = allProducts.indexWhere((p) => p.id == updatedProduct.id);
    if (allIndex != -1) {
      allProducts[allIndex] = updatedProduct;
    }

    // Update in display products list
    final displayIndex = displayProducts.indexWhere(
      (p) => p.id == updatedProduct.id,
    );
    if (displayIndex != -1) {
      displayProducts[displayIndex] = updatedProduct;
    }
  }

  // Navigation helper for back button
  void onBackPressed() {
    if (isGroceryCategory && selectedMainCategory.value != null) {
      // Go back to main categories
      resetToMainCategories();
    } else {
      Get.back();
    }
  }

  // Show all products functionality
  void showAllProducts() {
    showingAllProducts.value = !showingAllProducts.value;
    if (showingAllProducts.value) {
      // Reset any subcategory filter to show all products
      selectedSubcategory.value = null;
      displayProducts.value = allProducts;
      productsTitle.value = '${currentCategory.title} - All Items';
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
        productsTitle.value = selectedSubcategory.value!.title;
      } else {
        displayProducts.value = allProducts;
        productsTitle.value = '${currentCategory.title} Items';
      }
    }
  }
}
