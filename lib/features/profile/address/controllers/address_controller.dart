import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/features/profile/address/data/models/shipping_address_model.dart';
import 'package:quikle_user/features/payout/controllers/receiver_controller.dart';
import 'package:quikle_user/features/profile/address/data/services/address_service.dart';

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

      print('=== LOAD ADDRESSES DEBUG ===');
      print('Loaded ${addresses.length} addresses from API');

      // Auto-select the default address if no address is currently selected
      final hasSelectedAddress = _addresses.any((addr) => addr.isSelected);
      print('Has selected address before load: $hasSelectedAddress');

      if (!hasSelectedAddress && addresses.isNotEmpty) {
        // Find the default address and mark it as selected
        final defaultAddr = addresses.firstWhereOrNull(
          (addr) => addr.isDefault,
        );
        print('Default address found: ${defaultAddr?.name}');

        if (defaultAddr != null) {
          // Mark the default address as selected
          final updatedAddresses = addresses.map((addr) {
            final isSelected = addr.id == defaultAddr.id;
            print('Setting address ${addr.name} isSelected=$isSelected');
            return addr.copyWith(isSelected: isSelected);
          }).toList();
          _addresses.assignAll(updatedAddresses);
        } else {
          // No default address, just select the first one
          print('No default address, selecting first address');
          final updatedAddresses = addresses.asMap().entries.map((entry) {
            final isSelected = entry.key == 0;
            print('Setting address ${entry.value.name} isSelected=$isSelected');
            return entry.value.copyWith(isSelected: isSelected);
          }).toList();
          _addresses.assignAll(updatedAddresses);
        }
      } else {
        print('Keeping existing addresses or no addresses to load');
        _addresses.assignAll(addresses);
      }

      print('Final address count: ${_addresses.length}');
      for (var addr in _addresses) {
        print(
          '  - ${addr.name}: isSelected=${addr.isSelected}, isDefault=${addr.isDefault}',
        );
      }
      print('============================');
      // After loading addresses, ensure receiver details reflect the
      // currently selected address (if any) unless the user has set a
      // different receiver.
      try {
        final receiverCtrl = Get.find<ReceiverController>();
        final selected = _addresses.firstWhereOrNull((a) => a.isSelected);
        if (selected != null && !receiverCtrl.isDifferentReceiver) {
          receiverCtrl.setReceiverDetails(selected.name, selected.phoneNumber);
        }
      } catch (_) {
        // ignore if receiver controller not available
      }
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

      // Get.snackbar(
      //   'Success',
      //   'Address added successfully',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.green[600],
      //   colorText: Colors.white,
      //   duration: const Duration(seconds: 2),
      //   margin: const EdgeInsets.all(12),
      //   borderRadius: 8,
      //   icon: const Icon(Icons.check_circle, color: Colors.white),
      // );
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

      // Call API to delete
      await _addressService.deleteAddress(addressId);

      // Remove from local list
      _addresses.removeWhere((addr) => addr.id == addressId);

      // Notify listeners to update UI
      update();

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

  void selectAddress(ShippingAddressModel address) {
    print('=== SELECT ADDRESS DEBUG ===');
    print('Selecting address: ${address.name} (ID: ${address.id})');
    print('Current addresses before selection:');
    for (var addr in _addresses) {
      print('  - ${addr.name}: isSelected=${addr.isSelected}');
    }

    // Update all addresses - mark the selected one as isSelected=true, others as false
    final updatedAddresses = _addresses.map((item) {
      final isSelected = item.id == address.id;
      print(
        'Setting ${item.name} isSelected=$isSelected (ID match: ${item.id} == ${address.id})',
      );
      return item.copyWith(isSelected: isSelected);
    }).toList();
    _addresses.assignAll(updatedAddresses);

    print('Addresses after selection:');
    for (var addr in _addresses) {
      print('  - ${addr.name}: isSelected=${addr.isSelected}');
    }
    print('===========================');

    update();
    // Update receiver details in Payout flow to reflect the newly selected
    // shipping address, but don't override if the user has explicitly set a
    // different receiver (receiverController.isDifferentReceiver == true).
    try {
      final receiverCtrl = Get.find<ReceiverController>();
      if (!receiverCtrl.isDifferentReceiver) {
        receiverCtrl.setReceiverDetails(address.name, address.phoneNumber);
      }
    } catch (_) {
      // No-op if ReceiverController isn't available
    }
  }

  /// Optimistically set the given address as default (local UI update),
  /// then persist to backend. If persistence fails, roll back to previous
  /// state and notify the user.
  Future<void> selectAndPersistDefault(String addressId) async {
    // Snapshot previous state for rollback
    final previous = List<ShippingAddressModel>.from(_addresses);

    // Apply optimistic change: mark the selected address as default & selected
    final updated = _addresses.map((addr) {
      final isSelected = addr.id == addressId;
      final isDefault = addr.id == addressId;
      return addr.copyWith(isSelected: isSelected, isDefault: isDefault);
    }).toList();

    _addresses.assignAll(updated);
    update();

    // Update receiver to reflect optimistic selection
    try {
      final receiverCtrl = Get.find<ReceiverController>();
      final selected = _addresses.firstWhereOrNull((a) => a.isSelected);
      if (selected != null && !receiverCtrl.isDifferentReceiver) {
        receiverCtrl.setReceiverDetails(selected.name, selected.phoneNumber);
      }
    } catch (_) {}

    // Persist change to backend
    try {
      await setAsDefault(addressId);
    } catch (e) {
      // Rollback on failure
      _addresses.assignAll(previous);
      update();
      Get.snackbar('Error', 'Failed to set default address');
    }
  }

  void clearAllAddresses() {
    _addresses.clear();
  }
}
