class UserModel {
  final String? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? avatar;
  final String? address;
  final String? dateOfBirth;
  final bool? isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.avatar,
    this.address,
    this.dateOfBirth,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor for creating a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      avatar: json['avatar']?.toString(),
      address: json['address']?.toString(),
      dateOfBirth: json['date_of_birth']?.toString(),
      isVerified: json['is_verified'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'avatar': avatar,
      'address': address,
      'date_of_birth': dateOfBirth,
      'is_verified': isVerified,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // CopyWith method for creating a copy with updated fields
  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? avatar,
    String? address,
    String? dateOfBirth,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, phone: $phone, email: $email, isVerified: $isVerified)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.email == email &&
        other.avatar == avatar &&
        other.address == address &&
        other.dateOfBirth == dateOfBirth &&
        other.isVerified == isVerified;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        avatar.hashCode ^
        address.hashCode ^
        dateOfBirth.hashCode ^
        isVerified.hashCode;
  }
}
