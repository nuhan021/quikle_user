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
        // Demo override: consider phone length 5-10 digits as existing user
        final phoneTrim = phoneController.text.trim();
        final digitOnly = phoneTrim.replaceAll(RegExp(r'\D'), '');
        // Demo rule: any phone with 5 or more digits treated as existing user
        final isDemoExisting = digitOnly.length >= 5;

        // Send OTP to server (pass name only if we're already showing it)
        final response = await _auth.sendOtp(
          phoneTrim,
          name: showNameField.value ? nameController.text.trim() : null,
        );

        // If server returned an error, show it and stop
        if (!response.isSuccess) {
          errorMessage.value = response.errorMessage;
          Get.snackbar(
            'Error',
            response.errorMessage,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.withValues(alpha: 0.1),
            colorText: Colors.red,
          );
          isLoading.value = false;
          return;
        }

        // decide user existence: prefer server response if provided, otherwise apply demo rule
        bool userExists = isDemoExisting;
        debugPrint('Phone number: $phoneTrim');
        debugPrint('LoginController: isDemoExisting=$userExists');

        // try {
        //   if (response.responseData != null &&
        //       response.responseData!['userExists'] != null) {
        //     userExists = response.responseData?['userExists'] ?? isDemoExisting;
        //   }
        // } catch (_) {}

        debugPrint('LoginController: isDemoExisting=$userExists');

        // If server (or demo rule) says user does not exist, show name field for registration.
        if (!userExists && !showNameField.value) {
          clearInputs();
          showNameField.value = true;
          isExistingUser.value = false;
          isLoading.value = false;
          return;
        }

        // Proceed: hide name field for login flow and navigate to verification
        showNameField.value = false;
        isExistingUser.value = true;
        Get.toNamed(
          AppRoute.getVerify(),

          arguments: {
            'phone': phoneTrim,
            'name': showNameField.value ? nameController.text.trim() : null,
            'isLogin': userExists,
          },
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

  @override
  void onClose() {
    phoneController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
