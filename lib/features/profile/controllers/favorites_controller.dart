import 'package:get/get.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/profile/services/favorites_service.dart';
import 'package:quikle_user/core/data/services/product_data_service.dart';

class FavoritesController extends GetxController {
  static final RxSet<String> _globalFavoriteIds = <String>{}.obs;

  final RxList<ProductModel> _favoriteProducts = <ProductModel>[].obs;

  List<ProductModel> get favoriteProducts => _favoriteProducts;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  static bool isProductFavorite(String productId) {
    return _globalFavoriteIds.contains(productId);
  }

  static void addToGlobalFavorites(String productId) {
    _globalFavoriteIds.add(productId);
  }

  static void removeFromGlobalFavorites(String productId) {
    _globalFavoriteIds.remove(productId);
  }

  static Set<String> get globalFavoriteIds => _globalFavoriteIds;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();

    ever(_globalFavoriteIds, (_) {
      refreshFavorites();
    });
  }

  Future<void> loadFavorites() async {
    try {
      _isLoading.value = true;

      final favorites = await FavoritesService().getFavorites();
      final itemIds = favorites.map((f) => f['item_id'].toString()).toSet();
      _globalFavoriteIds.assignAll(itemIds);

      await refreshFavorites();
    } catch (e) {
      print('Error loading favorites: $e');
      _favoriteProducts.clear();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshFavorites() async {
    try {
      final productService = ProductDataService();
      final products = <ProductModel>[];

      for (final id in _globalFavoriteIds) {
        final product = await productService.getProductById(id);
        if (product != null) {
          products.add(product);
        }
      }

      _favoriteProducts.assignAll(products);
    } catch (e) {
      print('Error refreshing favorites: $e');
      _favoriteProducts.clear();
    }
  }

  Future<void> addToFavorites(ProductModel product) async {
    final itemId = int.tryParse(product.id);
    if (itemId != null) {
      final result = await FavoritesService().addToFavorites(itemId);
      if (result != null) {
        addToGlobalFavorites(product.id);
        // refreshFavorites will be called by ever
      } else {
        // Handle failure, maybe show error
        print('Failed to add favorite');
      }
    } else {
      print('Invalid product id: ${product.id}');
    }
  }

  void removeFromFavorites(String productId) async {
    final itemId = int.tryParse(productId);
    if (itemId != null) {
      final success = await FavoritesService().removeFromFavorites(itemId);
      if (success) {
        removeFromGlobalFavorites(productId);
        // refreshFavorites will be called by ever
      } else {
        print('Failed to remove favorite');
      }
    } else {
      print('Invalid product id: $productId');
    }
  }

  void toggleFavorite(ProductModel product) async {
    if (isProductFavorite(product.id)) {
      removeFromFavorites(product.id);
    } else {
      await addToFavorites(product);
    }
  }

  void clearAllFavorites() {
    _globalFavoriteIds.clear();
    _favoriteProducts.clear();
  }

  bool isFavorite(String productId) {
    return isProductFavorite(productId);
  }
}
