import 'package:flutter/material.dart';
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
  }

  // 🔥 FIXED: Load favorites directly into ProductModel
  Future<void> loadFavorites() async {
    try {
      _isLoading.value = true;

      // Already returns List<ProductModel>
      final products = await FavoritesService().getFavoriteProducts();

      final favIds = <String>{};

      for (final product in products) {
        favIds.add(product.id);
      }

      _favoriteProducts.assignAll(products);
      _globalFavoriteIds.assignAll(favIds);
    } catch (e) {
      print('Error loading favorites: $e');
      _favoriteProducts.clear();
    } finally {
      _isLoading.value = false;
    }
  }

  // 🔥 FIXED: Refresh uses already loaded models (no API)
  Future<void> refreshFavorites() async {
    _favoriteProducts.removeWhere((p) => !_globalFavoriteIds.contains(p.id));
  }

  Future<bool> addToFavorites(ProductModel product) async {
    final itemId = int.tryParse(product.id);
    if (itemId != null) {
      final result = await FavoritesService().addToFavorites(itemId);
      if (result != null) {
        _globalFavoriteIds.add(product.id);
        product = product.copyWith(isFavorite: true);
        _favoriteProducts.add(product);
        return true;
      }
    }
    return false;
  }

  Future<bool> removeFromFavorites(String productId) async {
    final itemId = int.tryParse(productId);
    if (itemId != null) {
      final success = await FavoritesService().removeFromFavorites(itemId);
      if (success) {
        _globalFavoriteIds.remove(productId);
        _favoriteProducts.removeWhere((p) => p.id == productId);
        return true;
      }
    }
    return false;
  }

  void toggleFavorite(ProductModel product) async {
    if (isProductFavorite(product.id)) {
      final success = await removeFromFavorites(product.id);
      if (success) {
        _showFavoritePopup('${product.title} removed from favorites', false);
      }
    } else {
      final success = await addToFavorites(product);
      if (success) {
        _showFavoritePopup('${product.title} added to favorites', true);
      }
    }
  }

  void _showFavoritePopup(String message, bool isAdded) {
    Get.defaultDialog(
      title: isAdded ? 'Added to Favorites' : 'Removed from Favorites',
      middleText: message,
      backgroundColor: isAdded ? Colors.green.shade100 : Colors.red.shade100,
      titleStyle: TextStyle(color: isAdded ? Colors.green : Colors.red),
      middleTextStyle: TextStyle(color: Colors.black),
      barrierDismissible: true,
    );
    // Auto close after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    });
  }

  void clearAllFavorites() {
    _globalFavoriteIds.clear();
    _favoriteProducts.clear();
  }

  bool isFavorite(String productId) {
    return isProductFavorite(productId);
  }
}
