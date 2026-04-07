import 'package:flutter_test/flutter_test.dart';
import 'package:quikle_user/core/site_configuration/models/site_configuration_model.dart';

void main() {
  group('SiteConfigurationModel', () {
    test('maps service_available false correctly', () {
      final model = SiteConfigurationModel.fromJson({
        'data': {
          'misc_settings': {'service_available': false},
        },
      });

      expect(model.serviceAvailable, isFalse);
    });

    test('falls back to true for missing or malformed values', () {
      final missingValueModel = SiteConfigurationModel.fromJson({
        'data': {'misc_settings': {}},
      });

      final malformedValueModel = SiteConfigurationModel.fromJson({
        'data': {
          'misc_settings': {'service_available': 'nope'},
        },
      });

      expect(missingValueModel.serviceAvailable, isTrue);
      expect(malformedValueModel.serviceAvailable, isTrue);
    });
  });
}
