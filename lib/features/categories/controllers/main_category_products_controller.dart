import 'package:get/get.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';
import 'package:quikle_user/features/categories/data/services/category_service.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/profile/controllers/favorites_controller.dart';
import 'package:quikle_user/routes/app_routes.dart';

class MainCategoryProductsController extends GetxController {
  final CategoryService _categoryService = CategoryService();
  late final CartController _cartController;

  
  late final SubcategoryModel subcategory;
  late final CategoryModel category;
  late final bool showAllProducts;

  
  final isLoading = false.obs;
  final subcategoryTitle = ''.obs;
  final subcategoryDescription = ''.obs;
  final products = <ProductModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;
  final availableSubcategories = <SubcategoryModel>[].obs;
  final selectedFilter = Rxn<String>(); 

  @override
  void onInit() {
    super.onInit();
    _cartController = Get.find<CartController>();

    
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
        
        await _loadAllProductsFromMainCategory();
      } else {
        
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
      
      final allProducts = await _categoryService.fetchProductsByMainCategory(
        subcategory.id,
      );

      
      List<SubcategoryModel> subcategories = [];
      if (subcategory.id == 'grocery_produce') {
        subcategories = await _categoryService.fetchProduceSubcategories();
      }
      

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
      
      filteredProducts.value = products;
    } else {
      
      filteredProducts.value = products
          .where((product) => product.subcategoryId == subcategoryId)
          .toList();
    }
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

    
    final productIndex = products.indexWhere((p) => p.id == product.id);
    if (productIndex != -1) {
      products[productIndex] = updatedProduct;
    }

    
    final filteredIndex = filteredProducts.indexWhere(
      (p) => p.id == product.id,
    );
    if (filteredIndex != -1) {
      filteredProducts[filteredIndex] = updatedProduct;
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
