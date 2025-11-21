// import 'package:get/get.dart';
// import 'package:quikle_user/features/profile/data/models/shipping_address_model.dart';
// import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';

// class AddressService extends GetxService {
//   Future<List<ShippingAddressModel>> fetchAddresses(String userId) async {
//     try {
//       await Future.delayed(const Duration(milliseconds: 500));
//       final mockAddresses = [
//         ShippingAddressModel(
//           id: DateTime.now().millisecondsSinceEpoch.toString(),
//           userId: userId,
//           name: 'Olivia Austin',
//           address: '2811 Crescent Day. LA Port',
//           city: 'California',
//           state: 'California',
//           zipCode: '77571',
//           phoneNumber: '+1 (555) 123-4567',
//           type: AddressType.home,
//           isDefault: true,
//           createdAt: DateTime.now().subtract(const Duration(days: 30)),
//         ),
//         ShippingAddressModel(
//           id: DateTime.now().millisecondsSinceEpoch.toString() + '1',
//           userId: userId,
//           name: 'Olivia Mark',
//           address: '1100 Crescent Day. LA Port',
//           city: 'California',
//           state: 'California',
//           zipCode: '77571',
//           phoneNumber: '+1 (555) 123-4567',
//           type: AddressType.office,
//           isDefault: false,
//           createdAt: DateTime.now().subtract(const Duration(days: 15)),
//         ),
//       ];

//       return mockAddresses;
//     } catch (e) {
//       throw Exception('Failed to fetch addresses: $e');
//     }
//   }

//   Future<ShippingAddressModel> addAddress(ShippingAddressModel address) async {
//     try {
//       await Future.delayed(const Duration(milliseconds: 800));
//       final newAddress = address.copyWith(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         createdAt: DateTime.now(),
//       );

//       return newAddress;
//     } catch (e) {
//       throw Exception('Failed to add address: $e');
//     }
//   }

//   Future<ShippingAddressModel> updateAddress(
//     ShippingAddressModel address,
//   ) async {
//     try {
//       await Future.delayed(const Duration(milliseconds: 600));
//       final updatedAddress = address.copyWith(updatedAt: DateTime.now());
//       return updatedAddress;
//     } catch (e) {
//       throw Exception('Failed to update address: $e');
//     }
//   }

//   Future<bool> deleteAddress(String addressId) async {
//     try {
//       await Future.delayed(const Duration(milliseconds: 400));
//       return true;
//     } catch (e) {
//       throw Exception('Failed to delete address: $e');
//     }
//   }

//   Future<bool> setDefaultAddress(String addressId, String userId) async {
//     try {
//       await Future.delayed(const Duration(milliseconds: 300));
//       return true;
//     } catch (e) {
//       throw Exception('Failed to set default address: $e');
//     }
//   }

//   Map<String, String?> validateAddress({
//     required String name,
//     required String address,
//     required String city,
//     required String zipCode,
//     required String phoneNumber,
//     String? country,
//     String? state,
//   }) {
//     final errors = <String, String?>{};
//     if (name.trim().isEmpty) {
//       errors['name'] = 'Full name is required';
//     } else if (name.trim().length < 2) {
//       errors['name'] = 'Name must be at least 2 characters';
//     }
//     if (address.trim().isEmpty) {
//       errors['address'] = 'Address is required';
//     } else if (address.trim().length < 5) {
//       errors['address'] = 'Address must be at least 5 characters';
//     }
//     if (city.trim().isEmpty) {
//       errors['city'] = 'City is required';
//     }
//     if (zipCode.trim().isEmpty) {
//       errors['zipCode'] = 'ZIP code is required';
//     } else if (!RegExp(r'^\d{5}(-\d{4})?$').hasMatch(zipCode.trim())) {
//       errors['zipCode'] = 'Invalid ZIP code format';
//     }
//     if (phoneNumber.trim().isEmpty) {
//       errors['phoneNumber'] = 'Phone number is required';
//     } else if (!RegExp(
//       r'^\+?[\d\s\-\(\)]{10,}$',
//     ).hasMatch(phoneNumber.trim())) {
//       errors['phoneNumber'] = 'Invalid phone number format';
//     }

//     return errors;
//   }

