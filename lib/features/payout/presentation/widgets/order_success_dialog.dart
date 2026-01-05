import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';

class OrderSuccessDialog extends StatelessWidget {
  final OrderModel order;
  final String transactionId;
  final VoidCallback? onContinue;

  const OrderSuccessDialog({
    super.key,
    required this.order,
    required this.transactionId,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    // Auto close after a short branded animation time and call onContinue
    Future.delayed(const Duration(seconds: 2), () {
      if (Get.isDialogOpen ?? false) {
        Get.back();
        if (onContinue != null) onContinue!();
      }
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
            SizedBox(
              width: 300.h,
              height: 300.h,
              child: Lottie.asset('assets/json/Success.json', repeat: false),
            ),

            // const SizedBox(height: 20),
            Text(
              "Your order is confirmed",
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.ebonyBlack,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              "Thank you for shopping with us.\n"
              "Your order will reach you soon.",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Intentionally no CTA - dialog auto-dismisses to show live order updates
          ],
        ),
      ),
    );
  }
}
