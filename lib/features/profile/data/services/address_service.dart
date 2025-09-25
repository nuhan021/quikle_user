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
          name: 'Amit Sharma',
          address: '221B MG Road',
          city: 'Bengaluru',
          state: 'Karnataka',
          zipCode: '560001',
          phoneNumber: '+91 9876543210',
          type: AddressType.home,
          isDefault: true,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        ShippingAddressModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + '1',
          userId: userId,
          name: 'Priya Verma',
          address: '14 Connaught Place',
          city: 'New Delhi',
          state: 'Delhi',
          zipCode: '110001',
          phoneNumber: '+91 9123456789',
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
