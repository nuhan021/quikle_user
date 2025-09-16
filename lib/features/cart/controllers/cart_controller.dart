import 'package:get/get.dart';
import '../data/models/cart_item_model.dart';
import '../data/services/cart_service.dart';
import '../../home/data/models/product_model.dart';
import '../presentation/widgets/cart_bottom_section.dart';

class CartController extends GetxController {
  final CartService _cartService = CartService();
  final _cartItems = <CartItemModel>[].obs;
  final _totalItems = 0.obs;
  final _totalAmount = 0.0.obs;
  List<CartItemModel> get cartItems => _cartItems;
  int get totalItems => _totalItems.value;
  double get totalAmount => _totalAmount.value;
  bool get hasItems => _cartItems.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _updateCartData();
  }

  void addToCart(ProductModel product) {
    _cartService.addToCart(product);
    _updateCartData();

    Get.snackbar(
      'Added to Cart',
      '${product.title} has been added to your cart.',
      duration: const Duration(seconds: 2),
    );
  }

  void removeFromCart(CartItemModel cartItem) {
    _cartService.removeFromCart(cartItem);
    _updateCartData();

    Get.snackbar(
      'Removed from Cart',
      '${cartItem.product.title} has been removed from your cart.',
      duration: const Duration(seconds: 2),
    );
  }

  void updateQuantity(CartItemModel cartItem, int newQuantity) {
    _cartService.updateQuantity(cartItem, newQuantity);
    _updateCartData();
  }

  void increaseQuantity(CartItemModel cartItem) {
    updateQuantity(cartItem, cartItem.quantity + 1);
  }

  void decreaseQuantity(CartItemModel cartItem) {
    updateQuantity(cartItem, cartItem.quantity - 1);
  }

  void clearCart() {
    _cartService.clearCart();
    _updateCartData();

    
    CartBottomSection.clearSelectedAddress();

    Get.snackbar(
      'Cart Cleared',
      'All items have been removed from your cart.',
      duration: const Duration(seconds: 2),
    );
  }

  void _updateCartData() {
    _cartItems.value = _cartService.cartItems;
    _totalItems.value = _cartService.totalItems;
    _totalAmount.value = _cartService.totalAmount;
  }

  void onCheckout() {
    if (hasItems) {
      
      
      Get.snackbar(
        'Ready for Checkout',
        'Please select payment method and place order.',
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'Empty Cart',
        'Please add items to cart before checkout.',
        duration: const Duration(seconds: 2),
      );
    }
  }
}
