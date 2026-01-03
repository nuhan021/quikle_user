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
  final _isPlacingOrder = false.obs;
  List<CartItemModel> get cartItems => _cartItems;
  RxList<CartItemModel> get cartItemsObservable => _cartItems;
  int get totalItems => _totalItems.value;
  double get totalAmount => _totalAmount.value;
  Rx<double> get totalAmountObservable => _totalAmount;
  bool get hasItems => _cartItems.isNotEmpty;
  bool get isPlacingOrder => _isPlacingOrder.value;

  @override
  void onInit() {
    super.onInit();
    _initializeCart();
  }

  Future<void> _initializeCart() async {
    await _cartService.initialize();
    _updateCartData();
  }

  void addToCart(ProductModel product, {bool isUrgent = false}) {
    _cartService.addToCart(product, isUrgent: isUrgent);
    _updateCartData();
    update(); // Notify GetBuilder widgets

    // Get.snackbar(
    //   'Added to Cart',
    //   '${product.title} has been added to your cart.',
    //   duration: const Duration(seconds: 2),
    // );
  }

  void removeFromCart(CartItemModel cartItem) {
    _cartService.removeFromCart(cartItem);
    _updateCartData();
    update(); // Notify GetBuilder widgets

    // Get.snackbar(
    //   'Removed from Cart',
    //   '${cartItem.product.title} has been removed from your cart.',
    //   duration: const Duration(seconds: 2),
    // );
  }

  void updateQuantity(CartItemModel cartItem, int newQuantity) {
    _cartService.updateQuantity(cartItem, newQuantity);
    _updateCartData();
    update(); // Notify GetBuilder widgets
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
    update(); // Notify GetBuilder widgets

    CartBottomSection.clearSelectedAddress();

    // Get.snackbar(
    //   'Cart Cleared',
    //   'All items have been removed from your cart.',
    //   duration: const Duration(seconds: 2),
    // );
  }

  void _updateCartData() {
    _cartItems.value = _cartService.cartItems;
    _totalItems.value = _cartService.totalItems;
    _totalAmount.value = _cartService.totalAmount;
  }

  void setPlacingOrder(bool value) {
    _isPlacingOrder.value = value;
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

  // Get the quantity of a specific product in the cart
  int getProductQuantity(ProductModel product) {
    return _cartService.getProductQuantity(product);
  }

  // Check if a product is in the cart
  bool isProductInCart(ProductModel product) {
    return _cartService.isProductInCart(product);
  }

  // Get cart item for a specific product
  CartItemModel? getCartItemForProduct(ProductModel product) {
    return _cartService.getCartItemForProduct(product);
  }

  // Add specific quantity of product to cart
  void addProductToCart(ProductModel product, {bool isUrgent = false}) {
    addToCart(product, isUrgent: isUrgent);
    update(); // Notify GetBuilder widgets
  }

  // Remove one quantity of product from cart
  void removeProductFromCart(ProductModel product) {
    final cartItem = getCartItemForProduct(product);
    if (cartItem != null) {
      if (cartItem.quantity > 1) {
        decreaseQuantity(cartItem);
      } else {
        removeFromCart(cartItem);
      }
    }
    update(); // Notify GetBuilder widgets
  }

  // Toggle urgent status for a product
  void toggleProductUrgentStatus(ProductModel product) {
    _cartService.toggleProductUrgentStatus(product);
    _updateCartData();
    update(); // Notify GetBuilder widgets
  }

  // Check if there are any urgent items in cart
  bool get hasUrgentItems => _cartService.hasUrgentItems;

  // Check if there are any medicine items in cart
  bool get hasMedicineItems => _cartItems.any(
    (item) => item.product.isPrescriptionMedicine || item.product.isOTC,
  );

  // Check if a specific product is marked as urgent in cart
  bool isProductUrgent(ProductModel product) {
    return _cartService.isProductUrgent(product);
  }

  // Check if all cart items are from the same category
  bool get hasMultipleCategories {
    if (_cartItems.isEmpty) return false;
    if (_cartItems.length == 1) return false;

    final firstCategoryId = _cartItems.first.product.categoryId;
    return _cartItems.any((item) => item.product.categoryId != firstCategoryId);
  }
}
