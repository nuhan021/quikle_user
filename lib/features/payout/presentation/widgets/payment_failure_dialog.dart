import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';

class PaymentFailureDialog extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const PaymentFailureDialog({
    super.key,
    required this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // Auto-close after short delay and allow safe dismissal
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (Get.isDialogOpen ?? false) Get.back();
    });

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Payment failure image
            Image.asset(
              'assets/images/fail_payment.png',
              width: 250.w,
              height: 250.w,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            Text(
              "Payment Failed!",
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.ebonyBlack,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              "Your payment didn't go through.\nPlease try again.",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Intentionally no buttons: dialog auto-closes and is dismissible by tapping outside
          ],
        ),
      ),
    );
  }
}
