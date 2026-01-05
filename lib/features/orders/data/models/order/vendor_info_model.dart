class VendorInfo {
  final bool? isActive;
  final bool? isVendor;
  final int? vendorId;
  final String? kycStatus;
  final String? storeName;
  final String? storeType;
  final String? vendorName;
  final String? vendorEmail;
  final String? vendorPhone;
  final double? storeLatitude;
  final double? storeLongitude;
  final bool? profileIsActive;

  const VendorInfo({
    this.isActive,
    this.isVendor,
    this.vendorId,
    this.kycStatus,
    this.storeName,
    this.storeType,
    this.vendorName,
    this.vendorEmail,
    this.vendorPhone,
    this.storeLatitude,
    this.storeLongitude,
    this.profileIsActive,
  });

  VendorInfo copyWith({
    bool? isActive,
    bool? isVendor,
    int? vendorId,
    String? kycStatus,
    String? storeName,
    String? storeType,
    String? vendorName,
    String? vendorEmail,
    String? vendorPhone,
    double? storeLatitude,
    double? storeLongitude,
    bool? profileIsActive,
  }) {
    return VendorInfo(
      isActive: isActive ?? this.isActive,
      isVendor: isVendor ?? this.isVendor,
      vendorId: vendorId ?? this.vendorId,
      kycStatus: kycStatus ?? this.kycStatus,
      storeName: storeName ?? this.storeName,
      storeType: storeType ?? this.storeType,
      vendorName: vendorName ?? this.vendorName,
      vendorEmail: vendorEmail ?? this.vendorEmail,
      vendorPhone: vendorPhone ?? this.vendorPhone,
      storeLatitude: storeLatitude ?? this.storeLatitude,
      storeLongitude: storeLongitude ?? this.storeLongitude,
      profileIsActive: profileIsActive ?? this.profileIsActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_active': isActive,
      'is_vendor': isVendor,
      'vendor_id': vendorId,
      'kyc_status': kycStatus,
      'store_name': storeName,
      'store_type': storeType,
      'vendor_name': vendorName,
      'vendor_email': vendorEmail,
      'vendor_phone': vendorPhone,
      'store_latitude': storeLatitude,
      'store_longitude': storeLongitude,
      'profile_is_active': profileIsActive,
    };
  }

  factory VendorInfo.fromJson(Map<String, dynamic> json) {
    double? toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    return VendorInfo(
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool?,
      isVendor: json['is_vendor'] as bool? ?? json['isVendor'] as bool?,
      vendorId: json['vendor_id'] is int
          ? json['vendor_id'] as int
          : (json['vendor_id'] != null
                ? int.tryParse(json['vendor_id'].toString())
                : null),
      kycStatus: json['kyc_status'] as String? ?? json['kycStatus'] as String?,
      storeName: json['store_name'] as String? ?? json['storeName'] as String?,
      storeType: json['store_type'] as String? ?? json['storeType'] as String?,
      vendorName:
          json['vendor_name'] as String? ?? json['vendorName'] as String?,
      vendorEmail:
          json['vendor_email'] as String? ?? json['vendorEmail'] as String?,
      vendorPhone:
          json['vendor_phone'] as String? ?? json['vendorPhone'] as String?,
      storeLatitude: toDouble(json['store_latitude'] ?? json['storeLatitude']),
      storeLongitude: toDouble(
        json['store_longitude'] ?? json['storeLongitude'],
      ),
      profileIsActive:
          json['profile_is_active'] as bool? ??
          json['profileIsActive'] as bool?,
    );
  }
}
