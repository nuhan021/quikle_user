import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/user/data/models/user_model.dart';
import 'package:quikle_user/features/user/data/services/user_service.dart';

class ProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final postalCodeController = TextEditingController();

  final isEditing = false.obs;
  final isSaving = false.obs;
  final isDeleting = false.obs;
  final deleteError = ''.obs;

  final UserService userService = Get.find<UserService>();

  @override
  void onInit() {
    super.onInit();

    AppLoggerHelper.debug('ProfileController onInit - checking user data');

    // Populate fields with current user data (if available)
    _populateFields();

    // Listen for user data changes and repopulate fields
    ever<UserModel?>(userService.userRx, (_) {
      AppLoggerHelper.debug('User data changed, repopulating fields');
      _populateFields();
    });

    // Refresh user data from server to ensure we have the latest
    _refreshUserData();

    AppLoggerHelper.debug(
      'ProfileController initialized, user: ${userService.currentUser?.name}',
    );
  }

  Future<void> _refreshUserData() async {
    AppLoggerHelper.debug('Refreshing user data from server');
    await userService.refreshUser();
    AppLoggerHelper.debug(
      'User data refreshed: ${userService.currentUser?.name}',
    );
  }

  void _populateFields() {
    // Safety check: don't populate if controller is being/has been closed
    if (!Get.isRegistered<ProfileController>() || isClosed) {
      AppLoggerHelper.debug('Controller is closed, skipping field population');
      return;
    }

    final user = userService.currentUser;
    AppLoggerHelper.debug('_populateFields called, user: ${user?.name}');

    if (user == null) {
      AppLoggerHelper.debug('User is null, skipping field population');
      return;
    }

    try {
      nameController.text = user.name;
      emailController.text = user.email ?? '';
      phoneController.text = user.phone;
      address1Controller.text = user.address1 ?? '';
      address2Controller.text = user.address2 ?? '';
      postalCodeController.text = user.postalCode ?? '';

      AppLoggerHelper.debug(
        'Fields populated - name: ${nameController.text}, email: ${emailController.text}',
      );
      update();
    } catch (e) {
      AppLoggerHelper.debug('Error populating fields: $e');
    }
  }

  void enableEditing() => isEditing.value = true;

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;

    final updatedUser = UserModel(
      id: userService.currentUser?.id ?? "",
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      address1: address1Controller.text.trim(),
      address2: address2Controller.text.trim(),
      postalCode: postalCodeController.text.trim(),
    );

    final success = await userService.updateProfile(updatedUser);

    isSaving.value = false;

    if (success) {
      isEditing.value = false;

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to update profile',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> logout() async {
    await userService.logoutUser();
  }

  Future<void> deleteAccount() async {
    isDeleting.value = true;
    deleteError.value = '';

    try {
      final success = await userService.deleteAccount();

      isDeleting.value = false;

      if (success) {
        await userService.logoutUser();
      } else {
        deleteError.value = 'Failed to delete account. Please try again.';
      }
    } catch (e) {
      isDeleting.value = false;
      deleteError.value = 'Failed to delete account. Please try again.';
      AppLoggerHelper.debug('Error deleting account: $e');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    postalCodeController.dispose();
    super.onClose();
  }
}
