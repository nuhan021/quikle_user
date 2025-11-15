class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? address1;
  final String? address2;
  final String? postalCode;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.address1,
    this.address2,
    this.postalCode,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id'].toString(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      address1: json['address_1'] as String?,
      address2: json['address_2'] as String?,
      postalCode: json['postal_code'] as String?,
    );
  }
}
