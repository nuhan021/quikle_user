import 'package:get/get.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';
import 'package:quikle_user/features/categories/data/services/category_service.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/routes/app_routes.dart';

class GroceryNavigationController extends GetxController {
  final CategoryService _categoryService = CategoryService();
  late final CartController _cartController;

  // Arguments from navigation
  late final CategoryModel category;

  // Navigation state
  final currentLevel =
      0.obs; // 0: main categories, 1: subcategories, 2: products
  final currentParentId = ''.obs;
  final currentTitle = 'Groceries'.obs;
  final breadcrumb = ''.obs;
  final canGoBack = false.obs;

  // Observables
  final isLoading = false.obs;
  final popularSubcategories = <SubcategoryModel>[].obs;
  final currentSubcategories = <SubcategoryModel>[].obs;
  final currentProducts = <ProductModel>[].obs;

  // Navigation history
  final List<NavigationLevel> _history = [];

  @override
  void onInit() {
    super.onInit();
    _cartController = Get.find<CartController>();

    // Get category from arguments
    category = Get.arguments as CategoryModel;
    currentTitle.value = category.title;

    _loadMainCategories();
  }

  Future<void> _loadMainCategories() async {
    isLoading.value = true;
    try {
      // Load grocery main categories
      final mainCategories = await _categoryService
          .fetchGroceryMainCategories();
      currentSubcategories.value = mainCategories;

      // Load popular subcategories
      final popular = await _categoryService.fetchPopularSubcategories(
        category.id,
      );
      popularSubcategories.value = popular;

      // Reset navigation state
      currentLevel.value = 0;
      canGoBack.value = false;
      breadcrumb.value = '';
      _history.clear();
    } catch (e) {
      print('Error loading main categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onSubcategoryTap(SubcategoryModel subcategory) async {
    isLoading.value = true;

    try {
      // Check if this subcategory has children
      final children = await _categoryService.fetchSubcategories(
        category.id,
        parentSubcategoryId: subcategory.id,
      );

      if (children.isNotEmpty) {
        // Navigate to subcategories
        _pushLevel(
          NavigationLevel(
            title: subcategory.title,
            parentId: subcategory.id,
            level: currentLevel.value + 1,
            subcategories: currentSubcategories.toList(),
          ),
        );

        currentSubcategories.value = children;
        currentProducts.clear();
        currentLevel.value++;
        currentTitle.value = subcategory.title;
        _updateBreadcrumb();
        canGoBack.value = true;

        // Hide popular items for deeper levels
        if (currentLevel.value > 0) {
          popularSubcategories.clear();
        }
      } else {
        // Navigate to products
        final products = await _categoryService.fetchProductsBySubcategory(
          subcategory.id,
        );

        if (products.isNotEmpty) {
          _pushLevel(
            NavigationLevel(
              title: currentTitle.value,
              parentId: currentParentId.value,
              level: currentLevel.value,
              subcategories: currentSubcategories.toList(),
            ),
          );

          currentProducts.value = products;
          currentSubcategories.clear();
          popularSubcategories.clear();
          currentLevel.value = 2; // Products level
          currentTitle.value = subcategory.title;
          _updateBreadcrumb();
          canGoBack.value = true;
        } else {
          Get.snackbar(
            'No Products',
            'No products found in ${subcategory.title}',
            duration: const Duration(seconds: 2),
          );
        }
      }
    } catch (e) {
      print('Error navigating to subcategory: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void goToMainCategories() {
    _loadMainCategories();
  }

  void goBack() {
    if (_history.isNotEmpty) {
      final previous = _history.removeLast();
      currentLevel.value = previous.level;
      currentTitle.value = previous.title;
      currentParentId.value = previous.parentId;
      currentSubcategories.value = previous.subcategories;
      currentProducts.clear();

      _updateBreadcrumb();
      canGoBack.value = _history.isNotEmpty;

      // Restore popular items for main level
      if (currentLevel.value == 0) {
        _loadPopularSubcategories();
      }
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

  void _pushLevel(NavigationLevel level) {
    _history.add(level);
  }

  void _updateBreadcrumb() {
    if (currentLevel.value == 0) {
      breadcrumb.value = '';
    } else if (currentLevel.value == 1) {
      breadcrumb.value = 'Groceries';
    } else {
      // Build full breadcrumb path
      final parts = ['Groceries'];
      if (_history.isNotEmpty) {
        parts.add(_history.last.title);
      }
      parts.add(currentTitle.value);
      breadcrumb.value = parts.join(' > ');
    }
  }

  Future<void> _loadPopularSubcategories() async {
    try {
      final popular = await _categoryService.fetchPopularSubcategories(
        category.id,
      );
      popularSubcategories.value = popular;
    } catch (e) {
      print('Error loading popular subcategories: $e');
    }
  }
}

class NavigationLevel {
  final String title;
  final String parentId;
  final int level;
  final List<SubcategoryModel> subcategories;

  NavigationLevel({
    required this.title,
    required this.parentId,
    required this.level,
    required this.subcategories,
  });
}
