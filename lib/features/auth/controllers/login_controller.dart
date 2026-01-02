import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/auth/data/services/auth_service.dart';
import 'package:quikle_user/features/profile/controllers/favorites_controller.dart';
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
    phoneController.addListener(() {
      // If user starts editing phone input, revert any temporary signup state
      if (showNameField.value || !isExistingUser.value) {
        showNameField.value = false;
        isExistingUser.value = true;
        nameController.text = '';
      }

      // Clear any inline error once user edits the input
      if (errorMessage.value.isNotEmpty) {
        errorMessage.value = '';
      }
    });

    // Clear inline errors when user edits name as well
    nameController.addListener(() {
      if (errorMessage.value.isNotEmpty) {
        errorMessage.value = '';
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

        // Build full phone with +91 prefix. phoneController holds only local digits.
        String fullPhone;
        if (phoneTrim.startsWith('+')) {
          fullPhone = phoneTrim;
        } else if (phoneTrim.startsWith('0')) {
          fullPhone = '+91' + phoneTrim.replaceFirst(RegExp(r'^0+'), '');
        } else {
          fullPhone = '+91' + phoneTrim;
        }

        final purpose = showNameField.value ? 'signup' : 'login';

        final response = await _auth.sendOtp(
          fullPhone,
          name: showNameField.value ? nameTrim : null,
          purpose: purpose,
        );

        if (response.statusCode == 200 && response.isSuccess) {
          final userExists = !showNameField.value;

          AppLoggerHelper.debug('Response Data: ${response.responseData}');

          final FlutterLocalNotificationsPlugin _localNotifications =
              FlutterLocalNotificationsPlugin();
          await _localNotifications.show(
            1,
            "You have a new OTP",
            response.responseData['message'],
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'otp_channel',
                'OTP Notifications',
                channelDescription: 'Notifications for OTP codes',
                importance: Importance.max,
                priority: Priority.high,
              ),
              iOS: DarwinNotificationDetails(),
            ),
          );
          Get.toNamed(
            AppRoute.getVerify(),
            arguments: {
              'phone': fullPhone,
              'name': showNameField.value ? nameTrim : null,
              'isLogin': userExists,
            },
          );
          isLoading.value = false;
          return;
        }

        if (response.statusCode == 400 && !showNameField.value) {
          final resend = await _auth.sendOtp(
            fullPhone,
            name: '',
            purpose: 'signup',
          );

          isLoading.value = false;

          if (resend.statusCode == 200 && resend.isSuccess) {
            final FlutterLocalNotificationsPlugin _localNotifications2 =
                FlutterLocalNotificationsPlugin();
            try {
              await _localNotifications2.show(
                1,
                "You have a new OTP",
                resend.responseData['message'],
                const NotificationDetails(
                  android: AndroidNotificationDetails(
                    'otp_channel',
                    'OTP Notifications',
                    channelDescription: 'Notifications for OTP codes',
                    importance: Importance.max,
                    priority: Priority.high,
                  ),
                  iOS: DarwinNotificationDetails(),
                ),
              );
            } catch (_) {}

            Get.toNamed(
              AppRoute.getVerify(),
              arguments: {'phone': fullPhone, 'name': '', 'isLogin': false},
            );
            return;
          }
          // If resend failed, surface the appropriate error inline
          errorMessage.value = resend.errorMessage.isNotEmpty
              ? resend.errorMessage
              : response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Something went wrong. Please try again.';
          return;
        }

        errorMessage.value = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Something went wrong. Please try again.';
      } catch (e) {
        errorMessage.value = 'Something went wrong. Please try again.';
      } finally {
        isLoading.value = false;
      }
    }
  }

  bool _validateInputs() {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      errorMessage.value = 'Please enter your phone number';
      return false;
    }
    // Expect user to enter 10 digits (local part) since +91 is prefixed
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length != 10) {
      errorMessage.value = 'Please enter a 10-digit mobile number';
      return false;
    }

    if (showNameField.value) {
      final name = nameController.text.trim();
      if (name.isEmpty) {
        errorMessage.value = 'Please enter your full name';
        return false;
      }

      if (name.length < 2) {
        errorMessage.value = 'Name must be at least 2 characters long';
        return false;
      }
    }

    return true;
  }

  Future<void> onTapLogin() async => onTapContinue();
  void onTapCreateAccount() => onTapContinue();

  void clearInputs() {
    nameController.text = '';
  }

  void clearPhone() {
    phoneController.text = '';
  }

  Future<void> logout() async {
    await _auth.logout();

    try {
      final favoritesController = Get.find<FavoritesController>();
      favoritesController.clearAllFavorites();
    } catch (e) {
      print('Could not clear favorites on logout: $e');
    }
    Get.offAllNamed(AppRoute.getLoginScreen());
  }

  @override
  void onClose() {
    phoneController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
