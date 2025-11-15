import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
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
    // Clear name field visibility when phone changes so server check is fresh.
    phoneController.addListener(() {
      // If user edits phone after previously showing name field, hide it and reset existing flag
      if (showNameField.value || !isExistingUser.value) {
        showNameField.value = false;
        isExistingUser.value = true;
        nameController.text = '';
      }
    });
  }

  Future<void> onTapContinue() async {
    if (_validateInputs()) {
      isLoading.value = true;
      errorMessage.value = '';

      try {
        final phoneTrim = phoneController.text.trim();
        final nameTrim = nameController.text.trim();

        // Determine the purpose based on whether we're showing the name field
        final purpose = showNameField.value ? 'signup' : 'login';

        // Send OTP to server with appropriate purpose
        final response = await _auth.sendOtp(
          phoneTrim,
          name: showNameField.value ? nameTrim : null,
          purpose: purpose,
        );

        // Handle success response (200)
        if (response.statusCode == 200 && response.isSuccess) {
          final userExists = !showNameField.value;

          Get.toNamed(
            AppRoute.getVerify(),
            arguments: {
              'phone': phoneTrim,
              'name': showNameField.value ? nameTrim : null,
              'isLogin': userExists,
            },
          );
          isLoading.value = false;
          return;
        }

        // Handle user not found (400) - show name field for signup
        if (response.statusCode == 400 && !showNameField.value) {
          // User doesn't exist, show name field for registration
          clearInputs();
          showNameField.value = true;
          isExistingUser.value = false;
          isLoading.value = false;

          Get.snackbar(
            'Account Not Found',
            'Please enter your name to create a new account',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange.withValues(alpha: 0.1),
            colorText: Colors.orange,
          );
          return;
        }

        // Handle other errors
        errorMessage.value = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Something went wrong. Please try again.';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
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

  void clearInputs() {
    nameController.text = '';
  }

  void clearPhone() {
    phoneController.text = '';
  }

  //Log out
  Future<void> logout() async {
    await _auth.logout();
    Get.offAllNamed(AppRoute.getLoginScreen());
  }

  @override
  void onClose() {
    phoneController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
