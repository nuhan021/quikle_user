import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/auth/data/services/auth_service.dart';
import 'package:quikle_user/routes/app_routes.dart';

class VerificationController extends GetxController {
  final RxList<String> otpDigits = List.generate(6, (_) => '').obs;
  late final String phone =
      (Get.arguments is Map && Get.arguments['phone'] != null)
      ? Get.arguments['phone'].toString()
      : '+8801XXXXXXXX';

  late final String? name =
      (Get.arguments is Map && Get.arguments['name'] != null)
      ? Get.arguments['name'].toString()
      : null;

  late final bool isLogin =
      (Get.arguments is Map && Get.arguments['isLogin'] != null)
      ? Get.arguments['isLogin'] as bool
      : false;

  final List<TextEditingController> digits = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focuses = List.generate(6, (_) => FocusNode());

  final isVerifying = false.obs;
  final errorMessage = ''.obs;

  final RxInt secondsLeft = 30.obs;
  Timer? _timer;

  late final AuthService _auth;

  @override
  void onInit() {
    super.onInit();
    _auth = Get.find<AuthService>();
    _startTimer();
  }

  void _startTimer() {
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
    final code = digits.map((e) => e.text).join();

    if (_validateOtp(code)) {
      isVerifying.value = true;
      errorMessage.value = '';

      try {
        final response = await _auth.verifyOtp(phone, code);

        if (response.isSuccess) {
          String message = 'Phone number verified successfully';
          if (response.responseData != null &&
              response.responseData['message'] != null) {
            message = response.responseData['message'].toString();
          }

          Get.snackbar(
            'Success',
            message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.withValues(alpha: 0.1),
            colorText: Colors.green,
          );
          Get.offAllNamed(AppRoute.getWelcome());
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
    // if (otp.length != 6) {
    //   errorMessage.value = 'Please enter complete 6-digit OTP';
    //   Get.snackbar(
    //     'Validation Error',
    //     'Please enter complete 6-digit OTP',
    //     snackPosition: SnackPosition.TOP,
    //     backgroundColor: Colors.orange.withValues(alpha: 0.1),
    //     colorText: Colors.orange,
    //   );
    //   return false;
    // }

    return true;
  }

  Future<void> onTapResend() async {
    if (!canResend) return;

    try {
      final response = await _auth.resendOtp(phone);

      if (response.isSuccess) {
        String message = 'OTP resent successfully';
        if (response.responseData != null &&
            response.responseData['message'] != null) {
          message = response.responseData['message'].toString();
        }

        Get.snackbar(
          'Success',
          message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );
        _startTimer();
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
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (final c in digits) c.dispose();
    for (final f in focuses) f.dispose();
    super.onClose();
  }
}
