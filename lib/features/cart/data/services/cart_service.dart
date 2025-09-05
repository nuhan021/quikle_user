import '../models/cart_item_model.dart';
import '../../../home/data/models/product_model.dart';

class CartService {
  final List<CartItemModel> _cartItems = [];

  List<CartItemModel> get cartItems => List.unmodifiable(_cartItems);

  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  void addToCart(ProductModel product) {
    final existingItemIndex = _cartItems.indexWhere(
      (item) =>
          item.product.title == product.title &&
          item.product.categoryId == product.categoryId,
    );

    if (existingItemIndex != -1) {
      final existingItem = _cartItems[existingItemIndex];
      _cartItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      _cartItems.add(CartItemModel(product: product, quantity: 1));
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
}
