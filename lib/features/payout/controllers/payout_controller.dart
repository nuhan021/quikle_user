import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/orders/data/models/order_model.dart';
import 'package:quikle_user/features/orders/data/services/order_api_service.dart';
import 'package:quikle_user/features/payment/data/models/order_creation_response.dart';
import 'package:quikle_user/features/payment/services/cashfree_payment_service.dart';
import 'package:quikle_user/features/payout/presentation/widgets/order_success_dialog.dart';
import '../data/models/delivery_option_model.dart';
import '../data/models/payment_method_model.dart';
import '../../profile/data/models/shipping_address_model.dart';
import '../../profile/controllers/address_controller.dart';
import '../data/services/payout_service.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../user/controllers/user_controller.dart';
import '../../../core/utils/constants/enums/order_enums.dart';
import '../../../core/utils/constants/enums/delivery_enums.dart';
import '../../../core/utils/logging/logger.dart';

class PayoutController extends GetxController {
  final PayoutService _payoutService = PayoutService();
  final OrderApiService _orderApiService = OrderApiService();
  final CashfreePaymentService _cashfreeService = CashfreePaymentService();
  final _cartController = Get.find<CartController>();
  final _userController = Get.find<UserController>();

  // Get AddressController - create if not exists
  AddressController get _addressController {
    try {
      return Get.find<AddressController>();
    } catch (e) {
      return Get.put(AddressController());
    }
  }

  final _deliveryOptions = <DeliveryOptionModel>[].obs;
  final _deliveryPreferenceController = TextEditingController();
  final _selectedDeliveryPreference = Rxn<String?>(null);
  final _paymentMethods = <PaymentMethodModel>[].obs;
  final _isUrgentDelivery = false.obs;
  final _userToggledUrgent = false.obs; // Track if user manually toggled
  final _couponCode = ''.obs;
  final _appliedCoupon = Rxn<Map<String, dynamic>>();
  final _isProcessingPayment = false.obs;
  final _couponController = TextEditingController();
  // Receiver details (for ordering to same address but different receiver)
  final _isDifferentReceiver = false.obs;
  final _receiverNameController = TextEditingController();
  final _receiverPhoneController = TextEditingController();

  List<DeliveryOptionModel> get deliveryOptions => _deliveryOptions;
  TextEditingController get deliveryPreferenceController =>
      _deliveryPreferenceController;
  String? get selectedDeliveryPreference {
    final explicit = _selectedDeliveryPreference.value;
    if (explicit != null && explicit.trim().isNotEmpty) return explicit;
    final typed = _deliveryPreferenceController.text.trim();
    return typed.isNotEmpty ? typed : null;
  }

  List<PaymentMethodModel> get paymentMethods => _paymentMethods;

  // Get shipping addresses from AddressController (real API data)
  List<ShippingAddressModel> get shippingAddresses =>
      _addressController.addresses;
  bool get isUrgentDelivery => _isUrgentDelivery.value;
  String get couponCode => _couponCode.value;
  Map<String, dynamic>? get appliedCoupon => _appliedCoupon.value;
  bool get isProcessingPayment => _isProcessingPayment.value;
  TextEditingController get couponController => _couponController;

  bool get canApplyCoupon => _couponCode.value.trim().isNotEmpty;

  // Receiver getters
  bool get isDifferentReceiver => _isDifferentReceiver.value;
  TextEditingController get receiverNameController => _receiverNameController;
  TextEditingController get receiverPhoneController => _receiverPhoneController;
  String get receiverName => _receiverNameController.text.trim();
  String get receiverPhone => _receiverPhoneController.text.trim();

  DeliveryOptionModel? get selectedDeliveryOption =>
      _deliveryOptions.firstWhereOrNull((option) => option.isSelected);

  PaymentMethodModel? get selectedPaymentMethod =>
      _paymentMethods.firstWhereOrNull((method) => method.isSelected);

  // Get selected shipping address from AddressController
  ShippingAddressModel? get selectedShippingAddress {
    final addresses = _addressController.addresses;
    return addresses.firstWhereOrNull((address) => address.isSelected);
  }

  double get subtotal => _cartController.totalAmount;
  double get _couponBaseSubtotal => subtotal;

  double get deliveryFee {
    double baseFee = selectedDeliveryOption?.price ?? 0.0;
    if (isUrgentDelivery) {
      baseFee += 2.0;
    }
    return baseFee;
  }

