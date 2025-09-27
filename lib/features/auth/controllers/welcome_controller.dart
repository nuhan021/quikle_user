// import 'dart:async';
// import 'package:get/get.dart';
// import 'package:quikle_user/routes/app_routes.dart';

// class WelcomeController extends GetxController {
//   final int delayMs = 200;
//   Timer? _timer;

//   @override
//   void onInit() {
//     super.onInit();
//     _timer = Timer(Duration(milliseconds: delayMs), () {
//       Get.offAllNamed(AppRoute.getHome());
//     });
//   }

//   @override
//   void onClose() {
//     _timer?.cancel();
//     super.onClose();
//   }
// }

import 'package:get/get.dart';
import 'package:quikle_user/routes/app_routes.dart';

class WelcomeController extends GetxController {
  void goToHome() {
    Get.offAllNamed(AppRoute.getHome());
  }
}
