import 'package:get/get.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/core/notification/controllers/notification_controller.dart';
import 'package:quikle_user/core/notification/services/notification_service.dart';
import 'package:quikle_user/core/services/cart_position_service.dart';
import 'package:quikle_user/features/profile/controllers/add_address_controller.dart';
import 'package:quikle_user/features/user/data/services/user_service.dart';
import 'package:quikle_user/features/user/controllers/user_controller.dart';
import 'package:quikle_user/features/auth/controllers/login_controller.dart';
import 'package:quikle_user/features/auth/controllers/verification_controller.dart';
import 'package:quikle_user/features/auth/controllers/welcome_controller.dart';
import 'package:quikle_user/features/auth/data/services/auth_service.dart';
import 'package:quikle_user/features/home/controllers/home_controller.dart';
import 'package:quikle_user/features/product/controllers/product_controller.dart';
import 'package:quikle_user/features/profile/controllers/favorites_controller.dart';
import 'package:quikle_user/features/profile/controllers/address_controller.dart';
import 'package:quikle_user/features/profile/controllers/payment_method_controller.dart';
import 'package:quikle_user/features/profile/controllers/help_support_controller.dart';
import 'package:quikle_user/features/profile/data/services/address_service.dart';
import 'package:quikle_user/features/profile/data/services/help_support_service.dart';
import 'package:quikle_user/features/splash/controllers/splash_controller.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/orders/controllers/live_order_controller.dart';
import 'package:quikle_user/features/prescription/controllers/prescription_controller.dart';
import 'package:quikle_user/core/services/prescription_notification_service.dart';

import '../services/network_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    // Services

    Get.put(NetworkController(), permanent: true);
    Get.put<UserService>(UserService(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<AddressService>(AddressService(), permanent: true);
    Get.put<HelpSupportService>(HelpSupportService(), permanent: true);
    Get.put<PrescriptionNotificationService>(
      PrescriptionNotificationService(),
      permanent: true,
    );
    Get.put<UserController>(UserController(), permanent: true);

    // Controllers
    Get.put<SplashController>(SplashController(), permanent: true);
    Get.put<LoginController>(LoginController(), permanent: true);
    Get.put<VerificationController>(VerificationController(), permanent: true);
    Get.lazyPut<WelcomeController>(() => WelcomeController(), fenix: true);
    Get.put<CartController>(CartController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<ProductController>(ProductController(), permanent: true);
    Get.put<CartAnimationController>(
      CartAnimationController(),
      permanent: true,
    );
    Get.put<CartPositionService>(CartPositionService(), permanent: true);
    Get.put<FavoritesController>(FavoritesController(), permanent: true);
    Get.put<AddressController>(AddressController(), permanent: true);
    Get.put<AddAddressController>(AddAddressController(), permanent: true);
    Get.put<PaymentMethodController>(
      PaymentMethodController(),
      permanent: true,
    );
    Get.put<HelpSupportController>(HelpSupportController(), permanent: true);
    Get.put<LiveOrderController>(LiveOrderController(), permanent: true);
    Get.put<PrescriptionController>(PrescriptionController(), permanent: true);

    //NotificationController
    Get.put<NotificationService>(NotificationService(), permanent: true);
    Get.put<NotificationController>(NotificationController(), permanent: true);
  }
}
