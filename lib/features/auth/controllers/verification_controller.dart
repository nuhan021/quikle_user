import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/routes/app_routes.dart';

class VerificationController extends GetxController {
  final RxList<String> otpDigits = List.generate(6, (_) => '').obs;
  late final String phone =
      (Get.arguments is Map && Get.arguments['phone'] != null)
      ? Get.arguments['phone'].toString()
      : '+8801XXXXXXXX';

  final List<TextEditingController> digits = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focuses = List.generate(6, (_) => FocusNode());

  final isVerifying = false.obs;

  final RxInt secondsLeft = 30.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
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
  }

  Future<void> onTapVerify() async {
    isVerifying.value = true;
    try {
      final code = digits.map((e) => e.text).join();
      // TODO: integrate API later: await _auth.verify(phone, code)
      await Future<void>.delayed(const Duration(milliseconds: 400));
      Get.offAllNamed(AppRoute.getHome());
    } finally {
      isVerifying.value = false;
    }
  }

  void onTapResend() {
    if (!canResend) return;
    // TODO: call resend API here
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (final c in digits) c.dispose();
    for (final f in focuses) f.dispose();
    super.onClose();
  }
}
