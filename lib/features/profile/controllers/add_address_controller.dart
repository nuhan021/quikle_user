import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/profile/data/services/address_service.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/features/profile/data/models/shipping_address_model.dart';
import 'package:quikle_user/features/profile/controllers/address_controller.dart';
import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';

class AddAddressController extends GetxController {
  // Services
  final _addressService = Get.find<AddressService>();
  final _addressController = Get.find<AddressController>();

  // Text Controllers
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final zipCodeController = TextEditingController();
  final phoneController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final isDefault = false.obs;

  // Dropdown selections
  final selectedCountry = Rxn<String>();
  final selectedCity = Rxn<String>();
  final selectedAddressType = Rxn<AddressType>();

  // Error messages
  final nameError = ''.obs;
  final addressError = ''.obs;
  final zipCodeError = ''.obs;
  final phoneError = ''.obs;

  // Data lists
  final countries = <String>[].obs;
  final cities = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
    _setupListeners();
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    zipCodeController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void _loadInitialData() {
    countries.assignAll(_addressService.getCountries());
    // Set default country
    selectedCountry.value = 'United States';
    _loadCitiesForCountry('United States');

    // Set default address type
    selectedAddressType.value = AddressType.home;
  }

  void _setupListeners() {
    // Clear errors when user starts typing
    nameController.addListener(() {
      if (nameError.value.isNotEmpty) nameError.value = '';
    });

    addressController.addListener(() {
      if (addressError.value.isNotEmpty) addressError.value = '';
    });

    zipCodeController.addListener(() {
      if (zipCodeError.value.isNotEmpty) zipCodeError.value = '';
    });

    phoneController.addListener(() {
      if (phoneError.value.isNotEmpty) phoneError.value = '';
    });
  }

  void setCountry(String? country) {
    if (country != null) {
      selectedCountry.value = country;
      selectedCity.value = null; // Reset city when country changes
      _loadCitiesForCountry(country);
    }
  }

  void setCity(String? city) {
    selectedCity.value = city;
  }

  void setAddressType(AddressType type) {
    selectedAddressType.value = type;
  }

  void toggleIsDefault() {
    isDefault.value = !isDefault.value;
  }

  void _loadCitiesForCountry(String country) {
    final stateCities = _addressService.getStatesForCountry(country);
    if (stateCities.isNotEmpty) {
      final allCities = <String>[];
      for (String state in stateCities) {
        allCities.addAll(_addressService.getCitiesForState(state));
      }
      cities.assignAll(allCities.toSet().toList()..sort());
    }
  }

  bool _validateForm() {
    bool isValid = true;

    final validationErrors = _addressService.validateAddress(
      name: nameController.text.trim(),
      address: addressController.text.trim(),
      city: selectedCity.value ?? '',
      zipCode: zipCodeController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      country: selectedCountry.value,
    );

    // Set error messages
    nameError.value = validationErrors['name'] ?? '';
    addressError.value = validationErrors['address'] ?? '';
    zipCodeError.value = validationErrors['zipCode'] ?? '';
    phoneError.value = validationErrors['phoneNumber'] ?? '';

    // Check dropdown validations
    if (selectedCity.value == null || selectedCity.value!.isEmpty) {
      Get.snackbar('Validation Error', 'Please select a city');
      isValid = false;
    }

    if (selectedCountry.value == null || selectedCountry.value!.isEmpty) {
      Get.snackbar('Validation Error', 'Please select a country');
      isValid = false;
    }

    if (selectedAddressType.value == null) {
      Get.snackbar('Validation Error', 'Please select address type');
      isValid = false;
    }

    return isValid &&
        validationErrors.values.every(
          (error) => error == null || error.isEmpty,
        );
  }

  Future<void> addAddress() async {
    if (!_validateForm()) return;

    try {
      isLoading.value = true;

      // Create new address model
      final newAddress = ShippingAddressModel(
        id: '', // Will be set by service
        userId: 'user123', // In real app, get from auth service
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        city: selectedCity.value!,
        state: selectedCountry.value!, // Using country as state for simplicity
        zipCode: zipCodeController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        type: selectedAddressType.value!,
        isDefault: isDefault.value,
        createdAt: DateTime.now(),
      );

      // Add address through service
      final addedAddress = await _addressService.addAddress(newAddress);

      // Add to address controller
      await _addressController.addAddress(addedAddress);

      // Close modal and show success message
      clearForm();
      Get.back();
      Get.snackbar(
        'Success',
        'Address added successfully',

        backgroundColor: AppColors.freeColor,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add address: ${e.toString()}',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    nameController.clear();
    addressController.clear();
    zipCodeController.clear();
    phoneController.clear();
    selectedCountry.value = 'United States';
    selectedCity.value = null;
    selectedAddressType.value = AddressType.home;
    isDefault.value = false;
    _clearErrors();
  }

  void setDefault(bool value) {
    isDefault.value = value;
  }

  void _clearErrors() {
    nameError.value = '';
    addressError.value = '';
    zipCodeError.value = '';
    phoneError.value = '';
  }
}
