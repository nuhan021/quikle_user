import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/profile/data/models/shipping_address_model.dart';
import 'package:quikle_user/features/profile/data/services/address_service.dart';

class AddressController extends GetxController {
  final _addressService = AddressService();
  final _addresses = <ShippingAddressModel>[].obs;
  final _isLoading = false.obs;
  List<ShippingAddressModel> get addresses => _addresses;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    _isLoading.value = true;

    try {
      final addresses = await _addressService.fetchAddresses('user123');
      _addresses.assignAll(addresses);
    } catch (e) {
      print('Error loading addresses: $e');
    } finally {
      _isLoading.value = false;
    }
    update();
  }

  Future<void> addAddress(ShippingAddressModel address) async {
    _isLoading.value = true;

    try {
      // Call the API to add the address
      await _addressService.addAddress(address);

      // Refresh the address list from the server to get the latest data
      await loadAddresses();

      Get.back();
      Get.snackbar(
        'Success',
        'Address added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[600],
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add address: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateAddress(ShippingAddressModel updatedAddress) async {
    _isLoading.value = true;

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final index = _addresses.indexWhere(
        (addr) => addr.id == updatedAddress.id,
      );
      if (index != -1) {
        if (updatedAddress.isDefault) {
          _setAllAddressesNonDefault();
        }

        _addresses[index] = updatedAddress;
        Get.snackbar('Success', 'Address updated successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update address');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> deleteAddress(String addressId) async {
    _isLoading.value = true;

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      _addresses.removeWhere((addr) => addr.id == addressId);
      await _addressService.deleteAddress(addressId);
      Get.snackbar('Success', 'Address deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete address');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> setAsDefault(String addressId) async {
    try {
      _isLoading.value = true;

      // Call the API to set the address as default
      await _addressService.setDefaultAddress(addressId);

      // Refresh the address list from the server to get updated data
      await loadAddresses();

      Get.snackbar(
        'Success',
        'Default address updated',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[600],
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update default address: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void _setAllAddressesNonDefault() {
    for (int i = 0; i < _addresses.length; i++) {
      if (_addresses[i].isDefault) {
        _addresses[i] = _addresses[i].copyWith(isDefault: false);
      }
    }
  }

  ShippingAddressModel? get defaultAddress {
    try {
      return _addresses.firstWhere((addr) => addr.isDefault);
    } catch (e) {
      return null;
    }
  }

  void clearAllAddresses() {
    _addresses.clear();
  }
}
