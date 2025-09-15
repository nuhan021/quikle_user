import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/auth/data/services/auth_service.dart';
import 'package:quikle_user/routes/app_routes.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  late final AuthService _auth;

  @override
  void onInit() {
    super.onInit();
    _auth = Get.find<AuthService>();
  }

  Future<void> onTapCreateAccount() async {
    if (_validateInputs()) {
      isLoading.value = true;
      errorMessage.value = '';

      try {
        final response = await _auth.register(
          nameController.text.trim(),
          phoneController.text.trim(),
        );

        if (response.isSuccess) {
          Get.toNamed(
            AppRoute.getVerify(),
            arguments: {
              'phone': phoneController.text.trim(),
              'name': nameController.text.trim(),
              'isLogin': false,
            },
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

  bool _validateInputs() {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty) {
      errorMessage.value = 'Please enter your full name';
      Get.snackbar(
        'Validation Error',
        'Please enter your full name',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.withValues(alpha: 0.1),
        colorText: Colors.orange,
      );
      return false;
    }

    if (name.length < 2) {
      errorMessage.value = 'Name must be at least 2 characters long';
      Get.snackbar(
        'Validation Error',
        'Name must be at least 2 characters long',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.withValues(alpha: 0.1),
        colorText: Colors.orange,
      );
      return false;
    }

    if (phone.isEmpty) {
      errorMessage.value = 'Please enter your phone number';
      Get.snackbar(
        'Validation Error',
        'Please enter your phone number',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.withValues(alpha: 0.1),
        colorText: Colors.orange,
      );
      return false;
    }

    
    
    
    
    
    
    
    
    
    
    

    return true;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
