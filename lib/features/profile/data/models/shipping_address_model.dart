import '../../../../core/utils/constants/enums/order_enums.dart';

class ShippingAddressModel {
  final String id;
  final String userId;
  final String name;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String? landmark;
  final String phoneNumber;
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
    required this.zipCode,
    this.landmark,
    required this.phoneNumber,
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
    String? zipCode,
    String? landmark,
    String? phoneNumber,
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
      zipCode: zipCode ?? this.zipCode,
      landmark: landmark ?? this.landmark,
      phoneNumber: phoneNumber ?? this.phoneNumber,
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
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'landmark': landmark,
      'phoneNumber': phoneNumber,
      'type': type.name,
      'isDefault': isDefault,
      'isSelected': isSelected,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      landmark: json['landmark'] as String?,
      phoneNumber: json['phoneNumber'] as String,
      type: AddressType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AddressType.home,
      ),
      isDefault: json['isDefault'] as bool? ?? false,
      isSelected: json['isSelected'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }
}
