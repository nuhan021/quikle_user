import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  final UserService userService = Get.find<UserService>();

  @override
  @override
  void onInit() {
    super.onInit();

    _populateFields();

    ever<UserModel?>(userService.userRx, (_) => _populateFields());
  }

  void _populateFields() {
    final user = userService.currentUser;
    if (user == null) return;

    nameController.text = user.name;
    emailController.text = user.email ?? '';
    phoneController.text = user.phone;
    address1Controller.text = user.address1 ?? '';
    address2Controller.text = user.address2 ?? '';
    postalCodeController.text = user.postalCode ?? '';

    update();
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
