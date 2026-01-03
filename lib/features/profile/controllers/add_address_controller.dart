import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:quikle_user/features/profile/data/services/address_service.dart';
import 'package:quikle_user/features/profile/data/models/shipping_address_model.dart';
import 'package:quikle_user/features/profile/controllers/address_controller.dart';
import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';

class AddAddressController extends GetxController {
  final _addressService = Get.find<AddressService>();
  final _addressController = Get.find<AddressController>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final flatHouseBuildingController = TextEditingController();
  final floorNumberController = TextEditingController();
  final nearbyLandmarkController = TextEditingController();
  final addressController = TextEditingController();
  final zipCodeController = TextEditingController();
  final stateTextController = TextEditingController();
  final cityTextController = TextEditingController();

  final isLoading = false.obs;
  final isDefault = false.obs;
  final useCurrentLocation = false.obs;
  final isAddressFromMap = false.obs; // Track if address was selected from map
  final willOpenMap = false.obs; // Track if user is navigating to map picker

  final selectedCountry = Rxn<String>();
  final selectedState = Rxn<String>();
  final selectedCity = Rxn<String>();
  final selectedAddressType = Rxn<AddressType>();

  final nameError = ''.obs;
  final phoneError = ''.obs;
  final flatHouseBuildingError = ''.obs;
  final nearbyLandmarkError = ''.obs;
  final addressError = ''.obs;
  final zipCodeError = ''.obs;
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
    phoneController.dispose();
    flatHouseBuildingController.dispose();
    floorNumberController.dispose();
    nearbyLandmarkController.dispose();
    addressController.dispose();
    zipCodeController.dispose();
    stateTextController.dispose();
    cityTextController.dispose();
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
    phoneController.addListener(() {
      if (phoneError.value.isNotEmpty) phoneError.value = '';
    });
    flatHouseBuildingController.addListener(() {
      if (flatHouseBuildingError.value.isNotEmpty)
        flatHouseBuildingError.value = '';
    });
    nearbyLandmarkController.addListener(() {
      if (nearbyLandmarkError.value.isNotEmpty) nearbyLandmarkError.value = '';
    });
    addressController.addListener(() {
      if (addressError.value.isNotEmpty) addressError.value = '';
    });
    zipCodeController.addListener(() {
      if (zipCodeError.value.isNotEmpty) zipCodeError.value = '';
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
      stateTextController.text = state;

      // Clear previous city selection and cities list
      selectedCity.value = null;
      cityTextController.clear();
      cities.clear();

      // Load cities for the selected state
      cities.assignAll(_addressService.getCitiesForState(state));
    }
  }

  void setStateManually(String? state) {
    selectedState.value = state;
    // No need to update stateTextController here as it's already being updated by user typing
  }

  void setCity(String? city) {
    selectedCity.value = city;
    if (city != null) {
      cityTextController.text = city;
    }
  }

  void setCityManually(String? city) {
    selectedCity.value = city;
    // No need to update cityTextController here as it's already being updated by user typing
  }

  void setAddressType(AddressType type) {
    selectedAddressType.value = type;
  }

  void setUseCurrentLocation(bool value) {
    useCurrentLocation.value = value;
  }

  /// Get current location and reverse geocode to get address details
  Future<bool> getCurrentLocationAndPopulateAddress() async {
    try {
      isLoading.value = true;

      // Check if location services are enabled first
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'Location Service Disabled',
          'Please enable location services to continue',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      // Check and request location permission using Geolocator
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Permission Denied',
            'Location permission is required to use current location',
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permission Required',
          'Please enable location permission in app settings',
          snackPosition: SnackPosition.BOTTOM,
          mainButton: TextButton(
            onPressed: () => Geolocator.openLocationSettings(),
            child: const Text('Settings'),
          ),
        );
        return false;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Reverse geocode to get address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        // Build full address string
        String fullAddress = '';
        if (place.street != null && place.street!.isNotEmpty) {
          fullAddress += place.street!;
        }
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          if (fullAddress.isNotEmpty) fullAddress += ', ';
          fullAddress += place.subLocality!;
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          if (fullAddress.isNotEmpty) fullAddress += ', ';
          fullAddress += place.locality!;
        }

        // Populate the address controller
        addressController.text = fullAddress;
        isAddressFromMap.value = true; // Mark as from map

        // Set city
        if (place.locality != null && place.locality!.isNotEmpty) {
          selectedCity.value = place.locality;
          cityTextController.text = place.locality!;
        } else if (place.subAdministrativeArea != null &&
            place.subAdministrativeArea!.isNotEmpty) {
          selectedCity.value = place.subAdministrativeArea;
          cityTextController.text = place.subAdministrativeArea!;
        }

