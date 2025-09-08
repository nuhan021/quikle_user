import 'package:get/get.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/core/services/user_service.dart';
import 'package:quikle_user/features/auth/controllers/login_controller.dart';
import 'package:quikle_user/features/auth/controllers/register_controller.dart';
import 'package:quikle_user/features/auth/controllers/verification_controller.dart';
import 'package:quikle_user/features/auth/controllers/welcome_controller.dart';
import 'package:quikle_user/features/auth/data/services/auth_service.dart';
import 'package:quikle_user/features/home/controllers/home_controller.dart';
import 'package:quikle_user/features/product/controllers/product_controller.dart';
import 'package:quikle_user/features/splash/controllers/splash_controller.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put<UserService>(UserService(), permanent: true);
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);

    // Controllers
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.put<LoginController>(LoginController(), permanent: true);
    Get.put<RegisterController>(RegisterController(), permanent: true);
    Get.lazyPut<VerificationController>(
      () => VerificationController(),
      fenix: true,
    );
    Get.lazyPut<WelcomeController>(() => WelcomeController(), fenix: true);
    Get.put<CartController>(CartController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
    // Cart Controller - permanent for persistent cart

    Get.put<ProductController>(ProductController(), permanent: true);

    // Cart Animation Controller - permanent for animations
    Get.put<CartAnimationController>(
      CartAnimationController(),
      permanent: true,
    );
  }
}
