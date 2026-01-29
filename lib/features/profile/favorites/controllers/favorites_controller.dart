import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/profile/favorites/services/favorites_service.dart';

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
        _showFavoritePopup(
          '${product.title} removed from favorites',
          isAdded: false,
        );
      }
    } else {
      final success = await addToFavorites(product);
      if (success) {
        _showFavoritePopup(
          '${product.title} added to favorites',
          isAdded: true,
        );
      }
    }
  }

  void _showFavoritePopup(String message, {required bool isAdded}) {
    final bgColor = isAdded ? Colors.green.shade100 : Colors.red.shade100;
    final iconColor = isAdded ? Colors.green : Colors.red;

    Get.rawSnackbar(
      snackStyle: SnackStyle.FLOATING,
      borderRadius: 12.0,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      backgroundColor: Colors.transparent,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      shouldIconPulse: false,
      // messageText contains a glassy BackdropFilter container
      messageText: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: bgColor.withOpacity(0.85),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: Colors.white.withOpacity(0.6),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.95),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(.6),
                      width: 0.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(Icons.favorite, size: 20, color: iconColor),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      font: CustomFonts.obviously,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void clearAllFavorites() {
    _globalFavoriteIds.clear();
    _favoriteProducts.clear();
  }

  bool isFavorite(String productId) {
    return isProductFavorite(productId);
  }
}
