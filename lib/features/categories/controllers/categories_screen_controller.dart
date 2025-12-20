import 'package:get/get.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';
import 'package:quikle_user/features/categories/data/services/category_service.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';
import 'package:quikle_user/features/home/data/services/home_services.dart';
import 'package:quikle_user/routes/app_routes.dart';

class CategoriesScreenController extends GetxController {
  final CategoryService _categoryService = CategoryService();
  final HomeService _homeService = HomeService();

  final _categories = <CategoryModel>[].obs;
  final _subcategories = <SubcategoryModel>[].obs;
  final _isLoading = false.obs;

  List<CategoryModel> get categories => _categories;
  List<SubcategoryModel> get subcategories => _subcategories;
  bool get isLoading => _isLoading.value;

  // Get category icon path
  String? getCategoryIconPath(String categoryId) {
    try {
      final category = _categories.firstWhere((cat) => cat.id == categoryId);
      return category.iconPath;
    } catch (e) {
      return null;
    }
  }

  // Get category title
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
    _loadInitialData();
  }

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }

  Future<void> _loadInitialData() async {
    _isLoading.value = true;
    try {
      // Fetch categories first
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

      // Load all subcategories in parallel for better performance
      await _loadAllSubcategoriesParallel();
    } catch (e) {
      print('Error loading initial data: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    return _loadInitialData();
  }

  /// Optimized: Load all subcategories in parallel instead of sequentially
  Future<void> _loadAllSubcategoriesParallel() async {
    _subcategories.clear();

    // Get all categories except 'All'
    final categoriesToFetch = _categories.where((c) => c.id != '0').toList();

    if (categoriesToFetch.isEmpty) return;

    try {
      // Fetch all subcategories in parallel using Future.wait
      final results = await Future.wait(
        categoriesToFetch.map((category) {
          return _categoryService.fetchSubcategories(category.id).catchError((
            e,
          ) {
            print(
              'Error loading subcategories for category ${category.id}: $e',
            );
            return <SubcategoryModel>[]; // Return empty list on error
          });
        }),
      );

      // Flatten all results into a single list
      for (var subcategoryList in results) {
        _subcategories.addAll(subcategoryList);
      }
    } catch (e) {
      print('Error loading subcategories in parallel: $e');
    }
  }

  void onSubcategoryPressed(SubcategoryModel subcategory) {
    // Navigate to unified category screen and auto-select the subcategory
    final category = _categories.firstWhere(
      (cat) => cat.id == subcategory.categoryId,
    );

    // For grocery category (id == '2'), navigate to CategoryProductsScreen
    // because grocery has sub-subcategories
    if (category.id == '2') {
      print(
        '🛒 Navigating to grocery sub-subcategory screen for: ${subcategory.title}',
      );
      Get.toNamed(
        AppRoute.getCategoryProducts(),
        arguments: {'category': category, 'mainCategory': subcategory},
      );
      return;
    }

    // For other categories, navigate to unified category screen
    // Get all subcategories for this category to pass along
    final categorySubcategories = _subcategories
        .where((sub) => sub.categoryId == category.id)
        .toList();

    Get.toNamed(
      AppRoute.getUnifiedCategory(),
      arguments: {
        'category': category,
        'autoSelectSubcategory': subcategory, // Pass subcategory to auto-select
        'preloadedSubcategories':
            categorySubcategories, // Pass already-loaded subcategories
      },
    );
  }

  void onViewAllPressed(String categoryId) {
    // Navigate to unified category screen for the whole category
    final category = _categories.firstWhere((cat) => cat.id == categoryId);

    // Get all subcategories for this category to pass along
    final categorySubcategories = _subcategories
        .where((sub) => sub.categoryId == category.id)
        .toList();

    Get.toNamed(
      AppRoute.getUnifiedCategory(),
      arguments: {
        'category': category,
        'preloadedSubcategories':
            categorySubcategories, // Pass already-loaded subcategories
      },
    );
  }

  // Group subcategories by category
  Map<String, List<SubcategoryModel>> get groupedSubcategories {
    final Map<String, List<SubcategoryModel>> grouped = {};

    for (final subcategory in _subcategories) {
      if (!grouped.containsKey(subcategory.categoryId)) {
        grouped[subcategory.categoryId] = [];
      }
      grouped[subcategory.categoryId]!.add(subcategory);
    }

    return grouped;
  }
}