//   List<String> getCountries() {
//     return [
//       'United States',
//       'Canada',
//       'United Kingdom',
//       'Australia',
//       'Germany',
//       'France',
//       'Japan',
//       'India',
//       'Brazil',
//       'Mexico',
//     ];
//   }

//   List<String> getStatesForCountry(String country) {
//     switch (country) {
//       case 'United States':
//         return [
//           'California',
//           'New York',
//           'Texas',
//           'Florida',
//           'Illinois',
//           'Pennsylvania',
//           'Ohio',
//           'Georgia',
//           'North Carolina',
//           'Michigan',
//         ];
//       default:
//         return ['State/Province'];
//     }
//   }

//   List<String> getCitiesForState(String state) {
//     switch (state) {
//       case 'California':
//         return [
//           'Los Angeles',
//           'San Francisco',
//           'San Diego',
//           'Sacramento',
//           'Oakland',
//           'Fresno',
//           'Long Beach',
//           'Bakersfield',
//         ];
//       case 'New York':
//         return [
//           'New York City',
//           'Buffalo',
//           'Rochester',
//           'Syracuse',
//           'Albany',
//           'Yonkers',
//         ];
//       default:
//         return ['City'];
//     }
//   }
// }
import 'package:get/get.dart';
import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/profile/data/models/shipping_address_model.dart';
import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';

class AddressService extends GetxService {
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<List<ShippingAddressModel>> fetchAddresses() async {
    try {
      AppLoggerHelper.debug('Fetching addresses');

      final token = StorageService.token;
      final refreshToken = StorageService.refreshToken;

      AppLoggerHelper.debug('Using token: $token');
      AppLoggerHelper.debug('Using refresh token: $refreshToken');

      final ResponseData response = await _networkCaller.getRequest(
        ApiConstants.getShippingAddresses,
        headers: {
          'Authorization': 'Bearer $token',
          'refresh-token': refreshToken ?? '',
        },
      );

      AppLoggerHelper.debug('Address status: ${response.statusCode}');
      AppLoggerHelper.debug('Raw response: ${response.responseData}');

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData;

        // Validate new structure
        if (data is Map<String, dynamic> && data['addresses'] is List) {
          final List addrList = data['addresses'];

          AppLoggerHelper.debug('Fetched ${addrList.length} addresses');

          final addresses = addrList
              .map(
                (json) =>
                    ShippingAddressModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();

          return addresses;
        } else {
          AppLoggerHelper.warning('Unexpected response format');
          return [];
        }
      }

      AppLoggerHelper.warning('API call failed or no data');
      return [];
    } catch (e) {
      AppLoggerHelper.error('❌ Error fetching addresses', e);
      throw Exception('Failed to fetch addresses: $e');
    }
  }