  double get discountAmount {
    final coupon = appliedCoupon;
    if (coupon == null || coupon['isValid'] != true) return 0.0;

    final base = _couponBaseSubtotal;
    if (base <= 0) return 0.0;

    final String discountType = coupon['discountType'] as String;
    final double discountValue = (coupon['discountValue'] as num).toDouble();

    double discount = 0.0;
    switch (discountType) {
      case 'percentage':
        discount = base * (discountValue / 100.0);
        break;
      case 'fixed':
        discount = discountValue;
        break;
      default:
        discount = 0.0;
    }
    if (discount > base) discount = base;

    return discount;
  }

  double get totalAmount => (subtotal - discountAmount) + deliveryFee;
  double get payableAmount {
    final total = totalAmount;
    return total < 0 ? 0 : total;
  }

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
    _updateDeliveryBasedOnUrgency(); // Set initial delivery type based on cart

    // Initialize Cashfree payment service with callbacks
    _cashfreeService.initialize(
      onPaymentSuccess: _handleCashfreePaymentSuccess,
      onPaymentError: _handleCashfreePaymentError,
      onPaymentProcessing: _handlePaymentProcessing,
    );

    _couponController.addListener(_syncCouponText);
    _deliveryPreferenceController.addListener(() {
      _selectedDeliveryPreference.value =
          _deliveryPreferenceController.text.trim().isNotEmpty
          ? _deliveryPreferenceController.text.trim()
          : null;
    });

