import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import '../../controllers/cart_controller.dart';
import '../../../home/controllers/home_controller.dart';
import '../widgets/cart_app_bar.dart';
import '../widgets/free_gift_progress_section.dart';
import '../widgets/cart_items_section.dart';
import '../widgets/you_may_like_section.dart';
import '../widgets/cart_bottom_section.dart';
import '../widgets/empty_cart_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final homeController = Get.find<HomeController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Obx(() {
        if (!cartController.hasItems) {
          return const EmptyCartScreen();
        }
        return Scaffold(
          backgroundColor: AppColors.homeGrey,
          body: SafeArea(
            child: Column(
              children: [
                CartAppBar(
                  onClearAll: () => _showClearCartDialog(cartController),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 16.h),
                        const FreeGiftAndProgressSection(),

                        SizedBox(height: 19.h),
                        const CartItemsSection(),

                        SizedBox(height: 19.h),
                        YouMayLikeSection(
                          onAddToCart: (product) =>
                              cartController.addToCart(product),
                          onFavoriteToggle: (product) =>
                              homeController.onFavoriteToggle(product),
                          onProductTap: (product) {
                            // Navigate to product details if needed
                            // Get.toNamed('/product-details', arguments: product);
                          },
                        ),

                        SizedBox(height: 100.h),
                      ],
                    ),
                  ),
                ),
                CartBottomSection(
                  onPlaceOrder: () => _handlePlaceOrder(cartController),
                  onPaymentMethodTap: () => _showPaymentMethods(),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _showClearCartDialog(CartController cartController) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text(
          'Are you sure you want to remove all items from your cart?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              cartController.clearCart();
              Get.back();
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handlePlaceOrder(CartController cartController) {
    if (cartController.hasItems) {
      cartController.onCheckout();
    }
  }

  void _showPaymentMethods() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16.h),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Wallet'),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Credit/Debit Card'),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: Icon(Icons.money),
              title: Text('Cash on Delivery'),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}
