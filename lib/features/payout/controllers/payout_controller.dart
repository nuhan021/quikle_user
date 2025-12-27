import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/orders/data/models/order_model.dart';
import 'package:quikle_user/features/orders/data/services/order_api_service.dart';
import 'package:quikle_user/features/payment/data/models/order_creation_response.dart';
import 'package:quikle_user/features/payout/presentation/widgets/order_failure_dialog.dart';
import 'package:quikle_user/features/payout/presentation/widgets/order_success_dialog.dart';
import 'package:quikle_user/features/payout/presentation/widgets/payment_failure_dialog.dart';
import '../data/models/payment_method_model.dart';
import '../../profile/data/models/shipping_address_model.dart';
import '../../profile/controllers/address_controller.dart';
import '../data/services/payout_service.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../user/controllers/user_controller.dart';
import '../../../core/utils/constants/enums/order_enums.dart';
import '../../../core/utils/logging/logger.dart';
import 'delivery_controller.dart';
import 'coupon_controller.dart';
import 'payment_controller.dart';
import 'receiver_controller.dart';
import '../data/models/delivery_option_model.dart';
import '../presentation/pages/coupons_page.dart';

class PayoutController extends GetxController {
  final PayoutService _payoutService = PayoutService();
  final OrderApiService _orderApiService = OrderApiService();
  final _cartController = Get.find<CartController>();
  final _userController = Get.find<UserController>();

  // Child controllers
  DeliveryController get deliveryController {
    try {
      return Get.find<DeliveryController>();
    } catch (e) {
      return Get.put(DeliveryController());
    }
  }

  // Backwards-compatibility: expose the TextEditingController and coupon helpers
  // so existing UI that referenced payoutController.couponController, appliedCoupon, etc.
  CouponController get _couponCtrl {
    try {
      return Get.find<CouponController>();
    } catch (e) {
      return Get.put(CouponController());
    }
  }

  TextEditingController get couponController => _couponCtrl.couponController;
  Map<String, dynamic>? get appliedCoupon => _couponCtrl.appliedCoupon;
  List<Map<String, dynamic>> get availableCoupons =>
      _couponCtrl.availableCoupons;
  Future<void> fetchAndApplyBestCoupon() =>
      _couponCtrl.fetchAndApplyBestCoupon();
  void applyCouponLocally(Map<String, dynamic> c) =>
      _couponCtrl.applyCouponLocally(c);
  bool isCouponApplicable(Map<String, dynamic> c) =>
      _couponCtrl.isCouponApplicable(c);
  double estimateSavings(Map<String, dynamic> c) =>
      _couponCtrl.estimateSavings(c);

  PaymentController get paymentController {
    try {
      return Get.find<PaymentController>();
    } catch (e) {
      return Get.put(PaymentController());
    }
  }

  ReceiverController get receiverController {
    try {
      return Get.find<ReceiverController>();
    } catch (e) {
      return Get.put(ReceiverController());
    }
  }

  // Get AddressController - create if not exists
  AddressController get _addressController {
    try {
      return Get.find<AddressController>();
    } catch (e) {
      return Get.put(AddressController());
    }
  }

  final _paymentMethods = <PaymentMethodModel>[].obs;
  final _isProcessingPayment = false.obs;

  List<PaymentMethodModel> get paymentMethods => _paymentMethods;
  bool get isProcessingPayment => _isProcessingPayment.value;

  PaymentMethodModel? get selectedPaymentMethod =>
      _paymentMethods.firstWhereOrNull((method) => method.isSelected);

  // Delivery forwards (backwards compatibility)
  List<DeliveryOptionModel> get deliveryOptions =>
      deliveryController.deliveryOptions;
  TextEditingController get deliveryPreferenceController =>
      deliveryController.deliveryPreferenceController;
  String? get selectedDeliveryPreference =>
      deliveryController.selectedDeliveryPreference;
  bool get isUrgentDelivery => deliveryController.isUrgentDelivery;
  DeliveryOptionModel? get selectedDeliveryOption =>
      deliveryController.selectedDeliveryOption;
  void selectDeliveryOption(DeliveryOptionModel option) =>
      deliveryController.selectDeliveryOption(option);
  void toggleUrgentDelivery() => deliveryController.toggleUrgentDelivery();

  // Forwarded getters
  double get subtotal => _cartController.totalAmount;
  double get deliveryFee => deliveryController.deliveryFee;
  double get discountAmount => _couponCtrl.discountAmount;
  double get totalAmount => (subtotal - discountAmount) + deliveryFee;
  double get payableAmount => totalAmount < 0 ? 0 : totalAmount;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();

