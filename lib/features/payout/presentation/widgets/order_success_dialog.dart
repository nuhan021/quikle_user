import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/orders/data/models/order_model.dart';

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
            // Green circle with check icon
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 50),
            ),

            const SizedBox(height: 20),

            // Title
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

            // Subtitle text
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

            // Continue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    onContinue ??
                    () {
                      Get.back();
                      Get.offAllNamed('/main');
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Continue Shopping",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
