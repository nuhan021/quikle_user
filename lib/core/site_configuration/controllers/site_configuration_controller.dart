import 'package:get/get.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/site_configuration/services/site_configuration_service.dart';

class SiteConfigurationController extends GetxController {
  SiteConfigurationController({
    SiteConfigurationService? service,
    bool autoLoadOnInit = true,
  }) : _service = service ?? Get.find<SiteConfigurationService>(),
       _autoLoadOnInit = autoLoadOnInit;

  final SiteConfigurationService _service;
  final bool _autoLoadOnInit;

  final RxBool isServiceAvailable = true.obs;
  final RxBool hasLoadedConfiguration = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (_autoLoadOnInit && StorageService.hasToken()) {
      refreshConfiguration();
    }
  }

  Future<void> refreshConfiguration() async {
    if (!StorageService.hasToken()) {
      return;
    }

    final configuration = await _service.fetchConfiguration();
    if (configuration == null) {
      return;
    }

    isServiceAvailable.value = configuration.serviceAvailable;
    hasLoadedConfiguration.value = true;
  }

  void reset() {
    isServiceAvailable.value = true;
    hasLoadedConfiguration.value = false;
  }
}