    // Listen to cart changes to update delivery options automatically
    ever(
      _cartController.cartItemsObservable,
      (_) => _updateDeliveryBasedOnUrgency(),
    );
  }

  @override
  void onClose() {
    _couponController.removeListener(_syncCouponText);
    _couponController.dispose();
    _deliveryPreferenceController.dispose();
    _receiverNameController.dispose();
    _receiverPhoneController.dispose();
    super.onClose();
  }

  void _syncCouponText() {
    _couponCode.value = _couponController.text;
  }

  // Receiver helpers
  void toggleDifferentReceiver() {
    _isDifferentReceiver.value = !_isDifferentReceiver.value;
    if (!_isDifferentReceiver.value) {
      _receiverNameController.clear();
      _receiverPhoneController.clear();
    }
  }

  void setReceiverDetails(String name, String phone) {
    _receiverNameController.text = name;
    _receiverPhoneController.text = phone;
  }

  void clearReceiverDetails() {
    _isDifferentReceiver.value = false;
    _receiverNameController.clear();
    _receiverPhoneController.clear();
  }

  String? getReceiverValidationError() {
    if (!_isDifferentReceiver.value) return null;
    if (receiverName.isEmpty) return 'Please enter receiver name';
    if (receiverPhone.isEmpty) return 'Please enter receiver phone number';
    if (receiverPhone.length < 10) return 'Please enter a valid phone number';
    return null;
  }

  String getCurrentReceiverName() {
    if (isDifferentReceiver && receiverName.isNotEmpty) return receiverName;
    final selected = selectedShippingAddress;
    if (selected != null) return selected.name;
    return 'You';
  }

  String getCurrentReceiverPhone() {
    if (isDifferentReceiver && receiverPhone.isNotEmpty) return receiverPhone;
    final selected = selectedShippingAddress;
    if (selected != null) return selected.phoneNumber;
    return '';
  }

  void _loadInitialData() {
    _deliveryOptions.value = _payoutService.getDeliveryOptions();
    _paymentMethods.value = _payoutService.getPaymentMethods();

    // Load addresses from AddressController (which gets them from API)
    // AddressController loads addresses in its onInit, so they should be available
  }

  void selectDeliveryOption(DeliveryOptionModel option) {
    _deliveryOptions.value = _deliveryOptions.map((item) {
      return item.copyWith(isSelected: item.type == option.type);
    }).toList();
  }

  void selectDeliveryPreference(String? pref) {
    _selectedDeliveryPreference.value = pref;
    if (pref != null) _deliveryPreferenceController.text = pref;
  }

  void selectPaymentMethod(PaymentMethodModel method) {
    _paymentMethods.value = _paymentMethods.map((item) {
      return item.copyWith(isSelected: item.type == method.type);
    }).toList();
  }

  void selectShippingAddress(ShippingAddressModel address) {
    // Update the address selection in AddressController
    _addressController.selectAddress(address);
  }

  void toggleUrgentDelivery() {
    _userToggledUrgent.value = true; // Mark as manually toggled
    _isUrgentDelivery.value = !_isUrgentDelivery.value;

    // If turning off urgent delivery, remove urgent status from all items
    if (!_isUrgentDelivery.value) {
      _clearAllUrgentItems();
    } else {
      // If turning on urgent delivery, restore urgent status to medicine items
      _restoreUrgentItemsForMedicines();
    }

    // Update delivery options
    _updateDeliveryManually();
  }

  void _clearAllUrgentItems() {
    // Remove urgent status from all cart items
    for (final item in _cartController.cartItems) {
      if (_cartController.isProductUrgent(item.product)) {
        _cartController.toggleProductUrgentStatus(item.product);
      }
    }
    // Reset user toggle flag since we've manually cleared all urgent items
    _userToggledUrgent.value = false;
  }

  void _restoreUrgentItemsForMedicines() {
    // Restore urgent status to medicine items when urgent delivery is turned on
    for (final item in _cartController.cartItems) {
      final isMedicine =
          item.product.isPrescriptionMedicine || item.product.isOTC;
      if (isMedicine && !_cartController.isProductUrgent(item.product)) {
        _cartController.toggleProductUrgentStatus(item.product);
      }
    }
  }

  void _updateDeliveryBasedOnUrgency() {
    // Check if there are urgent items in cart
    final hasUrgentItems = _cartController.hasUrgentItems;

    // Only auto-enable urgent delivery if user hasn't manually toggled it
    if (hasUrgentItems &&
        !_isUrgentDelivery.value &&
        !_userToggledUrgent.value) {
      _isUrgentDelivery.value = true;
    }
    // Auto-disable urgent delivery toggle only if no urgent items and user hasn't manually set it
    else if (!hasUrgentItems &&
        _isUrgentDelivery.value &&
        !_userToggledUrgent.value) {
      _isUrgentDelivery.value = false;
    }

    _updateDeliveryOptions();
  }

  void _updateDeliveryManually() {
    // This is called when user manually toggles, don't auto-adjust the toggle
    _updateDeliveryOptions();
  }

  void _updateDeliveryOptions() {
    // Check if we should use split delivery
    final shouldUseSplit = _isUrgentDelivery.value;

    if (shouldUseSplit) {
      // When urgent delivery is needed, prefer split delivery for speed
      final splitOption = _deliveryOptions.firstWhereOrNull(
        (o) => o.type.name == 'split' || o.type == DeliveryType.split,
      );
      if (splitOption != null) selectDeliveryOption(splitOption);
    } else {
      // Use combined delivery (cheaper) when no urgent items
      final combinedOption = _deliveryOptions.firstWhereOrNull(
        (o) => o.type.name == 'combined' || o.type == DeliveryType.combined,
      );
      if (combinedOption != null) selectDeliveryOption(combinedOption);
    }
  }

  Future<void> applyCoupon() async {
    final code = _couponController.text.trim();
    if (code.isEmpty) {
      Get.snackbar('Error', 'Please enter a coupon code');
      return;
    }

    try {
      final result = await _payoutService.validateCoupon(code);
      _appliedCoupon.value = result;
      _couponCode.value = code;

      if (result['isValid'] == true) {
        Get.snackbar('Success', result['message']);
      } else {
        Get.snackbar('Error', result['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to validate coupon');
    }
  }

  void removeCoupon() {
    _appliedCoupon.value = null;
    _couponCode.value = '';
    _couponController.clear();
  }

  Future<void> placeOrder() async {
    // Auto-select sensible defaults if the user hasn't made explicit choices
    if (selectedDeliveryOption == null && _deliveryOptions.isNotEmpty) {
      selectDeliveryOption(_deliveryOptions.first);
    }

    if (selectedPaymentMethod == null && _paymentMethods.isNotEmpty) {
      selectPaymentMethod(_paymentMethods.first);
    }

    // Auto-select default address if none selected and addresses available
    if (selectedShippingAddress == null &&
        _addressController.addresses.isNotEmpty) {
      final defaultAddr = _addressController.defaultAddress;
      if (defaultAddr != null) {
        selectShippingAddress(defaultAddr);
      } else {
        selectShippingAddress(_addressController.addresses.first);
      }
    }

    if (selectedDeliveryOption == null ||
        selectedPaymentMethod == null ||
        selectedShippingAddress == null) {
      Get.snackbar('Error', 'Please complete all selections');
      return;
    }

    _isProcessingPayment.value = true;

    try {
      // Determine final shipping address to attach to order.
      // If user provided a different receiver, copy the selected address but
      // replace name and phone number.
      ShippingAddressModel finalShippingAddress = selectedShippingAddress!;
      if (isDifferentReceiver && receiverName.isNotEmpty) {
        finalShippingAddress = selectedShippingAddress!.copyWith(
          name: receiverName,
          phoneNumber: receiverPhone.isNotEmpty
              ? receiverPhone
              : selectedShippingAddress!.phoneNumber,
        );
      }

      // Set loading state
      _isProcessingPayment.value = true;

      // Step 1: Create order with backend API
      AppLoggerHelper.debug('Creating order with backend API...');
      final orderCreationResponse = await _orderApiService.createOrder(
        items: _cartController.cartItems,
        shippingAddress: finalShippingAddress,
        deliveryOption: selectedDeliveryOption!,
        paymentMethod: selectedPaymentMethod!,
        couponCode: appliedCoupon?['isValid'] == true
            ? _couponController.text
            : null,
      );

      if (!orderCreationResponse.success) {
        throw Exception(orderCreationResponse.message);
      }

      final orderData = orderCreationResponse.data;
      AppLoggerHelper.debug(
        '✅ Orders created: ${orderData.orders.length} order(s), Parent Order ID: ${orderData.parentOrderId}',
      );
      AppLoggerHelper.debug(
        'Requires Payment: ${orderData.requiresPayment}, Total Amount: ${orderData.totalAmount}',
      );

      // Step 2: If payment is required, use Cashfree SDK
      if (orderData.requiresPayment) {
        AppLoggerHelper.debug(
          'Initiating Cashfree payment for CF Order ID: ${orderData.cfOrderId}',
        );
        AppLoggerHelper.debug(
          'Payment Session ID: ${orderData.paymentSessionId}',
        );

        // Store order data for later use in callbacks
        _pendingOrderData = orderData;
        _pendingShippingAddress = finalShippingAddress;

        // Start Cashfree payment
        _isProcessingPayment.value = false;

        await _cashfreeService.startPayment(
          cfOrderId: orderData.cfOrderId,
          paymentSessionId: orderData.paymentSessionId,
          parentOrderId: orderData.parentOrderId,
        );
      } else {
        // Payment not required (e.g., COD)
        _handlePaymentSuccess(orderData, finalShippingAddress);
      }
    } catch (e) {
      AppLoggerHelper.error('❌ Error placing order', e);
      _isProcessingPayment.value = false;

      // Don't use Get.snackbar here as it may not have overlay context
      // The error will be caught and displayed by CartScreen
      rethrow;
    }
  }

  // Store pending order data for callback processing
  OrderCreationData? _pendingOrderData;
  ShippingAddressModel? _pendingShippingAddress;

  /// Handle payment processing (called before confirmation API)
  void _handlePaymentProcessing() {
    AppLoggerHelper.debug('⏳ Processing payment confirmation...');
    _isProcessingPayment.value = true;

    // Show loading dialog
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

  /// Handle successful payment from Cashfree SDK
  void _handleCashfreePaymentSuccess(String orderId) {
    AppLoggerHelper.debug('✅ Cashfree payment successful for order: $orderId');

    // Close the processing dialog if it's open
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    if (_pendingOrderData == null || _pendingShippingAddress == null) {
      AppLoggerHelper.error('❌ No pending order data found');
      Get.snackbar(
        'Error',
        'Payment completed but order data is missing. Please contact support.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _handlePaymentSuccess(_pendingOrderData!, _pendingShippingAddress!);

    // Clear pending data
    _pendingOrderData = null;
    _pendingShippingAddress = null;
  }

  /// Handle payment error from Cashfree SDK
  void _handleCashfreePaymentError(String orderId, String errorMessage) {
    AppLoggerHelper.error(
      '❌ Cashfree payment error for order $orderId: $errorMessage',
    );

    // Close the processing dialog if it's open
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    _isProcessingPayment.value = false;

    Get.snackbar(
      'Payment Failed',
      errorMessage.isEmpty ? 'Payment failed. Please try again.' : errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
    );

    // Clear pending data
    _pendingOrderData = null;
    _pendingShippingAddress = null;
  }

  void _handlePaymentSuccess(
    OrderCreationData orderData,
    ShippingAddressModel finalShippingAddress,
  ) {
    AppLoggerHelper.debug(
      '✅ Payment successful for parent order: ${orderData.parentOrderId}',
    );

    // Create local order model for display (using first order for UI)
    final firstOrder = orderData.orders.isNotEmpty
        ? orderData.orders.first
        : null;

    final order = OrderModel(
      orderId: orderData.parentOrderId,
      userId: _userController.currentUserId ?? 'unknown_user',
      items: _cartController.cartItems,
      shippingAddress: finalShippingAddress,
      deliveryOption: selectedDeliveryOption!,
      paymentMethod: selectedPaymentMethod!,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: orderData.totalAmount,
      couponCode: appliedCoupon?['isValid'] == true
          ? _couponController.text
          : null,
      discount: discountAmount > 0 ? discountAmount : null,
      orderDate: DateTime.now(),
      status: OrderStatus.pending,
      trackingNumber: firstOrder?.trackingNumber ?? '',
      metadata: {
        'deliveryPreference': selectedDeliveryPreference,
        'isUrgent': isUrgentDelivery,
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

    // Clear cart
    _cartController.clearCart();
    _isProcessingPayment.value = false;

    // Show success dialog
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
