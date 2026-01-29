import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/profile/address/data/models/shipping_address_model.dart';

class ReceiverController extends GetxController {
  final _isDifferentReceiver = false.obs;
  final _receiverNameController = TextEditingController();
  final _receiverPhoneController = TextEditingController();

  bool get isDifferentReceiver => _isDifferentReceiver.value;
  TextEditingController get receiverNameController => _receiverNameController;
  TextEditingController get receiverPhoneController => _receiverPhoneController;
  String get receiverName => _receiverNameController.text.trim();
  String get receiverPhone => _receiverPhoneController.text.trim();

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

  String getCurrentReceiverName(ShippingAddressModel? selected) {
    if (isDifferentReceiver && receiverName.isNotEmpty) return receiverName;
    if (selected != null) return selected.name;
    return 'You';
  }

  String getCurrentReceiverPhone(ShippingAddressModel? selected) {
    if (isDifferentReceiver && receiverPhone.isNotEmpty) return receiverPhone;
    if (selected != null) return selected.phoneNumber;
    return '';
  }
}
