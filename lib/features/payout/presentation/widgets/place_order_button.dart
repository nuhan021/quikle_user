import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import '../../controllers/payout_controller.dart';

class PlaceOrderButton extends StatelessWidget {
  const PlaceOrderButton({super.key});

  @override
  Widget build(BuildContext context) {
    final payoutController = Get.find<PayoutController>();

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Obx(() {
        return GestureDetector(
          onTap: payoutController.isProcessingPayment
              ? null
              : () => payoutController.placeOrder(),
          child: Container(
            height: 56.h,
            decoration: BoxDecoration(
              color: payoutController.isProcessingPayment
                  ? Colors.grey
                  : Colors.black,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: payoutController.isProcessingPayment
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Processing...',
                          style: getTextStyle(
                            font: CustomFonts.manrope,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Place Order',
                      style: getTextStyle(
                        font: CustomFonts.manrope,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        );
      }),
    );
  }
}