    // Initialize PaymentController with callbacks
    paymentController.initialize(
      onPaymentSuccess: _handleCashfreePaymentSuccess,
      onPaymentError: _handleCashfreePaymentError,
      onPaymentProcessing: _handlePaymentProcessing,
    );
  }

  // Shipping address helpers (compat)
  List<ShippingAddressModel> get shippingAddresses =>
      _addressController.addresses;
  ShippingAddressModel? get selectedShippingAddress =>
      _addressController.addresses.firstWhereOrNull((a) => a.isSelected);

  // Receiver compatibility
  bool get isDifferentReceiver => receiverController.isDifferentReceiver;
  TextEditingController get receiverNameController =>
      receiverController.receiverNameController;
  TextEditingController get receiverPhoneController =>
      receiverController.receiverPhoneController;
  String get receiverName => receiverController.receiverName;
  String get receiverPhone => receiverController.receiverPhone;
  void toggleDifferentReceiver() =>
      receiverController.toggleDifferentReceiver();
  void setReceiverDetails(String name, String phone) =>
      receiverController.setReceiverDetails(name, phone);
  void clearReceiverDetails() => receiverController.clearReceiverDetails();
  String? getReceiverValidationError() =>
      receiverController.getReceiverValidationError();
  String getCurrentReceiverName() =>
      receiverController.getCurrentReceiverName(selectedShippingAddress);
  String getCurrentReceiverPhone() =>
      receiverController.getCurrentReceiverPhone(selectedShippingAddress);

  // View coupons (compat)
  void viewAllCoupons() {
    try {
      Get.to(() => const CouponsPage());
    } catch (e) {
      // no-op
    }
  }

  void _loadInitialData() {
    _paymentMethods.value = _payoutService.getPaymentMethods();
    // CouponController.fetchAndApplyBestCoupon runs in its onInit
  }

  void selectPaymentMethod(PaymentMethodModel method) {
    _paymentMethods.value = _paymentMethods.map((item) {
      return item.copyWith(isSelected: item.type == method.type);
    }).toList();
  }

  void selectShippingAddress(ShippingAddressModel address) {
    _addressController.selectAddress(address);
  }

  Future<void> applyCoupon() async {
    final code = _couponCtrl.couponController.text.trim();
    if (code.isEmpty) {
      Get.snackbar('Error', 'Please enter a coupon code');
      return;
    }

    try {
      final result = await _payoutService.validateCoupon(code);
      _couponCtrl.applyCouponLocally(result);
      if (result['isValid'] == true) {
        Get.snackbar('Success', result['message']);
      } else {
        Get.snackbar('Error', result['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to validate coupon');
    }
  }

  Future<void> placeOrder() async {
    // Ensure delivery option selected
    if (deliveryController.selectedDeliveryOption == null &&
        deliveryController.deliveryOptions.isNotEmpty) {
      deliveryController.selectDeliveryOption(
        deliveryController.deliveryOptions.first,
      );
    }

    if (selectedPaymentMethod == null && _paymentMethods.isNotEmpty) {
      selectPaymentMethod(_paymentMethods.first);
    }

    // Auto-select default address if none selected and addresses available
    if (_addressController.addresses.firstWhereOrNull((a) => a.isSelected) ==
            null &&
        _addressController.addresses.isNotEmpty) {
      final defaultAddr = _addressController.defaultAddress;
      if (defaultAddr != null) {
        selectShippingAddress(defaultAddr);
      } else {
        selectShippingAddress(_addressController.addresses.first);
      }
    }

    final selectedDelivery = deliveryController.selectedDeliveryOption;
    final selectedAddress = _addressController.addresses.firstWhereOrNull(
      (a) => a.isSelected,
    );

    if (selectedDelivery == null ||
        selectedPaymentMethod == null ||
        selectedAddress == null) {
      Get.snackbar('Error', 'Please complete all selections');
      return;
    }

    _isProcessingPayment.value = true;

    try {
      // Build final shipping address (respect receiver override)
      var finalShippingAddress = selectedAddress;
      if (receiverController.isDifferentReceiver &&
          receiverController.receiverName.isNotEmpty) {
        finalShippingAddress = selectedAddress.copyWith(
          name: receiverController.receiverName,
          phoneNumber: receiverController.receiverPhone.isNotEmpty
              ? receiverController.receiverPhone
              : selectedAddress.phoneNumber,
        );
      }

      AppLoggerHelper.debug('Creating order with backend API...');
      final orderCreationResponse = await _orderApiService.createOrder(
        items: _cartController.cartItems,
        shippingAddress: finalShippingAddress,
        deliveryOption: selectedDelivery,
        paymentMethod: selectedPaymentMethod!,
        couponCode: _couponCtrl.appliedCoupon?['isValid'] == true
            ? _couponCtrl.couponController.text
            : null,
      );

      if (!orderCreationResponse.success) {
        throw Exception(orderCreationResponse.message);
      }

      final orderData = orderCreationResponse.data;
      AppLoggerHelper.debug(
        'Orders created: parent id ${orderData.parentOrderId}',
      );

      // Attempt to apply coupon on server if present
      try {
        final applied = _couponCtrl.appliedCoupon;
        if (applied != null && applied['isValid'] == true) {
          final code = _couponCtrl.couponController.text.trim();
          if (code.isNotEmpty) {
            AppLoggerHelper.debug('Applying coupon on server: $code');
            final resp = await _payoutService.applyCoupon(
              code,
              orderId: orderData.parentOrderId.toString(),
            );
            if (resp.statusCode == 200) {
              AppLoggerHelper.debug('Coupon applied on server successfully');
            } else {
              AppLoggerHelper.debug(
                'Coupon apply failed: ${resp.errorMessage}',
              );
              Get.snackbar(
                'Coupon',
                resp.errorMessage,
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          }
        }
      } catch (e) {
        AppLoggerHelper.error('Error applying coupon on server', e);
      }

      // If payment is required, start payment via PaymentController
      if (orderData.requiresPayment) {
        AppLoggerHelper.debug(
          'Initiating payment for cfOrderId: ${orderData.cfOrderId}',
        );
        _pendingOrderData = orderData;
        _pendingShippingAddress = finalShippingAddress;

        _isProcessingPayment.value = false;

        await paymentController.startPayment(
          cfOrderId: orderData.cfOrderId,
          paymentSessionId: orderData.paymentSessionId,
          parentOrderId: orderData.parentOrderId,
        );
      } else {
        _handlePaymentSuccess(orderData, finalShippingAddress);
      }
    } catch (e) {
      AppLoggerHelper.error('Error placing order', e);
      _isProcessingPayment.value = false;

      String errorMessage = 'Something went wrong. Please try again.';
      if (e.toString().contains('Cashfree') ||
          e.toString().contains('payment') ||
          e.toString().contains('session')) {
        errorMessage =
            'Payment initialization failed. Please check your connection and try again.';
      } else if (e.toString().contains('Exception:')) {
        final match = RegExp(r'Exception:\s*(.+)').firstMatch(e.toString());
        if (match != null && match.group(1) != null)
          errorMessage = match.group(1)!;
      }

      Get.dialog(
        OrderFailureDialog(
          errorMessage: errorMessage,
          onRetry: () => placeOrder(),
        ),
        barrierDismissible: true,
      );
    }
  }

  // pending order data for payment callbacks
  OrderCreationData? _pendingOrderData;
  ShippingAddressModel? _pendingShippingAddress;

  void _handlePaymentProcessing() {
    AppLoggerHelper.debug('Processing payment confirmation...');
    _isProcessingPayment.value = true;

    Get.dialog(
      PopScope(
        canPop: false,
        child: Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text(
                    'Processing Payment',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please wait while we confirm your payment...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _handleCashfreePaymentSuccess(String orderId) {
    AppLoggerHelper.debug('Cashfree payment successful for order: $orderId');
    if (Get.isDialogOpen ?? false) Get.back();

    if (_pendingOrderData == null || _pendingShippingAddress == null) {
      AppLoggerHelper.error('No pending order data found');
      Get.snackbar(
        'Error',
        'Payment completed but order data is missing. Please contact support.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _handlePaymentSuccess(_pendingOrderData!, _pendingShippingAddress!);
    _pendingOrderData = null;
    _pendingShippingAddress = null;
  }

  void _handleCashfreePaymentError(String orderId, String errorMessage) {
    AppLoggerHelper.error(
      'Cashfree payment error for order $orderId: $errorMessage',
    );
    if (Get.isDialogOpen ?? false) Get.back();
    _isProcessingPayment.value = false;

    Get.dialog(
      PaymentFailureDialog(
        errorMessage: errorMessage.isEmpty
            ? 'Something went wrong with your payment'
            : errorMessage,
        onRetry: () => placeOrder(),
      ),
      barrierDismissible: true,
    );
  }

  void _handlePaymentSuccess(
    OrderCreationData orderData,
    ShippingAddressModel finalShippingAddress,
  ) {
    AppLoggerHelper.debug(
      'Payment successful for parent order: ${orderData.parentOrderId}',
    );

    final firstOrder = orderData.orders.isNotEmpty
        ? orderData.orders.first
        : null;

    final order = OrderModel(
      orderId: orderData.parentOrderId,
      userId: _userController.currentUserId ?? 'unknown_user',
      items: _cartController.cartItems,
      shippingAddress: finalShippingAddress,
      deliveryOption: deliveryController.selectedDeliveryOption!,
      paymentMethod: selectedPaymentMethod!,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: orderData.totalAmount,
      couponCode: _couponCtrl.appliedCoupon?['isValid'] == true
          ? _couponCtrl.couponController.text
          : null,
      discount: discountAmount > 0 ? discountAmount : null,
      orderDate: DateTime.now(),
      status: OrderStatus.pending,
      trackingNumber: firstOrder?.trackingNumber ?? '',
      metadata: {
        'deliveryPreference': deliveryController.selectedDeliveryPreference,
        'isUrgent': deliveryController.isUrgentDelivery,
        'cfOrderId': orderData.cfOrderId,
        'childOrders': orderData.orders
            .map(
              (o) => {
                'orderId': o.orderId,
                'vendorId': o.vendorId,
                'trackingNumber': o.trackingNumber,
                'total': o.total,
              },
            )
            .toList(),
      },
    );

    _cartController.clearCart();
    _isProcessingPayment.value = false;

    Get.dialog(
      OrderSuccessDialog(
        order: order,
        transactionId: orderData.parentOrderId,
        onContinue: () {
          Get.back();
          Get.offAllNamed('/home');
        },
      ),
      barrierDismissible: false,
    );
  }
}
