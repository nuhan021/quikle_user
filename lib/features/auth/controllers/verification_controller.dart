import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/features/auth/controllers/login_controller.dart';
import 'package:quikle_user/features/auth/data/services/auth_service.dart';
// ignore: unused_import
import 'package:quikle_user/features/profile/controllers/address_controller.dart';

import '../presentation/screens/splash_wrapper.dart';

class VerificationController extends GetxController {
  final RxList<String> otpDigits = List.generate(6, (_) => '').obs;
  final LoginController loginController = Get.find<LoginController>();

  // OTP Controller for pin_code_fields package
  final TextEditingController otpController = TextEditingController();

  // Read arguments dynamically so the controller works correctly when reused
  String get phone => (Get.arguments is Map && Get.arguments['phone'] != null)
      ? Get.arguments['phone'].toString()
      : '+8801XXXXXXXX';

  String? get name => (Get.arguments is Map && Get.arguments['name'] != null)
      ? Get.arguments['name'].toString()
      : null;

  bool get isLogin => (Get.arguments is Map && Get.arguments['isLogin'] != null)
      ? Get.arguments['isLogin'] as bool
      : false;

  final List<TextEditingController> digits = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focuses = List.generate(6, (_) => FocusNode());

  final isVerifying = false.obs;
  final isResending = false.obs;
  final errorMessage = ''.obs;

  final RxInt secondsLeft = 30.obs;
  Timer? _timer;

  late final AuthService _auth;

  @override
  void onInit() {
    super.onInit();
    _auth = Get.find<AuthService>();
    // ensure any stale OTP data is cleared when controller initializes
    _clearOtp();
    // _startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    secondsLeft.value = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft.value > 0) {
        secondsLeft.value--;
      } else {
        t.cancel();
      }
    });
  }

  bool get canResend => secondsLeft.value == 0;

  void onOtpChanged(String value) {
    for (int i = 0; i < value.length && i < 6; i++) {
      otpDigits[i] = value[i];
    }
    for (int i = value.length; i < 6; i++) {
      otpDigits[i] = '';
    }

    if (value.isNotEmpty && errorMessage.value.isNotEmpty) {
      errorMessage.value = '';
    }
  }

  void onDigitChanged(int index, String value) {
    otpDigits[index] = value;
    if (value.length == 1 && index < 5) {
      focuses[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focuses[index - 1].requestFocus();
    }
    if (value.isNotEmpty && errorMessage.value.isNotEmpty) {
      errorMessage.value = '';
    }
  }

  Future<void> onTapVerify() async {
    final code = otpController.text.trim();

    if (_validateOtp(code)) {
      isVerifying.value = true;
      errorMessage.value = '';

      try {
        late ResponseData response;

        // Check if this is a signup or login flow
        if (!isLogin && name != null && name!.isNotEmpty) {
          // Signup flow - hit the signup API
          response = await _auth.signupWithOtp(phone, name!, code);
        } else {
          // Login flow - hit the verify OTP API
          response = await _auth.login(phone, code);
        }

        if (response.isSuccess) {
          // Reload addresses after successful login
          try {
            final addressController = Get.find<AddressController>();
            await addressController.loadAddresses();
          } catch (e) {
            // AddressController might not be initialized yet, that's ok
            print('Could not reload addresses immediately after login: $e');
          }

          loginController.clearInputs();
          loginController.clearPhone();
          clearOtp();
          // Get.offAllNamed(AppRoute.getWelcome());
          Get.offAll(() => const SplashWrapper());
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
        isVerifying.value = false;
      }
    }
  }

  bool _validateOtp(String otp) {
    return true;
  }

  Future<void> onTapResend() async {
    if (!canResend || isResending.value) return;

    isResending.value = true;

    try {
      final response = await _auth.resendOtp(
        phone,
        name: name,
        isLogin: isLogin,
      );

      if (response.isSuccess) {
        if (response.responseData != null &&
            response.responseData['message'] != null) {}

        // Get.snackbar(
        //   'Success',
        //   message,
        //   snackPosition: SnackPosition.TOP,
        //   backgroundColor: Colors.green.withValues(alpha: 0.1),
        //   colorText: Colors.green,
        // );
        startTimer();
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to resend OTP. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isResending.value = false;
    }
  }

  /// Clear OTP inputs held in the controller (text fields and our observable list).
  /// Call this when leaving the verification flow so stale OTP isn't shown later.
  void clearOtp() {
    otpController.clear();
    for (int i = 0; i < digits.length; i++) {
      try {
        digits[i].text = '';
      } catch (_) {}
      try {
        otpDigits[i] = '';
      } catch (_) {}
    }
    errorMessage.value = '';
    secondsLeft.value = 30;
    _timer?.cancel();
  }

  void _clearOtp() => clearOtp();

  @override
  void onClose() {
    _timer?.cancel();
    otpController.dispose();
    for (final c in digits) c.dispose();
    for (final f in focuses) f.dispose();
    super.onClose();
  }
}
