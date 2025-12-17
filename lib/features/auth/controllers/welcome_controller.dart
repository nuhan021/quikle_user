import 'package:get/get.dart';
import 'package:quikle_user/routes/app_routes.dart';

class WelcomeController extends GetxController {
  void goToHome() {
    Get.offAllNamed(AppRoute.getHome());
  }
}