        // Set state
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          selectedState.value = place.administrativeArea;
          stateTextController.text = place.administrativeArea!;
        }

        // Set country
        if (place.country != null && place.country!.isNotEmpty) {
          selectedCountry.value = place.country;
        }

        // Set zip code/postal code
        if (place.postalCode != null && place.postalCode!.isNotEmpty) {
          zipCodeController.text = place.postalCode!;
        }

        return true;
      } else {
        Get.snackbar(
          'Error',
          'Unable to get address from location',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get current location: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
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
    // Basic validation - only validate user-visible fields
    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Full name is required';
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      phoneError.value = 'Phone number is required';
      return;
    }

    if (flatHouseBuildingController.text.trim().isEmpty) {
      flatHouseBuildingError.value = 'This field is required';
      return;
    }

    // if (nearbyLandmarkController.text.trim().isEmpty) {
    //   nearbyLandmarkError.value = 'Landmark is required';
    //   return;
    // }

    if (addressController.text.trim().isEmpty) {
      addressError.value = 'Full address is required';
      return;
    }

    // Note: Country, State, City, and Zip Code will be auto-populated from map/current location
    // For now, we'll use default values. You should implement the location services to populate these.
    if (selectedState.value == null || selectedState.value!.isEmpty) {
      selectedState.value =
          'DefaultState'; // TODO: Get from map/location service
    }

    if (selectedCity.value == null || selectedCity.value!.isEmpty) {
      selectedCity.value = 'DefaultCity'; // TODO: Get from map/location service
    }

    if (zipCodeController.text.trim().isEmpty) {
      zipCodeController.text = '000000'; // TODO: Get from map/location service
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
        landmark: nearbyLandmarkController.text.trim(),
        flatHouseBuilding: flatHouseBuildingController.text.trim(),
        floorNumber: floorNumberController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        type: selectedAddressType.value!,
        isDefault: true, // Always send true to database
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
    phoneController.clear();
    flatHouseBuildingController.clear();
    floorNumberController.clear();
    nearbyLandmarkController.clear();
    addressController.clear();
    zipCodeController.clear();
    stateTextController.clear();
    cityTextController.clear();
    selectedCountry.value = 'India';
    selectedState.value = null;
    selectedCity.value = null;
    selectedAddressType.value = AddressType.home;
    isDefault.value = false;
    useCurrentLocation.value = false;
    isAddressFromMap.value = false; // Reset map flag
    willOpenMap.value = false; // Reset navigation-to-map flag
    cities.clear(); // Clear cities when form is cleared
    _clearErrors();
  }

  void setDefault(bool value) {
    isDefault.value = value;
  }

  void _clearErrors() {
    nameError.value = '';
    phoneError.value = '';
    flatHouseBuildingError.value = '';
    nearbyLandmarkError.value = '';
    addressError.value = '';
    zipCodeError.value = '';
    stateError.value = '';
  }

  // Pre-fill form for editing an existing address
  void prefillAddress(ShippingAddressModel address) {
    nameController.text = address.name;
    phoneController.text = address.phoneNumber;
    flatHouseBuildingController.text = address.flatHouseBuilding ?? '';
    floorNumberController.text = address.floorNumber ?? '';
    nearbyLandmarkController.text = address.landmark ?? '';
    addressController.text = address.address;
    zipCodeController.text = address.zipCode;

    selectedCountry.value = address.country;
    _loadStatesForCountry(address.country);

    selectedState.value = address.state;
    stateTextController.text = address.state;
    cities.assignAll(_addressService.getCitiesForState(address.state));

    selectedCity.value = address.city;
    cityTextController.text = address.city;
    selectedAddressType.value = address.type;
    isDefault.value = address.isDefault;
  }

  // Update an existing address
  Future<void> updateAddress(String addressId) async {
    // Basic validation - only validate user-visible fields
    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Full name is required';
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      phoneError.value = 'Phone number is required';
      return;
    }

    if (flatHouseBuildingController.text.trim().isEmpty) {
      flatHouseBuildingError.value = 'This field is required';
      return;
    }

    // if (nearbyLandmarkController.text.trim().isEmpty) {
    //   nearbyLandmarkError.value = 'Landmark is required';
    //   return;
    // }

    if (addressController.text.trim().isEmpty) {
      addressError.value = 'Full address is required';
      return;
    }

    // Note: Country, State, City, and Zip Code will be auto-populated from map/current location
    // For now, we'll use default values if not already set
    if (selectedState.value == null || selectedState.value!.isEmpty) {
      selectedState.value =
          'DefaultState'; // TODO: Get from map/location service
    }

    if (selectedCity.value == null || selectedCity.value!.isEmpty) {
      selectedCity.value = 'DefaultCity'; // TODO: Get from map/location service
    }

    if (zipCodeController.text.trim().isEmpty) {
      zipCodeController.text = '000000'; // TODO: Get from map/location service
    }

    try {
      isLoading.value = true;

      final updatedAddress = ShippingAddressModel(
        id: addressId,
        userId: 'user123',
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        city: selectedCity.value!,
        state: selectedState.value!,
        country: selectedCountry.value ?? 'India',
        zipCode: zipCodeController.text.trim(),
        landmark: nearbyLandmarkController.text.trim(),
        flatHouseBuilding: flatHouseBuildingController.text.trim(),
        floorNumber: floorNumberController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        type: selectedAddressType.value!,
        isDefault: isDefault.value, // Keep existing value when updating
        createdAt: DateTime.now(),
      );

      // The AddressController will handle the API call and refresh
      await _addressController.updateAddress(updatedAddress);

      // Clear form only if successful
      clearForm();
    } catch (e) {
      // Error is already handled in AddressController
    } finally {
      isLoading.value = false;
    }
  }
}
