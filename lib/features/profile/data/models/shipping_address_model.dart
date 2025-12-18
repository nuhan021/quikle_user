import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';

class ShippingAddressModel {
  final String id;
  final String userId;
  final String name;
  final String address;
  final String city;
  final String state;
  final String country;
  final String zipCode;
  final String? landmark;
  final String? flatHouseBuilding;
  final String? floorNumber;
  final String phoneNumber;
  final String? email;
  final AddressType type;
  final bool isDefault;
  final bool isSelected;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ShippingAddressModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    this.country = 'India',
    required this.zipCode,
    this.landmark,
    this.flatHouseBuilding,
    this.floorNumber,
    required this.phoneNumber,
    this.email,
    required this.type,
    this.isDefault = false,
    this.isSelected = false,
    required this.createdAt,
    this.updatedAt,
  });

  ShippingAddressModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? address,
    String? city,
    String? state,
    String? country,
    String? zipCode,
    String? landmark,
    String? flatHouseBuilding,
    String? floorNumber,
    String? phoneNumber,
    String? email,
    AddressType? type,
    bool? isDefault,
    bool? isSelected,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShippingAddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
      landmark: landmark ?? this.landmark,
      flatHouseBuilding: flatHouseBuilding ?? this.flatHouseBuilding,
      floorNumber: floorNumber ?? this.floorNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
      isSelected: isSelected ?? this.isSelected,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get fullAddress {
    final parts = [address, city, state, zipCode];
    return parts.where((part) => part.isNotEmpty).join(', ');
  }

  String get typeDisplayName {
    switch (type) {
      case AddressType.home:
        return 'Home';
      case AddressType.office:
        return 'Office';
      case AddressType.other:
        return 'Other';
    }
  }

  Map<String, dynamic> toJson() {
    // Convert address type to backend format: 'HOME', 'Office', 'OTHERS'
    String addressTypeValue;
    switch (type) {
      case AddressType.home:
        addressTypeValue = 'HOME';
        break;
      case AddressType.office:
        addressTypeValue = 'Office';
        break;
      case AddressType.other:
        addressTypeValue = 'OTHERS';
        break;
    }

    return {
      'id': id,
      'full_name': name,
      'address_line1': address,
      'address_line2': landmark ?? '',
      'city': city,
      'state': state,
      'country': country,
      'postal_code': zipCode,
      'phone_number': phoneNumber,
      'email': email ?? '',
      'addressType': addressTypeValue,
      'flat_house_building': flatHouseBuilding ?? '',
      'floor_number': floorNumber ?? '',
      'nearby_landmark': landmark ?? '',
      'is_default': isDefault,
    };
  }

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    // Parse addressType from API response
    // Backend accepts: 'HOME', 'Office', 'OTHERS'
    String addressTypeString = (json['addressType'] as String? ?? 'HOME');
    AddressType addressType;

    if (addressTypeString.toUpperCase() == 'HOME') {
      addressType = AddressType.home;
    } else if (addressTypeString.toUpperCase() == 'OFFICE') {
      addressType = AddressType.office;
    } else {
      addressType = AddressType.other;
    }

    // Extract user ID from the id field (format: "userId_addr_timestamp")
    String userId = json['id']?.toString().split('_').first ?? '';

    return ShippingAddressModel(
      id: json['id'] as String,
      userId: userId,
      name: json['full_name'] as String,
      address: json['address_line1'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String? ?? 'India',
      zipCode: json['postal_code'] as String,
      landmark: json['nearby_landmark'] as String?,
      flatHouseBuilding: json['flat_house_building'] as String?,
      floorNumber: json['floor_number'] as String?,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String?,
      type: addressType,
      isDefault: json['is_default'] as bool? ?? false,
      isSelected: false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}
