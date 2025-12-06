import 'package:get/get.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/profile/services/favorites_service.dart';

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

    ever(_globalFavoriteIds, (Set<String> favoriteIds) {
      refreshFavorites();
    });
  }

  void loadFavorites() {
    try {
      _isLoading.value = true;

      if (_globalFavoriteIds.isEmpty) {
        _initializeSampleFavorites();
      }

      refreshFavorites();
    } catch (e) {
      print('Error loading favorites: $e');

      _favoriteProducts.clear();
    } finally {
      _isLoading.value = false;
    }
  }

  void _initializeSampleFavorites() {
    final sampleFavoriteIds = [
      'produce_fruits_1',
      'dairy_yogurt_1',
      'produce_fruits_2',
      'food_pizza_1',
      'produce_fruits_6',
      'dairy_milk_1',
    ];

    _globalFavoriteIds.addAll(sampleFavoriteIds);
  }

  void refreshFavorites() {
    try {
      // Static data removed - favorites should be fetched from API
      // For now, just clear the list
      _favoriteProducts.clear();
    } catch (e) {
      print('Error refreshing favorites: $e');
      _favoriteProducts.clear();
    }
  }

  Future<void> addToFavorites(ProductModel product) async {
    final itemId = int.tryParse(product.id);
    if (itemId != null) {
      final success = await FavoritesService().addToFavorites(itemId);
      if (success) {
        addToGlobalFavorites(product.id);
        refreshFavorites();
      } else {
        // Handle failure, maybe show error
        print('Failed to add favorite');
      }
    } else {
      print('Invalid product id: ${product.id}');
    }
  }

  void removeFromFavorites(String productId) {
    removeFromGlobalFavorites(productId);
    refreshFavorites();
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
