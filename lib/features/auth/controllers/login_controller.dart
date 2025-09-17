import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/auth/data/services/auth_service.dart';
import 'package:quikle_user/routes/app_routes.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final showNameField = false.obs;
  final isExistingUser = true.obs;

  late final AuthService _auth;

  @override
  void onInit() {
    super.onInit();
    _auth = Get.find<AuthService>();
  }

  Future<void> onTapContinue() async {
    if (_validateInputs()) {
      isLoading.value = true;
      errorMessage.value = '';

      try {
        final response = await _auth.sendOtp(
          phoneController.text.trim(),
          name: showNameField.value ? nameController.text.trim() : null,
        );

        if (response.isSuccess) {
          final userExists = response.responseData?['userExists'] ?? true;

          if (!userExists && !showNameField.value) {
            showNameField.value = true;
            isExistingUser.value = false;
            isLoading.value = false;
            return;
          }

          // Proceed to verification
          Get.toNamed(
            AppRoute.getVerify(),
            arguments: {
              'phone': phoneController.text.trim(),
              'name': showNameField.value ? nameController.text.trim() : null,
              'isLogin': userExists,
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
    final phone = phoneController.text.trim();

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

    if (showNameField.value) {
      final name = nameController.text.trim();
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
    }

    return true;
  }

  // Legacy methods for backward compatibility
  Future<void> onTapLogin() async => onTapContinue();
  void onTapCreateAccount() => onTapContinue();

  @override
  void onClose() {
    phoneController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
