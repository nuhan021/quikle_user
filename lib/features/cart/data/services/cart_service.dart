import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';
import '../../../home/data/models/product_model.dart';

class CartService {
  static const String _cartCacheKey = 'cart_items_cache';
  final List<CartItemModel> _cartItems = [];

  List<CartItemModel> get cartItems => List.unmodifiable(_cartItems);

  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Initialize cart service and load cached cart items
  Future<void> initialize() async {
    await _loadCartFromCache();
  }

  /// Load cart items from cache
  Future<void> _loadCartFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartCacheKey);

      if (cartJson != null) {
        final List<dynamic> cartList = jsonDecode(cartJson) as List;
        _cartItems.clear();
        _cartItems.addAll(
          cartList
              .map(
                (item) => CartItemModel.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
        );
        print('📦 Loaded ${_cartItems.length} items from cart cache');
      }
    } catch (e) {
      print('Error loading cart from cache: $e');
    }
  }

  /// Save cart items to cache
  Future<void> _saveCartToCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = jsonEncode(
        _cartItems.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_cartCacheKey, cartJson);
      print('💾 Saved ${_cartItems.length} items to cart cache');
    } catch (e) {
      print('Error saving cart to cache: $e');
    }
  }

  void addToCart(ProductModel product, {bool isUrgent = false}) async {
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex != -1) {
      final existingItem = _cartItems[existingItemIndex];
      _cartItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
        isUrgent:
            existingItem.isUrgent || isUrgent, // Keep urgent if already urgent
      );
    } else {
      // Only mark medicine items as urgent automatically
      final isMedicineProduct = product.isPrescriptionMedicine || product.isOTC;
      final shouldBeUrgent = isUrgent || (isMedicineProduct && hasUrgentItems);
      _cartItems.add(
        CartItemModel(product: product, quantity: 1, isUrgent: shouldBeUrgent),
      );
    }

    await _saveCartToCache();
  }

  void removeFromCart(CartItemModel cartItem) async {
    _cartItems.removeWhere((item) => item.product.id == cartItem.product.id);

    await _saveCartToCache();
  }

  void updateQuantity(CartItemModel cartItem, int newQuantity) async {
    if (newQuantity <= 0) {
      removeFromCart(cartItem);
      return;
    }

    final itemIndex = _cartItems.indexWhere(
      (item) => item.product.id == cartItem.product.id,
    );

    if (itemIndex != -1) {
      _cartItems[itemIndex] = cartItem.copyWith(quantity: newQuantity);
    }

    await _saveCartToCache();
  }

  void clearCart() async {
    _cartItems.clear();
    await _saveCartToCache();
  }

  // Get the quantity of a specific product in the cart
  int getProductQuantity(ProductModel product) {
    final item = _cartItems.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItemModel(product: product, quantity: 0),
    );
    return item.quantity;
  }

  // Check if a product is in the cart
  bool isProductInCart(ProductModel product) {
    return _cartItems.any((item) => item.product.id == product.id);
  }

  // Get a cart item for a specific product
  CartItemModel? getCartItemForProduct(ProductModel product) {
    try {
      return _cartItems.firstWhere((item) => item.product.id == product.id);
    } catch (e) {
      return null;
    }
  }

  // Toggle urgent status for a specific product
  void toggleProductUrgentStatus(ProductModel product) async {
    final itemIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (itemIndex != -1) {
      final existingItem = _cartItems[itemIndex];
      _cartItems[itemIndex] = existingItem.copyWith(
        isUrgent: !existingItem.isUrgent,
      );

      await _saveCartToCache();
    }
  }

  // Check if there are any urgent items in cart
  bool get hasUrgentItems => _cartItems.any((item) => item.isUrgent);

  // Check if a specific product is marked as urgent in cart
  bool isProductUrgent(ProductModel product) {
    final item = getCartItemForProduct(product);
    return item?.isUrgent ?? false;
  }

  // Update urgent status for all medicine items
  void updateAllMedicineItemsUrgentStatus(bool isUrgent) async {
    bool hasChanges = false;

    for (int i = 0; i < _cartItems.length; i++) {
      final item = _cartItems[i];
      final isMedicine =
          item.product.isPrescriptionMedicine || item.product.isOTC;

      if (isMedicine && item.isUrgent != isUrgent) {
        _cartItems[i] = item.copyWith(isUrgent: isUrgent);
        hasChanges = true;
      }
    }

    if (hasChanges) {
      await _saveCartToCache();
    }
  }
}
