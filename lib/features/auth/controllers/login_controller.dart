import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/auth/data/services/auth_service.dart';
import 'package:quikle_user/routes/app_routes.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  late final AuthService _auth;

  @override
  void onInit() {
    super.onInit();
    _auth = Get.find<AuthService>();
  }

  Future<void> onTapLogin() async {
    if (_validatePhone()) {
      isLoading.value = true;
      errorMessage.value = '';

      try {
        final response = await _auth.login(phoneController.text.trim());

        if (response.isSuccess) {
          Get.toNamed(
            AppRoute.getVerify(),
            arguments: {'phone': phoneController.text.trim(), 'isLogin': true},
          );
        } else {
          errorMessage.value = response.errorMessage;
          Get.snackbar(
            'Error',
            response.errorMessage,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.withValues(alpha: 0.1),
            colorText: Colors.red,
          );
        }
      } catch (e) {
        errorMessage.value = 'Something went wrong. Please try again.';
        Get.snackbar(
          'Error',
          'Something went wrong. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  bool _validatePhone() {
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    

    return true;
  }

  void onTapCreateAccount() {
    Get.toNamed(AppRoute.getRegister());
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
