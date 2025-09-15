import 'package:get/get.dart';
import 'package:quikle_user/features/profile/data/models/shipping_address_model.dart';
import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';

class AddressService extends GetxService {
  Future<List<ShippingAddressModel>> fetchAddresses(String userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final mockAddresses = [
        ShippingAddressModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          name: 'Olivia Austin',
          address: '2811 Crescent Day. LA Port',
          city: 'California',
          state: 'California',
          zipCode: '77571',
          phoneNumber: '+1 (555) 123-4567',
          type: AddressType.home,
          isDefault: true,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        ShippingAddressModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + '1',
          userId: userId,
          name: 'Olivia Austin',
          address: '2811 Crescent Day. LA Port',
          city: 'California',
          state: 'California',
          zipCode: '77571',
          phoneNumber: '+1 (555) 123-4567',
          type: AddressType.office,
          isDefault: false,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),
      ];

      return mockAddresses;
    } catch (e) {
      throw Exception('Failed to fetch addresses: $e');
    }
  }

  Future<ShippingAddressModel> addAddress(ShippingAddressModel address) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      final newAddress = address.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
      );

      return newAddress;
    } catch (e) {
      throw Exception('Failed to add address: $e');
    }
  }

  Future<ShippingAddressModel> updateAddress(
    ShippingAddressModel address,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      final updatedAddress = address.copyWith(updatedAt: DateTime.now());
      return updatedAddress;
    } catch (e) {
      throw Exception('Failed to update address: $e');
    }
  }

  Future<bool> deleteAddress(String addressId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      return true;
    } catch (e) {
      throw Exception('Failed to delete address: $e');
    }
  }

  Future<bool> setDefaultAddress(String addressId, String userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return true;
    } catch (e) {
      throw Exception('Failed to set default address: $e');
    }
  }

  Map<String, String?> validateAddress({
    required String name,
    required String address,
    required String city,
    required String zipCode,
    required String phoneNumber,
    String? country,
    String? state,
  }) {
    final errors = <String, String?>{};
    if (name.trim().isEmpty) {
      errors['name'] = 'Full name is required';
    } else if (name.trim().length < 2) {
      errors['name'] = 'Name must be at least 2 characters';
    }
    if (address.trim().isEmpty) {
      errors['address'] = 'Address is required';
    } else if (address.trim().length < 5) {
      errors['address'] = 'Address must be at least 5 characters';
    }
    if (city.trim().isEmpty) {
      errors['city'] = 'City is required';
    }
    if (zipCode.trim().isEmpty) {
      errors['zipCode'] = 'ZIP code is required';
    } else if (!RegExp(r'^\d{5}(-\d{4})?$').hasMatch(zipCode.trim())) {
      errors['zipCode'] = 'Invalid ZIP code format';
    }
    if (phoneNumber.trim().isEmpty) {
      errors['phoneNumber'] = 'Phone number is required';
    } else if (!RegExp(
      r'^\+?[\d\s\-\(\)]{10,}$',
    ).hasMatch(phoneNumber.trim())) {
      errors['phoneNumber'] = 'Invalid phone number format';
    }

    return errors;
  }

  List<String> getCountries() {
    return [
      'United States',
      'Canada',
      'United Kingdom',
      'Australia',
      'Germany',
      'France',
      'Japan',
      'India',
      'Brazil',
      'Mexico',
    ];
  }

  List<String> getStatesForCountry(String country) {
    switch (country) {
      case 'United States':
        return [
          'California',
          'New York',
          'Texas',
          'Florida',
          'Illinois',
          'Pennsylvania',
          'Ohio',
          'Georgia',
          'North Carolina',
          'Michigan',
        ];
      default:
        return ['State/Province'];
    }
  }

  List<String> getCitiesForState(String state) {
    switch (state) {
      case 'California':
        return [
          'Los Angeles',
          'San Francisco',
          'San Diego',
          'Sacramento',
          'Oakland',
          'Fresno',
          'Long Beach',
          'Bakersfield',
        ];
      case 'New York':
        return [
          'New York City',
          'Buffalo',
          'Rochester',
          'Syracuse',
          'Albany',
          'Yonkers',
        ];
      default:
        return ['City'];
    }
  }
}
