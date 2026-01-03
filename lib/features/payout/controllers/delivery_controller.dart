import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/payout/data/models/delivery_option_model.dart';
import 'package:quikle_user/features/payout/data/services/payout_service.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../core/utils/constants/enums/delivery_enums.dart';

class DeliveryController extends GetxController {
  final PayoutService _payoutService = PayoutService();
  final _cartController = Get.find<CartController>();

  final _deliveryOptions = <DeliveryOptionModel>[].obs;
  final _deliveryPreferenceController = TextEditingController();
  final _selectedDeliveryPreference = Rxn<String?>(null);
  final _isUrgentDelivery = false.obs;

  List<DeliveryOptionModel> get deliveryOptions => _deliveryOptions;
  TextEditingController get deliveryPreferenceController =>
      _deliveryPreferenceController;
  String? get selectedDeliveryPreference {
    final explicit = _selectedDeliveryPreference.value;
    if (explicit != null && explicit.trim().isNotEmpty) return explicit;
    final typed = _deliveryPreferenceController.text.trim();
    return typed.isNotEmpty ? typed : null;
  }

  bool get isUrgentDelivery => _isUrgentDelivery.value;

  DeliveryOptionModel? get selectedDeliveryOption =>
      _deliveryOptions.firstWhereOrNull((option) => option.isSelected);

  double get deliveryFee {
    double baseFee = selectedDeliveryOption?.price ?? 0.0;
    if (isUrgentDelivery) baseFee += 2.0;
    return baseFee;
  }

  @override
  void onInit() {
    super.onInit();
    _deliveryOptions.value = _payoutService.getDeliveryOptions();
    _deliveryPreferenceController.addListener(() {
      _selectedDeliveryPreference.value =
          _deliveryPreferenceController.text.trim().isNotEmpty
          ? _deliveryPreferenceController.text.trim()
          : null;
    });

    // listen to cart changes to update urgency behavior
    ever(
      _cartController.cartItemsObservable,
      (_) => _updateDeliveryBasedOnUrgency(),
    );
    _updateDeliveryBasedOnUrgency();
  }

  @override
  void onClose() {
    _deliveryPreferenceController.dispose();
    super.onClose();
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

  void toggleUrgentDelivery() {
    // Toggle the urgent delivery state
    _isUrgentDelivery.value = !_isUrgentDelivery.value;

    // Update all medicine items' urgent status to match the toggle
    _cartController.updateAllMedicineItemsUrgentStatus(_isUrgentDelivery.value);

    _updateDeliveryOptions();
  }

  void _updateDeliveryBasedOnUrgency() {
    final hasUrgentItems = _cartController.hasUrgentItems;
    final hasMedicineItems = _cartController.hasMedicineItems;

    // Only auto-update the toggle if there are medicine items
    // and the urgent status has changed
    if (hasMedicineItems) {
      // If cart has urgent items but toggle is off, turn it on
      if (hasUrgentItems && !_isUrgentDelivery.value) {
        _isUrgentDelivery.value = true;
      }
      // If cart has no urgent items but toggle is on, don't auto-turn off
      // Let user manually control it via toggle
    } else {
      // No medicine items, ensure urgent is off
      if (_isUrgentDelivery.value) {
        _isUrgentDelivery.value = false;
      }
    }

    _updateDeliveryOptions();
  }

  void _updateDeliveryOptions() {
    final hasMultipleCategories = _cartController.hasMultipleCategories;
    final shouldUseSplit = _isUrgentDelivery.value && hasMultipleCategories;

    if (shouldUseSplit) {
      final splitOption = _deliveryOptions.firstWhereOrNull(
        (o) => o.type.name == 'split' || o.type == DeliveryType.split,
      );
      if (splitOption != null) selectDeliveryOption(splitOption);
    } else {
      final combinedOption = _deliveryOptions.firstWhereOrNull(
        (o) => o.type.name == 'combined' || o.type == DeliveryType.combined,
      );
      if (combinedOption != null) selectDeliveryOption(combinedOption);
    }
  }
}
