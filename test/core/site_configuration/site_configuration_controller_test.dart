import 'package:flutter_test/flutter_test.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/site_configuration/controllers/site_configuration_controller.dart';
import 'package:quikle_user/core/site_configuration/models/site_configuration_model.dart';
import 'package:quikle_user/core/site_configuration/services/site_configuration_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeSiteConfigurationService extends SiteConfigurationService {
  FakeSiteConfigurationService(this.result);

  final SiteConfigurationModel? result;
  int fetchCallCount = 0;

  @override
  Future<SiteConfigurationModel?> fetchConfiguration() async {
    fetchCallCount++;
    return result;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
  });

  group('SiteConfigurationController', () {
    test('startup with token triggers fetch', () async {
      await StorageService.saveToken('token');
      final service = FakeSiteConfigurationService(
        const SiteConfigurationModel(serviceAvailable: false),
      );
      final controller = SiteConfigurationController(service: service);

      controller.onInit();
      await Future<void>.delayed(Duration.zero);

      expect(service.fetchCallCount, 1);
      expect(controller.isServiceAvailable.value, isFalse);
      expect(controller.hasLoadedConfiguration.value, isTrue);
    });

    test('startup without token skips fetch', () async {
      final service = FakeSiteConfigurationService(
        const SiteConfigurationModel(serviceAvailable: false),
      );
      final controller = SiteConfigurationController(service: service);

      controller.onInit();
      await Future<void>.delayed(Duration.zero);

      expect(service.fetchCallCount, 0);
      expect(controller.isServiceAvailable.value, isTrue);
      expect(controller.hasLoadedConfiguration.value, isFalse);
    });

    test('successful refresh updates service availability', () async {
      await StorageService.saveToken('token');
      final service = FakeSiteConfigurationService(
        const SiteConfigurationModel(serviceAvailable: false),
      );
      final controller = SiteConfigurationController(
        service: service,
        autoLoadOnInit: false,
      );

      await controller.refreshConfiguration();

      expect(service.fetchCallCount, 1);
      expect(controller.isServiceAvailable.value, isFalse);
      expect(controller.hasLoadedConfiguration.value, isTrue);
    });

    test('failed refresh preserves the previous state', () async {
      await StorageService.saveToken('token');
      final service = FakeSiteConfigurationService(null);
      final controller = SiteConfigurationController(
        service: service,
        autoLoadOnInit: false,
      );

      controller.isServiceAvailable.value = false;
      controller.hasLoadedConfiguration.value = true;

      await controller.refreshConfiguration();

      expect(service.fetchCallCount, 1);
      expect(controller.isServiceAvailable.value, isFalse);
      expect(controller.hasLoadedConfiguration.value, isTrue);
    });

    test('reset clears stale unavailable state', () {
      final service = FakeSiteConfigurationService(null);
      final controller = SiteConfigurationController(
        service: service,
        autoLoadOnInit: false,
      );

      controller.isServiceAvailable.value = false;
      controller.hasLoadedConfiguration.value = true;

      controller.reset();

      expect(controller.isServiceAvailable.value, isTrue);
      expect(controller.hasLoadedConfiguration.value, isFalse);
    });
  });
}
