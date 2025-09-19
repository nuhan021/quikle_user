import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/orders/data/models/order_model.dart';
import 'package:quikle_user/features/payout/presentation/widgets/order_success_dialog.dart';
import '../data/models/delivery_option_model.dart';
import '../data/models/payment_method_model.dart';
import '../../profile/data/models/shipping_address_model.dart';
import '../data/services/payout_service.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../user/controllers/user_controller.dart';
import '../../../core/utils/constants/enums/order_enums.dart';
import '../../../core/utils/constants/enums/delivery_enums.dart';

class PayoutController extends GetxController {
  final PayoutService _payoutService = PayoutService();
  final _cartController = Get.find<CartController>();
  final _userController = Get.find<UserController>();

  final _deliveryOptions = <DeliveryOptionModel>[].obs;
  final _deliveryPreferenceController = TextEditingController();
  final _selectedDeliveryPreference = Rxn<String?>(null);
  final _paymentMethods = <PaymentMethodModel>[].obs;
  final _shippingAddresses = <ShippingAddressModel>[].obs;
  final _isUrgentDelivery = false.obs;
  final _couponCode = ''.obs;
  final _appliedCoupon = Rxn<Map<String, dynamic>>();
  final _isProcessingPayment = false.obs;
  final _couponController = TextEditingController();

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
  List<ShippingAddressModel> get shippingAddresses => _shippingAddresses;
  bool get isUrgentDelivery => _isUrgentDelivery.value;
  String get couponCode => _couponCode.value;
  Map<String, dynamic>? get appliedCoupon => _appliedCoupon.value;
  bool get isProcessingPayment => _isProcessingPayment.value;
  TextEditingController get couponController => _couponController;

  bool get canApplyCoupon => _couponCode.value.trim().isNotEmpty;

  DeliveryOptionModel? get selectedDeliveryOption =>
      _deliveryOptions.firstWhereOrNull((option) => option.isSelected);

  PaymentMethodModel? get selectedPaymentMethod =>
      _paymentMethods.firstWhereOrNull((method) => method.isSelected);

  ShippingAddressModel? get selectedShippingAddress =>
      _shippingAddresses.firstWhereOrNull((address) => address.isSelected);

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

    _couponController.addListener(_syncCouponText);
    _deliveryPreferenceController.addListener(() {
      _selectedDeliveryPreference.value =
          _deliveryPreferenceController.text.trim().isNotEmpty
          ? _deliveryPreferenceController.text.trim()
          : null;
    });
  }

  @override
  void onClose() {
    _couponController.removeListener(_syncCouponText);
    _couponController.dispose();
    _deliveryPreferenceController.dispose();
    super.onClose();
  }

  void _syncCouponText() {
    _couponCode.value = _couponController.text;
  }

  void _loadInitialData() {
    _deliveryOptions.value = _payoutService.getDeliveryOptions();
    _paymentMethods.value = _payoutService.getPaymentMethods();
    _shippingAddresses.value = _payoutService.getShippingAddresses();
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
    _shippingAddresses.value = _shippingAddresses.map((item) {
      return item.copyWith(isSelected: item.id == address.id);
    }).toList();
  }

  void toggleUrgentDelivery() {
    _isUrgentDelivery.value = !_isUrgentDelivery.value;

    // When urgent is turned on, prefer split delivery for speed.
    if (_isUrgentDelivery.value) {
      final splitOption = _deliveryOptions.firstWhereOrNull(
        (o) => o.type.name == 'split' || o.type == DeliveryType.split,
      );
      if (splitOption != null) selectDeliveryOption(splitOption);
    } else {
      // revert to combined (cheaper) if available
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

    if (selectedShippingAddress == null && _shippingAddresses.isNotEmpty) {
      selectShippingAddress(_shippingAddresses.first);
    }

    if (selectedDeliveryOption == null ||
        selectedPaymentMethod == null ||
        selectedShippingAddress == null) {
      Get.snackbar('Error', 'Please complete all selections');
      return;
    }

    _isProcessingPayment.value = true;

    try {
      final orderId = 'ORD_${DateTime.now().millisecondsSinceEpoch}';
      final paymentResult = await _payoutService.processPayment(
        amount: totalAmount,
        paymentMethod: selectedPaymentMethod!,
        orderId: orderId,
      );

      if (paymentResult['success'] == true) {
        final order = OrderModel(
          orderId: orderId,
          userId: _userController.currentUserId ?? 'unknown_user',
          items: _cartController.cartItems,
          shippingAddress: selectedShippingAddress!,
          deliveryOption: selectedDeliveryOption!,
          paymentMethod: selectedPaymentMethod!,
          subtotal: subtotal,
          deliveryFee: deliveryFee,
          total: totalAmount,
          couponCode: appliedCoupon?['isValid'] == true
              ? _couponController.text
              : null,
          discount: discountAmount > 0 ? discountAmount : null,
          orderDate: DateTime.now(),
          status: OrderStatus.pending,
          transactionId: paymentResult['transactionId'],
          metadata: {
            'deliveryPreference': selectedDeliveryPreference,
            'isUrgent': isUrgentDelivery,
          },
        );

        _cartController.clearCart();

        Get.dialog(
          OrderSuccessDialog(
            order: order,
            transactionId: paymentResult['transactionId'],
            onContinue: () {
              Get.back();
              Get.offAllNamed('/main');
            },
          ),
          barrierDismissible: false,
        );
      } else {
        Get.snackbar('Payment Failed', paymentResult['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to place order. Please try again.');
    } finally {
      _isProcessingPayment.value = false;
    }
  }
}
