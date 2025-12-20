class RiderInfo {
  final int? riderId;
  final String? riderName;
  final String? riderPhone;
  final String? riderImage;

  const RiderInfo({
    this.riderId,
    this.riderName,
    this.riderPhone,
    this.riderImage,
  });

  RiderInfo copyWith({
    int? riderId,
    String? riderName,
    String? riderPhone,
    String? riderImage,
  }) {
    return RiderInfo(
      riderId: riderId ?? this.riderId,
      riderName: riderName ?? this.riderName,
      riderPhone: riderPhone ?? this.riderPhone,
      riderImage: riderImage ?? this.riderImage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rider_id': riderId,
      'rider_name': riderName,
      'rider_phone': riderPhone,
      'rider_image': riderImage,
    };
  }

  factory RiderInfo.fromJson(Map<String, dynamic> json) {
    return RiderInfo(
      riderId: json['rider_id'] as int?,
      riderName: json['rider_name'] as String?,
      riderPhone: json['rider_phone'] as String?,
      riderImage: json['rider_image'] as String?,
    );
  }
}
