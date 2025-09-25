import '../models/cart_item_model.dart';
import '../../../home/data/models/product_model.dart';

class CartService {
  final List<CartItemModel> _cartItems = [];

  List<CartItemModel> get cartItems => List.unmodifiable(_cartItems);

  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  void addToCart(ProductModel product, {bool isUrgent = false}) {
    final existingItemIndex = _cartItems.indexWhere(
      (item) =>
          item.product.title == product.title &&
          item.product.categoryId == product.categoryId,
    );

    if (existingItemIndex != -1) {
      final existingItem = _cartItems[existingItemIndex];
      _cartItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
        isUrgent:
            existingItem.isUrgent || isUrgent, // Keep urgent if already urgent
      );
    } else {
      _cartItems.add(
        CartItemModel(product: product, quantity: 1, isUrgent: isUrgent),
      );
    }
  }

  void removeFromCart(CartItemModel cartItem) {
    _cartItems.removeWhere(
      (item) =>
          item.product.title == cartItem.product.title &&
          item.product.categoryId == cartItem.product.categoryId,
    );
  }

  void updateQuantity(CartItemModel cartItem, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(cartItem);
      return;
    }

    final itemIndex = _cartItems.indexWhere(
      (item) =>
          item.product.title == cartItem.product.title &&
          item.product.categoryId == cartItem.product.categoryId,
    );

    if (itemIndex != -1) {
      _cartItems[itemIndex] = cartItem.copyWith(quantity: newQuantity);
    }
  }

  void clearCart() {
    _cartItems.clear();
  }

  // Get the quantity of a specific product in the cart
  int getProductQuantity(ProductModel product) {
    final item = _cartItems.firstWhere(
      (item) =>
          item.product.title == product.title &&
          item.product.categoryId == product.categoryId,
      orElse: () => CartItemModel(product: product, quantity: 0),
    );
    return item.quantity;
  }

  // Check if a product is in the cart
  bool isProductInCart(ProductModel product) {
    return _cartItems.any(
      (item) =>
          item.product.title == product.title &&
          item.product.categoryId == product.categoryId,
    );
  }

  // Get a cart item for a specific product
  CartItemModel? getCartItemForProduct(ProductModel product) {
    try {
      return _cartItems.firstWhere(
        (item) =>
            item.product.title == product.title &&
            item.product.categoryId == product.categoryId,
      );
    } catch (e) {
      return null;
    }
  }

  // Toggle urgent status for a specific product
  void toggleProductUrgentStatus(ProductModel product) {
    final itemIndex = _cartItems.indexWhere(
      (item) =>
          item.product.title == product.title &&
          item.product.categoryId == product.categoryId,
    );

    if (itemIndex != -1) {
      final existingItem = _cartItems[itemIndex];
      _cartItems[itemIndex] = existingItem.copyWith(
        isUrgent: !existingItem.isUrgent,
      );
    }
  }

  // Check if there are any urgent items in cart
  bool get hasUrgentItems => _cartItems.any((item) => item.isUrgent);

  // Check if a specific product is marked as urgent in cart
  bool isProductUrgent(ProductModel product) {
    final item = getCartItemForProduct(product);
    return item?.isUrgent ?? false;
  }
}
