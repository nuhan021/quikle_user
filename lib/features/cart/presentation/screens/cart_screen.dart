import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/order_enums.dart';
import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';
import 'package:quikle_user/core/utils/constants/enums/delivery_enums.dart';
import 'package:quikle_user/features/home/presentation/screens/home_content_screen.dart';
import '../../controllers/cart_controller.dart';
import '../../data/models/cart_item_model.dart';
import '../../../home/controllers/home_controller.dart';
import '../widgets/cart_app_bar.dart';
import '../widgets/cart_items_section.dart';
import '../widgets/you_may_like_section.dart';
import '../widgets/cart_bottom_section.dart';
import '../widgets/empty_cart_screen.dart';
import '../../../payout/presentation/widgets/order_summary_section.dart';
import '../../../payout/presentation/widgets/delivery_options_section.dart';
import '../../../payout/presentation/widgets/coupon_section.dart';
import '../../../payout/controllers/payout_controller.dart';
import '../../../profile/controllers/payment_method_controller.dart';
import '../../../orders/controllers/orders_controller.dart';
import '../../../orders/controllers/live_order_controller.dart';
import '../../../orders/data/models/order_model.dart';
import '../../../payout/presentation/widgets/order_success_dialog.dart';
import '../../../payout/data/models/delivery_option_model.dart';
import '../../../profile/data/models/shipping_address_model.dart';
import '../../../payout/data/models/payment_method_model.dart' as payout;

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
        if (!cartController.hasItems) {
          Future.microtask(() => Get.back());
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    const CartItemsSection(),
                    SizedBox(height: 19.h),
                    YouMayLikeSection(
                      onAddToCart: cartController.addToCart,
                      onFavoriteToggle: homeController.onFavoriteToggle,
                      onProductTap: (p) =>
                          Get.toNamed('/product-details', arguments: p),
                    ),
                    //SizedBox(height: 19.h),
                    const DeliveryOptionsSection(),
                    SizedBox(height: 19.h),
                    const CouponSection(),
                    SizedBox(height: 19.h),
                    const OrderSummarySection(),
                    SizedBox(height: 19.h),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: CartBottomSection(
                onPlaceOrder: () =>
                    _handlePlaceOrder(cartController, payoutController),
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

  void _handlePlaceOrder(
    CartController cartController,
    PayoutController payoutController,
  ) {
    if (cartController.hasItems) {
      final paymentMethodController = Get.find<PaymentMethodController>();
      final selectedPaymentMethod =
          paymentMethodController.selectedPaymentMethod;

      if (selectedPaymentMethod == null) {
        Get.snackbar(
          'Payment Method Required',
          'Please select a payment method to continue.',
          duration: const Duration(seconds: 2),
        );
        return;
      }

      _processPayment(selectedPaymentMethod, payoutController);
    }
  }

  void _processPayment(
    dynamic paymentMethod,
    PayoutController payoutController,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Processing Payment'),
        content: Text('Redirecting to ${paymentMethod.type.displayName}...'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();

              _simulatePaymentSuccess(payoutController);
            },
            child: const Text('Simulate Success'),
          ),
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ],
      ),
    );
  }

  String generateOrderId() {
    final random = Random();
    final random4Digits = 1000 + random.nextInt(9000);
    return random4Digits.toString();
  }

  void _simulatePaymentSuccess(PayoutController payoutController) async {
    final cartController = Get.find<CartController>();
    final paymentMethodController = Get.find<PaymentMethodController>();
    final selectedPaymentMethod = paymentMethodController.selectedPaymentMethod;

    if (selectedPaymentMethod == null) return;

    if (!cartController.hasItems || cartController.cartItems.isEmpty) {
      Get.snackbar(
        'Empty Cart',
        'Please add items to cart before placing order.',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      final orderItems = List<CartItemModel>.from(cartController.cartItems);

      final subtotal = payoutController.subtotal;
      final deliveryFee = payoutController.deliveryFee;
      final discountAmount = payoutController.discountAmount;
      final total = payoutController.totalAmount;

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
      final shippingAddress =
          selectedShippingAddress ??
          ShippingAddressModel(
            id: 'default_address',
            userId: 'user123',
            name: 'Default User',
            address: '123 Main Street',
            city: 'Default City',
            state: 'Default State',
            zipCode: '12345',
            phoneNumber: '+1234567890',
            type: AddressType.home,
            createdAt: DateTime.now(),
            isSelected: true,
          );

      print('Creating order with ${orderItems.length} items');
      for (var item in orderItems) {
        print(
          'Item: ${item.product.title}, Quantity: ${item.quantity}, Price: ${item.product.price}',
        );
      }

      print(
        'Order totals - Subtotal: \$${subtotal.toStringAsFixed(2)}, Delivery: \$${deliveryFee.toStringAsFixed(2)}, Discount: \$${discountAmount.toStringAsFixed(2)}, Total: \$${total.toStringAsFixed(2)}',
      );
      print(
        'Selected delivery option: ${deliveryOption.title} (\$${deliveryOption.price.toStringAsFixed(2)})',
      );
      print(
        'Selected shipping address: ${shippingAddress.name} - ${shippingAddress.address}',
      );

      final orderId = generateOrderId();
      final transactionId = 'TXN_${DateTime.now().millisecondsSinceEpoch}';

      final payoutPaymentMethod = payout.PaymentMethodModel(
        type: selectedPaymentMethod.type,
        isSelected: true,
      );

      final order = OrderModel(
        orderId: orderId,
        userId: 'user123',
        items: orderItems,
        shippingAddress: shippingAddress,
        deliveryOption: deliveryOption,
        paymentMethod: payoutPaymentMethod,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        total: total,
        discount: discountAmount > 0 ? discountAmount : null,
        couponCode: payoutController.appliedCoupon?['isValid'] == true
            ? payoutController.couponCode
            : null,
        orderDate: DateTime.now(),
        status: OrderStatus.pending,
        transactionId: transactionId,
        estimatedDelivery: DateTime.now().add(const Duration(minutes: 30)),
        metadata: {
          'deliveryPreference': payoutController.selectedDeliveryPreference,
          'isUrgent': payoutController.isUrgentDelivery,
        },
      );

      OrdersController ordersController;
      try {
        ordersController = Get.find<OrdersController>();
      } catch (e) {
        ordersController = Get.put(OrdersController());
      }
      await ordersController.addOrder(order);

      try {
        final liveOrderController = Get.find<LiveOrderController>();
        await liveOrderController.addNewOrder(order);
      } catch (e) {
        print('LiveOrderController not found or error: $e');
      }

      cartController.clearCart();

      Get.dialog(
        OrderSuccessDialog(
          order: order,
          transactionId: transactionId,
          onContinue: () {
            Get.back();
            // Return to previous route instead of forcing home
            if (Get.previousRoute.isNotEmpty) {
              Get.back();
            } else {
              Get.offAllNamed('/home');
            }
          },
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to place order. Please try again.',
        duration: const Duration(seconds: 3),
      );
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

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Payment Method',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
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
                      : Icon(Icons.payment),
                  title: Text(method.type.displayName),
                  onTap: () {
                    paymentMethodController.selectPaymentMethod(method);
                    Get.back();
                    // Get.snackbar(
                    //   'Payment Method Selected',
                    //   method.type.displayName,
                    //   duration: const Duration(seconds: 1),
                    // );
                  },
                );
              }).toList(),
            ],
          );
        }),
      ),
    );
  }
}
