import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/delivery_enums.dart';
import '../../controllers/cart_controller.dart';
import '../../data/models/cart_item_model.dart';
import '../../../home/controllers/home_controller.dart';
import '../widgets/cart_app_bar.dart';
import '../widgets/cart_items_section.dart';
import '../widgets/you_may_like_section.dart';
import '../widgets/cart_bottom_section.dart';
import '../../../payout/presentation/widgets/order_summary_section.dart';
import '../../../payout/presentation/widgets/delivery_options_section.dart';
import '../../../payout/presentation/widgets/coupon_section.dart';
import '../../../payout/presentation/widgets/receiver_details.dart';
import '../../../payout/controllers/payout_controller.dart';
import '../../../profile/controllers/payment_method_controller.dart';
import '../../../orders/controllers/orders_controller.dart';
import '../../../orders/controllers/live_order_controller.dart';
import '../../../orders/data/services/order_api_service.dart';
import '../../../payout/data/models/delivery_option_model.dart';
import '../../../profile/data/models/shipping_address_model.dart';
import '../../../payout/data/models/payment_method_model.dart' as payout;
import 'package:lottie/lottie.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final homeController = Get.find<HomeController>();
    final payoutController = Get.put(PayoutController());

    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      appBar: CartAppBar(
        onClearAll: () => _showClearCartDialog(cartController),
      ),
      body: Obx(() {
        // Only auto-close if not currently placing an order
        if (!cartController.hasItems && !cartController.isPlacingOrder) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Get.currentRoute == '/cart') {
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
                    SizedBox(height: 16.h),
                    const ReceiverDetails(),
                    SizedBox(height: 12.h),
                    const CartItemsSection(),
                    SizedBox(height: 19.h),
                    const DeliveryOptionsSection(),
                    SizedBox(height: 19.h),
                    const CouponSection(),
                    SizedBox(height: 19.h),
                    const OrderSummarySection(),
                    SizedBox(height: 19.h),
                    YouMayLikeSection(
                      onAddToCart: cartController.addToCart,
                      onFavoriteToggle: homeController.onFavoriteToggle,
                      onProductTap: (p) =>
                          Get.toNamed('/product-details', arguments: p),
                    ),
                    SizedBox(height: 19.h),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: CartBottomSection(
                onPlaceOrder: () {
                  _handlePlaceOrder(cartController, payoutController);
                },
                onPaymentMethodTap: _showPaymentMethods,
                totalAmount: payoutController.totalAmount,
              ),
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
              cartController.clearCart();
              Get.back();
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

    cartController.setPlacingOrder(true);

    try {
      final orderItems = List<CartItemModel>.from(cartController.cartItems);

      final selectedDeliveryOption = payoutController.selectedDeliveryOption;
      final deliveryOption =
          selectedDeliveryOption ??
          DeliveryOptionModel(
            type: DeliveryType.combined,
            title: 'Standard Delivery',
            description: '30-45 minutes',
            price: 0.0,
            isSelected: true,
          );

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
            content: const Text(
              'Please select a delivery address to continue.',
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.orange.shade600,
          ),
        );
        return;
      }

      // Override receiver if provided
      ShippingAddressModel finalShippingAddress = selectedShippingAddress;
      if (payoutController.isDifferentReceiver &&
          payoutController.receiverName.isNotEmpty) {
        finalShippingAddress = selectedShippingAddress.copyWith(
          name: payoutController.receiverName,
          phoneNumber: payoutController.receiverPhone.isNotEmpty
              ? payoutController.receiverPhone
              : selectedShippingAddress.phoneNumber,
        );
      }

      final payoutPaymentMethod = payout.PaymentMethodModel(
        type: selectedPaymentMethod.type,
        isSelected: true,
      );

      // Call the backend API to create the order
      final orderApiService = OrderApiService();
      final response = await orderApiService.createOrder(
        items: orderItems,
        shippingAddress: finalShippingAddress,
        deliveryOption: deliveryOption,
        paymentMethod: payoutPaymentMethod,
        couponCode: payoutController.appliedCoupon?['isValid'] == true
            ? payoutController.couponCode
            : null,
      );

      // If API call is successful, refresh orders and clear cart
      if (response.isSuccess) {
        // Refresh orders from API
        OrdersController ordersController;
        try {
          ordersController = Get.find<OrdersController>();
        } catch (e) {
          ordersController = Get.put(OrdersController());
        }
        await ordersController.loadOrders();

        // Refresh live order tracking to pick up the new order
        try {
          final liveOrderController = Get.find<LiveOrderController>();
          await liveOrderController.refreshLiveOrder();
        } catch (e) {
          print('LiveOrderController not found or error: $e');
        }

        // Clear cart
        cartController.clearCart();

        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        await _showSuccessDialog();
        Get.offAllNamed('/home');
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

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

  Future<void> _showSuccessDialog() async {
    Get.dialog(
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/json/Success.json',
              width: 400,
              height: 400,
              repeat: false,
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    await Future.delayed(const Duration(seconds: 2));

    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  void _showPaymentMethods() {
    final paymentMethodController = Get.find<PaymentMethodController>();

    Get.bottomSheet(
      SafeArea(
        top: false, // allow full sheet up to status bar
        child: Container(
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
      ),
      isScrollControlled: true, // 👈 full height if needed, goes above nav bar
      backgroundColor: Colors.transparent,
    );
  }
}
