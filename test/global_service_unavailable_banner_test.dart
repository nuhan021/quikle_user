import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/site_configuration/controllers/site_configuration_controller.dart';
import 'package:quikle_user/core/site_configuration/services/site_configuration_service.dart';
import 'package:quikle_user/core/site_configuration/widgets/global_service_unavailable_banner.dart';

class FakeSiteConfigurationService extends SiteConfigurationService {
  FakeSiteConfigurationService();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  tearDown(Get.reset);

  testWidgets('shows the global banner when service is unavailable', (
    tester,
  ) async {
    final controller = SiteConfigurationController(
      service: FakeSiteConfigurationService(),
      autoLoadOnInit: false,
    );
    controller.isServiceAvailable.value = false;

    await tester.pumpWidget(
      GetMaterialApp(
        home: Column(
          children: [
            const Expanded(child: SizedBox()),
            GlobalServiceUnavailableBanner(controller: controller),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Service unavailable'), findsOneWidget);
  });

  testWidgets('hides the global banner when service is available', (
    tester,
  ) async {
    final controller = SiteConfigurationController(
      service: FakeSiteConfigurationService(),
      autoLoadOnInit: false,
    );

    await tester.pumpWidget(
      GetMaterialApp(
        home: Column(
          children: [
            const Expanded(child: SizedBox()),
            GlobalServiceUnavailableBanner(controller: controller),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Service unavailable'), findsNothing);
  });

  testWidgets('banner remains visible while navigating between routes', (
    tester,
  ) async {
    final controller = SiteConfigurationController(
      service: FakeSiteConfigurationService(),
      autoLoadOnInit: false,
    );
    controller.isServiceAvailable.value = false;

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/first',
        getPages: [
          GetPage(
            name: '/first',
            page: () => const Scaffold(body: Text('first')),
          ),
          GetPage(
            name: '/second',
            page: () => const Scaffold(body: Text('second')),
          ),
        ],
        builder: (context, child) {
          return Column(
            children: [
              Expanded(child: child ?? const SizedBox.shrink()),
              GlobalServiceUnavailableBanner(controller: controller),
            ],
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Service unavailable'), findsOneWidget);
    expect(find.text('first'), findsOneWidget);

    Get.toNamed('/second');
    await tester.pumpAndSettle();

    expect(find.text('second'), findsOneWidget);
    expect(find.text('Service unavailable'), findsOneWidget);
  });
}
