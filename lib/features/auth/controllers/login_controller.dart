import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/auth/data/services/auth_service.dart';
import 'package:quikle_user/routes/app_routes.dart';

class LoginController extends GetxController {
  LoginController() {
    debugPrint('LoginController constructor called');
  }
  final phoneController = TextEditingController();
  final isLoading = false.obs;

  //late final AuthService _auth;

  @override
  void onInit() {
    super.onInit();
    debugPrint('LoginController onInit called');
    //_auth = Get.find<AuthService>();
  }

  Future<void> onTapLogin() async {
    isLoading.value = true;
    try {
      // await _auth.login(phoneController.text);
      await Future<void>.delayed(const Duration(milliseconds: 350));
      Get.toNamed(
        AppRoute.getVerify(),
        arguments: {'phone': phoneController.text.trim()},
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onTapCreateAccount() {
    Get.toNamed(AppRoute.getHome());
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
