class SiteConfigurationModel {
  const SiteConfigurationModel({required this.serviceAvailable});

  final bool serviceAvailable;

  factory SiteConfigurationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final miscSettings = data is Map<String, dynamic>
        ? data['misc_settings']
        : null;
    final serviceAvailable = miscSettings is Map<String, dynamic>
        ? miscSettings['service_available']
        : null;

    return SiteConfigurationModel(
      serviceAvailable: serviceAvailable is bool ? serviceAvailable : true,
    );
  }
}
