import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/services/storage_service.dart';
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
    // Only load addresses if token exists (user is logged in)
    if (StorageService.hasToken()) {
      loadAddresses();
    }
  }

  Future<void> loadAddresses() async {
    // Don't attempt to load if no token
    if (!StorageService.hasToken()) {
      _addresses.clear();
      return;
    }

    _isLoading.value = true;

    try {
      final addresses = await _addressService.fetchAddresses();
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

      // Close the bottom sheet first
      Get.back();

      // Add a small delay before showing snackbar to avoid initialization error
      await Future.delayed(const Duration(milliseconds: 100));

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
      // Call the API to update the address
      await _addressService.updateAddress(updatedAddress);

      // Refresh the address list from the server to get the latest data
      await loadAddresses();

      // Close the bottom sheet first
      Get.back();

      // Add a small delay before showing snackbar to avoid initialization error
      await Future.delayed(const Duration(milliseconds: 100));

      Get.snackbar(
        'Success',
        'Address updated successfully',
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
        'Failed to update address: ${e.toString()}',
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

      // Wait for bottom sheet to fully close and overlay to be available
      // Use a longer delay to ensure navigation is complete
      await Future.delayed(const Duration(milliseconds: 600));

      // // Check if we have a valid context before showing snackbar
      // if (Get.isSnackbarOpen != true) {
      //   Get.snackbar(
      //     'Success',
      //     'Default address updated',
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.green[600],
      //     colorText: Colors.white,
      //     duration: const Duration(seconds: 2),
      //     margin: const EdgeInsets.all(12),
      //     borderRadius: 8,
      //     icon: const Icon(Icons.check_circle, color: Colors.white),
      //   );
      // }
    } catch (e) {
      // Wait for bottom sheet to close before showing error
      await Future.delayed(const Duration(milliseconds: 600));

      if (Get.isSnackbarOpen != true) {
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
      }
    } finally {
      _isLoading.value = false;
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
