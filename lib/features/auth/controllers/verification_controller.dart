import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/models/response_data.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quikle_user/core/notification/controllers/notification_controller.dart';
import 'package:quikle_user/features/auth/controllers/login_controller.dart';
import 'package:quikle_user/features/auth/data/services/auth_service.dart';
import 'package:quikle_user/features/profile/controllers/address_controller.dart';
import 'package:quikle_user/features/profile/controllers/favorites_controller.dart';
import 'package:quikle_user/features/prescription/controllers/prescription_controller.dart';

import '../presentation/screens/splash_wrapper.dart';

class VerificationController extends GetxController {
  final RxList<String> otpDigits = List.generate(6, (_) => '').obs;
  final LoginController loginController = Get.find<LoginController>();

  final TextEditingController otpController = TextEditingController();

  String get phone => (Get.arguments is Map && Get.arguments['phone'] != null)
      ? Get.arguments['phone'].toString()
      : '+8801XXXXXXXX';

  String get name => (Get.arguments is Map && Get.arguments['name'] != null)
      ? Get.arguments['name'].toString()
      : '';

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

  // Controller used to trigger pin code field error animations (shake/clear)
  final StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>.broadcast();

  final RxInt secondsLeft = 30.obs;
  Timer? _timer;

  late final AuthService _auth;

  @override
  void onInit() {
    super.onInit();
    _auth = Get.find<AuthService>();
    _clearOtp();
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

        if (!isLogin) {
          response = await _auth.signupWithOtp(phone, name, code);
        } else {
          response = await _auth.login(phone, code);
        }

        if (response.isSuccess) {
          try {
            final notificationController = Get.find<NotificationController>();
            final fcmToken = await notificationController.getFCMToken();
            if (fcmToken != null && fcmToken.isNotEmpty) {
              await notificationController.saveFCMToken(fcmToken);
            }
          } catch (e) {
            print('Could not save FCM token immediately after login: $e');
          }
          try {
            final addressController = Get.find<AddressController>();
            await addressController.loadAddresses();
          } catch (e) {
            print('Could not reload addresses immediately after login: $e');
          }

          try {
            final favoritesController = Get.find<FavoritesController>();
            await favoritesController.loadFavorites();
          } catch (e) {
            print('Could not load favorites immediately after login: $e');
          }

          try {
            final prescriptionController = Get.find<PrescriptionController>();
            await Future.wait([
              prescriptionController.loadUserPrescriptions(),
              prescriptionController.loadPrescriptionMedicines(),
              prescriptionController.loadRecentPrescriptionMedicines(),
              prescriptionController.loadPrescriptionStats(),
            ]);
          } catch (e) {
            print(
              'Could not load prescription data immediately after login: $e',
            );
          }

          loginController.clearInputs();
          loginController.clearPhone();
          clearOtp();
          Get.offAll(() => const SplashWrapper());
        } else {
          // For 400 responses, decide between invalid vs expired messages
          if (response.statusCode == 400) {
            final err = response.errorMessage.toLowerCase();
            if (err.contains('expired') ||
                err.contains('not found') ||
                err.contains('notfound')) {
              errorMessage.value = 'OTP has expired. Please resend.';
            } else if (err.contains('invalid')) {
              errorMessage.value = 'Invalid OTP. Please try again.';
            } else {
              errorMessage.value = response.errorMessage;
            }

            try {
              errorController.add(ErrorAnimationType.shake);
              Future.delayed(const Duration(milliseconds: 1400), () {
                try {
                  errorController.add(ErrorAnimationType.clear);
                } catch (_) {}
              });
            } catch (_) {}
          } else {
            errorMessage.value = response.errorMessage;
          }
        }
      } catch (e) {
        errorMessage.value = 'Something went wrong. Please try again.';
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
        startTimer();
      } else {
        errorMessage.value = response.errorMessage;
      }
    } catch (e) {
      errorMessage.value = 'Failed to resend OTP. Please try again.';
    } finally {
      isResending.value = false;
    }
  }

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
    try {
      errorController.close();
    } catch (_) {}
    super.onClose();
  }
}
