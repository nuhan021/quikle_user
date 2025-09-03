import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/auth/controllers/login_controller.dart';
import 'package:quikle_user/features/auth/controllers/verification_controller.dart';
import 'package:quikle_user/features/auth/data/services/auth_service.dart';
import 'package:quikle_user/features/splash/controllers/splash_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
    // Controllers
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.put<LoginController>(LoginController(), permanent: true);
    Get.lazyPut<VerificationController>(
      () => VerificationController(),
      fenix: true,
    );
  }
}
