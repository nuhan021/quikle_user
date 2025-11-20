import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/profile/data/services/address_service.dart';
import 'package:quikle_user/features/profile/data/models/shipping_address_model.dart';
import 'package:quikle_user/features/profile/controllers/address_controller.dart';
import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';

class AddAddressController extends GetxController {
  final _addressService = Get.find<AddressService>();
  final _addressController = Get.find<AddressController>();

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final zipCodeController = TextEditingController();
  final phoneController = TextEditingController();

  final isLoading = false.obs;
  final isDefault = false.obs;

  final selectedCountry = Rxn<String>();
  final selectedState = Rxn<String>();
  final selectedCity = Rxn<String>();
  final selectedAddressType = Rxn<AddressType>();

  final nameError = ''.obs;
  final addressError = ''.obs;
  final zipCodeError = ''.obs;
  final phoneError = ''.obs;
  final stateError = ''.obs;

  final countries = <String>[].obs;
  final states = <String>[].obs;
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
    selectedCountry.value = 'India'; // Set India as default
    _loadStatesForCountry('India');
    selectedAddressType.value = AddressType.home;
  }

  void _setupListeners() {
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
      selectedState.value = null;
      selectedCity.value = null;
      _loadStatesForCountry(country);
      cities.clear();
    }
  }

  void setState(String? state) {
    if (state != null) {
      selectedState.value = state;

      // Clear previous city selection and cities list
      selectedCity.value = null;
      cities.clear();

      // Load cities for the selected state
      cities.assignAll(_addressService.getCitiesForState(state));
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

  void _loadStatesForCountry(String country) {
    states.assignAll(_addressService.getStatesForCountry(country));
  }

  /* bool _validateForm() {
    bool isValid = true;

    final validationErrors = _addressService.validateAddress(
      name: nameController.text.trim(),
      address: addressController.text.trim(),
      city: selectedCity.value ?? '',
      zipCode: zipCodeController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      country: selectedCountry.value,
      state: selectedState.value,
    );

    nameError.value = validationErrors['name'] ?? '';
    addressError.value = validationErrors['address'] ?? '';
    zipCodeError.value = validationErrors['zipCode'] ?? '';
    phoneError.value = validationErrors['phoneNumber'] ?? '';
    stateError.value = validationErrors['state'] ?? '';

    if (selectedCountry.value == null || selectedCountry.value!.isEmpty) {
      Get.snackbar('Validation Error', 'Please select a country');
      isValid = false;
    }

    if (selectedState.value == null || selectedState.value!.isEmpty) {
      Get.snackbar('Validation Error', 'Please select a state');
      isValid = false;
    }

    if (selectedCity.value == null || selectedCity.value!.isEmpty) {
      Get.snackbar('Validation Error', 'Please select a city');
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
*/
  Future<void> addAddress() async {
    // Basic validation
    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Full name is required';
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      phoneError.value = 'Phone number is required';
      return;
    }

    if (addressController.text.trim().isEmpty) {
      addressError.value = 'Address is required';
      return;
    }

    if (selectedState.value == null || selectedState.value!.isEmpty) {
      Get.snackbar('Validation Error', 'Please select a state');
      return;
    }

    if (selectedCity.value == null || selectedCity.value!.isEmpty) {
      Get.snackbar('Validation Error', 'Please select a city');
      return;
    }

    if (zipCodeController.text.trim().isEmpty) {
      zipCodeError.value = 'Zip code is required';
      return;
    }

    try {
      isLoading.value = true;

      final newAddress = ShippingAddressModel(
        id: '',
        userId: 'user123',
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        city: selectedCity.value!,
        state: selectedState.value!,
        country: selectedCountry.value ?? 'India',
        zipCode: zipCodeController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        type: selectedAddressType.value!,
        isDefault: isDefault.value,
        createdAt: DateTime.now(),
      );

      // The AddressController will handle the API call and refresh
      await _addressController.addAddress(newAddress);

      // Clear form only if successful (AddressController will show success message)
      clearForm();
    } catch (e) {
      // Error is already handled in AddressController
      // Just re-enable the button
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    nameController.clear();
    addressController.clear();
    zipCodeController.clear();
    phoneController.clear();
    selectedCountry.value = 'India';
    selectedState.value = null;
    selectedCity.value = null;
    selectedAddressType.value = AddressType.home;
    isDefault.value = false;
    cities.clear(); // Clear cities when form is cleared
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
    stateError.value = '';
  }
}
