import 'dart:async';
import 'package:get/get.dart';
import 'package:quikle_user/routes/app_routes.dart';

class WelcomeController extends GetxController {
  final int delayMs = 1200; // adjust to your taste (e.g., 1500–1800 for slower)

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _timer = Timer(Duration(milliseconds: delayMs), () {
      Get.offAllNamed(AppRoute.getHome());
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
