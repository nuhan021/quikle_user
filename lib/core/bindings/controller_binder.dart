import 'package:get/get.dart';
import 'package:quikle_user/features/splash/controllers/splash_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<LogInController>(
    //       () => LogInController(),
    //   fenix: true,
    // );
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    //Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
  }
}
