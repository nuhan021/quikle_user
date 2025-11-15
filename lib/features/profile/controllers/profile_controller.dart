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

  final userService = UserService.instance;

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

  void saveProfile() {
    if (formKey.currentState!.validate()) {
      isEditing.value = false;

      // OPTIONAL: Call API to update profile
      // userService.updateProfile(...);

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
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
