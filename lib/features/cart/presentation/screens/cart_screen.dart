import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import '../../controllers/cart_controller.dart';
import '../widgets/cart_app_bar.dart';
import '../widgets/cart_items_section.dart';
import '../widgets/cart_bottom_section.dart';
import '../widgets/disclaimer_section.dart';
import '../../../payout/presentation/widgets/order_summary_section.dart';
import '../../../payout/presentation/widgets/delivery_options_section.dart';
import '../../../payout/presentation/widgets/coupon_section.dart';
import '../../../payout/presentation/widgets/receiver_details.dart';
import '../../../payout/controllers/payout_controller.dart';
import '../../../profile/controllers/payment_method_controller.dart';
import '../../../profile/controllers/address_controller.dart';
import '../../../payout/data/models/payment_method_model.dart' as payout;

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final payoutController = Get.put(PayoutController());

    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      appBar: CartAppBar(
        onClearAll: () => _showClearCartDialog(cartController),
      ),
      body: Obx(() {
        // Auto-close cart when it's empty and not placing an order, but
        // avoid closing if there's an open dialog (for example the
        // OrderSuccessDialog shown after payment). Closing immediately
        // would dismiss the dialog instead of the route, so check
        // `Get.isDialogOpen` first and postpone closing in that case.
        if (!cartController.hasItems && !cartController.isPlacingOrder) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // If a Get dialog is currently open, don't pop the route now.
            // The dialog (OrderSuccessDialog) will handle navigation when
            // it completes. Otherwise, close the cart route normally.
            if ((Get.isDialogOpen ?? false)) {
              return;
            }

            // Use a case-insensitive containment check so this works whether
            // the route name is '/cart', '/CartScreen', or similar.
            final currentRoute = Get.currentRoute.toLowerCase();
            if (currentRoute.contains('cart')) {
              Get.back();
            }
          });
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    // Show receiver details whenever there is at least one
                    // saved address OR the user has set a different receiver.
                    // Use GetBuilder to react to AddressController updates so
                    // scrolling or transient state won't hide the widget.
                    GetBuilder<AddressController>(
                      builder: (addressController) {
                        // Only check whether there are saved addresses.
                        // If there is at least one address, always show receiver
                        // details. Hide it only when there are no addresses.
                        final hasAnyAddress =
                            addressController.addresses.isNotEmpty;

                        if (!hasAnyAddress) return const SizedBox.shrink();

                        return Column(
                          children: [
                            SizedBox(height: 16.h),
                            const ReceiverDetails(),
                            SizedBox(height: 8.h),
                          ],
                        );
                      },
                    ),
                    const CartItemsSection(),
                    SizedBox(height: 8.h),
                    const DeliveryOptionsSection(),
                    SizedBox(height: 8.h),
                    const CouponSection(),
                    SizedBox(height: 8.h),
                    const OrderSummarySection(),
                    SizedBox(height: 19.h),

                    // Cart disclaimers: cancellation always shown; medicine
                    // disclaimer shown when there are medicine items in cart.
                    DisclaimerSection(
                      hasMedicine: cartController.hasMedicineItems,
                    ),
                    SizedBox(height: 19.h),
                  ],
                ),
              ),
            ),
            CartBottomSection(
              onPlaceOrder: () {
                _handlePlaceOrder(cartController, payoutController);
              },
              onPaymentMethodTap: _showPaymentMethods,
              totalAmount: payoutController.totalAmount,
            ),
          ],
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
              Get.back();
              Future.delayed(const Duration(milliseconds: 120), () {
                cartController.clearCart();
              });
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePlaceOrder(
    CartController cartController,
    PayoutController payoutController,
  ) async {
    if (cartController.hasItems) {
      final paymentMethodController = Get.find<PaymentMethodController>();
      final selectedPaymentMethod =
          paymentMethodController.selectedPaymentMethod;

      if (selectedPaymentMethod == null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text('Please select a payment method to continue.'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      await _placeOrder(payoutController);
    }
  }

  Future<void> _placeOrder(PayoutController payoutController) async {
    final cartController = Get.find<CartController>();
    final paymentMethodController = Get.find<PaymentMethodController>();
    final selectedPaymentMethod = paymentMethodController.selectedPaymentMethod;

    if (selectedPaymentMethod == null) return;

    if (!cartController.hasItems || cartController.cartItems.isEmpty) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Please add items to cart before placing order.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Sync the selected address from CartBottomSection to PayoutController
    final selectedAddressId = CartBottomSection.getSelectedAddressId();
    if (selectedAddressId != null) {
      final addressController = Get.find<AddressController>();
      final selectedAddr = addressController.addresses.firstWhereOrNull(
        (addr) => addr.id == selectedAddressId,
      );
      if (selectedAddr != null) {
        payoutController.selectShippingAddress(selectedAddr);
      }
    } else {
      // If no address selected in CartBottomSection, select the default address
      final addressController = Get.find<AddressController>();
      final defaultAddr = addressController.defaultAddress;
      if (defaultAddr != null) {
        payoutController.selectShippingAddress(defaultAddr);
        // Also set it in CartBottomSection for consistency
        CartBottomSection.setSelectedAddressId(defaultAddr.id);
      }
    }

    final selectedShippingAddress = payoutController.selectedShippingAddress;

    // DEBUG: Print address information
    print('=== ADDRESS SELECTION DEBUG ===');
    print(
      'Total addresses in AddressController: ${payoutController.shippingAddresses.length}',
    );
    for (var i = 0; i < payoutController.shippingAddresses.length; i++) {
      final addr = payoutController.shippingAddresses[i];
      print(
        'Address $i: ${addr.name} - isSelected: ${addr.isSelected}, isDefault: ${addr.isDefault}',
      );
    }
    print('Selected shipping address: $selectedShippingAddress');
    print('Selected address name: ${selectedShippingAddress?.name}');
    print('==============================');

    // Validate that user has selected an address
    if (selectedShippingAddress == null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: const Text('Please select a delivery address to continue.'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.orange.shade600,
        ),
      );
      return;
    }

    // Ensure the selected payment method is set in PayoutController
    final payoutPaymentMethod = payout.PaymentMethodModel(
      type: selectedPaymentMethod.type,
      isSelected: true,
    );
    payoutController.selectPaymentMethod(payoutPaymentMethod);

    cartController.setPlacingOrder(true);

    try {
      await payoutController.placeOrder();
    } catch (e) {
      // Extract error message
      String errorMessage = 'Failed to place order. Please try again.';
      if (e.toString().contains('Exception:')) {
        errorMessage = e.toString().replaceFirst('Exception:', '').trim();
      }

      // Show error using ScaffoldMessenger
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red.shade600,
        ),
      );
    } finally {
      cartController.setPlacingOrder(false);
    }
  }

  void _showPaymentMethods() {
    final paymentMethodController = Get.find<PaymentMethodController>();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: Obx(() {
          final paymentMethods = paymentMethodController.paymentMethods;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Payment Method',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16.h),

                ...paymentMethods.map((method) {
                  return ListTile(
                    leading: method.type.iconPath != null
                        ? Image.asset(
                            method.type.iconPath!,
                            width: 24,
                            height: 24,
                          )
                        : const Icon(Icons.payment),
                    title: Text(method.type.displayName),
                    onTap: () {
                      paymentMethodController.selectPaymentMethod(method);
                      Get.back();
                    },
                  );
                }).toList(),
              ],
            ),
          );
        }),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