  Future<ShippingAddressModel> addAddress(ShippingAddressModel address) async {
    try {
      AppLoggerHelper.debug('Adding new address for user: ${address.userId}');

      final token = StorageService.token;
      final refreshToken = StorageService.refreshToken;

      // Convert address type to backend format
      String addressTypeValue;
      switch (address.type) {
        case AddressType.home:
          addressTypeValue = 'HOME';
          break;
        case AddressType.office:
          addressTypeValue = 'OFFICE';
          break;
        case AddressType.other:
          addressTypeValue = 'OTHERS';
          break;
      }

      // Prepare request body
      final Map<String, dynamic> body = {
        'full_name': address.name,
        'address_line1': address.address,
        'city': address.city,
        'state': address.state,
        'country': address.country,
        'postal_code': address.zipCode,
        'phone_number': address.phoneNumber,
        'email': address.email ?? '',
        'addressType': addressTypeValue,
        'make_default': address.isDefault,
      };

      // Add optional fields only if they have values
      if (address.landmark != null && address.landmark!.isNotEmpty) {
        body['address_line2'] = address.landmark;
      }

      if (address.email != null && address.email!.isNotEmpty) {
        body['email'] = address.email;
      }

      AppLoggerHelper.debug('Using token: $token');
      AppLoggerHelper.debug('Using refresh token: $refreshToken');
      AppLoggerHelper.debug('Request body for adding address: $body');

      final ResponseData response = await _networkCaller.postRequest(
        ApiConstants.shippingAddresses,
        body: body,
        headers: {
          'Authorization': 'Bearer $token',
          'refresh-token': '$refreshToken',
        },
      );

      AppLoggerHelper.debug(
        'Add address response status: ${response.statusCode}',
      );
      AppLoggerHelper.debug(
        'Add address response data: ${response.responseData}',
      );

      if (response.isSuccess && response.responseData != null) {
        AppLoggerHelper.debug('Address added successfully');

        // Parse the response to get the newly created address
        final addressData = response.responseData as Map<String, dynamic>;
        final newAddress = ShippingAddressModel.fromJson(addressData);

        return newAddress;
      }

      AppLoggerHelper.warning(
        'Failed to add address: ${response.errorMessage}',
      );
      throw Exception('Failed to add address');
    } catch (e) {
      AppLoggerHelper.error('❌ Error adding address', e);
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
      final token = StorageService.token;
      final refreshToken = StorageService.refreshToken;
      final url = ApiConstants.deleteAddress.replaceAll(
        '{address_id}',
        addressId,
      );

      final ResponseData response = await _networkCaller.deleteRequest(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'refresh-token': '$refreshToken',
        },
      );

      if (response.statusCode == 204) {
        AppLoggerHelper.debug('Address deleted successfully');

        return true;
      }

      throw Exception('Failed to delete address');
    } catch (e) {
      throw Exception('Failed to delete address: $e');
    }
  }

  Future<bool> setDefaultAddress(String addressId) async {
    try {
      AppLoggerHelper.debug('Setting address as default: $addressId');

      final token = StorageService.token;
      final refreshToken = StorageService.refreshToken;

      final url = ApiConstants.makeDefault.replaceAll(
        '{address_id}',
        addressId,
      );

      AppLoggerHelper.debug('PUT $url');

      final ResponseData response = await _networkCaller.postRequest(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'refresh-token': '$refreshToken',
        },
      );

      if (response.isSuccess) {
        AppLoggerHelper.debug('Address set as default successfully');
        return true;
      }

      AppLoggerHelper.warning(
        'Failed to set default address: ${response.errorMessage}',
      );
      throw Exception('Failed to set default address');
    } catch (e) {
      AppLoggerHelper.error('❌ Error setting default address', e);
      throw Exception('Failed to set default address: $e');
    }
  }

  // Map<String, String?> validateAddress({
  //   required String name,
  //   required String address,
  //   required String city,
  //   required String zipCode,
  //   required String phoneNumber,
  //   String? country,
  //   String? state,
  // }) {
  //   final errors = <String, String?>{};
  //   if (name.trim().isEmpty) {
  //     errors['name'] = 'Full name is required';
  //   } else if (name.trim().length < 2) {
  //     errors['name'] = 'Name must be at least 2 characters';
  //   }
  //   if (address.trim().isEmpty) {
  //     errors['address'] = 'Address is required';
  //   } else if (address.trim().length < 5) {
  //     errors['address'] = 'Address must be at least 5 characters';
  //   }
  //   if (city.trim().isEmpty) {
  //     errors['city'] = 'City is required';
  //   }
  //   if (zipCode.trim().isEmpty) {
  //     errors['zipCode'] = 'PIN code is required';
  //   } else if (!RegExp(r'^\d{6}$').hasMatch(zipCode.trim())) {
  //     errors['zipCode'] = 'Invalid PIN code format';
  //   }
  //   if (phoneNumber.trim().isEmpty) {
  //     errors['phoneNumber'] = 'Phone number is required';
  //   } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phoneNumber.trim())) {
  //     errors['phoneNumber'] = 'Invalid Indian mobile number';
  //   }

  //   return errors;
  // }

  List<String> getCountries() {
    return ['India'];
  }

  List<String> getStatesForCountry(String country) {
    if (country != 'India') return ['State/Union Territory'];
    return [
      'Andhra Pradesh',
      'Arunachal Pradesh',
      'Assam',
      'Bihar',
      'Chhattisgarh',
      'Goa',
      'Gujarat',
      'Haryana',
      'Himachal Pradesh',
      'Jharkhand',
      'Karnataka',
      'Kerala',
      'Madhya Pradesh',
      'Maharashtra',
      'Manipur',
      'Meghalaya',
      'Mizoram',
      'Nagaland',
      'Odisha',
      'Punjab',
      'Rajasthan',
      'Sikkim',
      'Tamil Nadu',
      'Telangana',
      'Tripura',
      'Uttar Pradesh',
      'Uttarakhand',
      'West Bengal',
    ];
  }

  List<String> getCitiesForState(String state) {
    switch (state) {
      case 'Andhra Pradesh':
        return ['Visakhapatnam', 'Vijayawada', 'Guntur', 'Nellore', 'Tirupati'];
      case 'Arunachal Pradesh':
        return ['Itanagar', 'Tawang', 'Pasighat', 'Ziro', 'Bomdila'];
      case 'Assam':
        return ['Guwahati', 'Dibrugarh', 'Silchar', 'Tezpur', 'Jorhat'];
      case 'Bihar':
        return ['Patna', 'Gaya', 'Bhagalpur', 'Muzaffarpur', 'Munger'];
      case 'Chhattisgarh':
        return ['Raipur', 'Bilaspur', 'Korba', 'Durg', 'Rajnandgaon'];
      case 'Goa':
        return ['Panaji', 'Vasco da Gama', 'Margao', 'Mapusa', 'Ponda'];
      case 'Gujarat':
        return ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot', 'Gandhinagar'];
      case 'Haryana':
        return ['Chandigarh', 'Faridabad', 'Gurugram', 'Ambala', 'Panipat'];
      case 'Himachal Pradesh':
        return ['Shimla', 'Dharamshala', 'Kullu', 'Manali', 'Solan'];
      case 'Jharkhand':
        return ['Ranchi', 'Jamshedpur', 'Dhanbad', 'Bokaro', 'Deoghar'];
      case 'Karnataka':
        return ['Bengaluru', 'Mysuru', 'Mangaluru', 'Hubballi', 'Belagavi'];
      case 'Kerala':
        return [
          'Thiruvananthapuram',
          'Kochi',
          'Kozhikode',
          'Thrissur',
          'Malappuram',
        ];
      case 'Madhya Pradesh':
        return ['Bhopal', 'Indore', 'Gwalior', 'Jabalpur', 'Ujjain'];
      case 'Maharashtra':
        return ['Mumbai', 'Pune', 'Nagpur', 'Nashik', 'Aurangabad'];
      case 'Manipur':
        return ['Imphal', 'Churachandpur', 'Thoubal', 'Bishnupur', 'Senapati'];
      case 'Meghalaya':
        return ['Shillong', 'Tura', 'Jowai', 'Nongpoh', 'Williamnagar'];
      case 'Mizoram':
        return ['Aizawl', 'Lunglei', 'Champhai', 'Serchhip', 'Mamit'];
      case 'Nagaland':
        return ['Kohima', 'Dimapur', 'Mokokchung', 'Zunheboto', 'Mon'];
      case 'Odisha':
        return ['Bhubaneswar', 'Cuttack', 'Rourkela', 'Berhampur', 'Sambalpur'];
      case 'Punjab':
        return ['Chandigarh', 'Amritsar', 'Jalandhar', 'Ludhiana', 'Patiala'];
      case 'Rajasthan':
        return ['Jaipur', 'Udaipur', 'Jodhpur', 'Kota', 'Ajmer'];
      case 'Sikkim':
        return ['Gangtok', 'Namchi', 'Mangan', 'Rangpo', 'Jorethang'];
      case 'Tamil Nadu':
        return ['Chennai', 'Coimbatore', 'Madurai', 'Tiruchirappalli', 'Salem'];
      case 'Telangana':
        return ['Hyderabad', 'Warangal', 'Khammam', 'Karimnagar', 'Nizamabad'];
      case 'Tripura':
        return ['Agartala', 'Udaipur', 'Dharmanagar', 'Ambassa', 'Kailashahar'];
      case 'Uttar Pradesh':
        return ['Lucknow', 'Kanpur', 'Varanasi', 'Agra', 'Meerut'];
      case 'Uttarakhand':
        return ['Dehradun', 'Haridwar', 'Nainital', 'Rishikesh', 'Roorkee'];
      case 'West Bengal':
        return ['Kolkata', 'Siliguri', 'Durgapur', 'Asansol', 'Howrah'];
      default:
        return ['City'];
    }
  }
}
