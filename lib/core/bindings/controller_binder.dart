import 'package:get/get.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/features/user/data/services/user_service.dart';
import 'package:quikle_user/features/user/controllers/user_controller.dart';
import 'package:quikle_user/features/auth/controllers/auth_controller.dart';
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
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);

    // Controllers
    Get.put<SplashController>(SplashController(), permanent: true);
    Get.put<LoginController>(LoginController(), permanent: true);
    Get.put<RegisterController>(RegisterController(), permanent: true);
    Get.put<VerificationController>(VerificationController(), permanent: true);
    Get.lazyPut<WelcomeController>(() => WelcomeController(), fenix: true);
    Get.put<CartController>(CartController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<ProductController>(ProductController(), permanent: true);
    Get.put<CartAnimationController>(
      CartAnimationController(),
      permanent: true,
    );
  }
}
