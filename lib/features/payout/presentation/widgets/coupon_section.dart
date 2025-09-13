import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import '../../controllers/payout_controller.dart';

class CouponSection extends StatelessWidget {
  const CouponSection({super.key});

  @override
  Widget build(BuildContext context) {
    final payoutController = Get.find<PayoutController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Apply Coupon Code',
          style: getTextStyle(
            font: CustomFonts.obviously,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF333333),
          ),
        ),
        SizedBox(height: 8.h),
        const Divider(height: 1, thickness: 1, color: Color(0xFFE8E9E9)),
        SizedBox(height: 12.h),

        Obx(() {
          final applied = payoutController.appliedCoupon;
          if (applied != null && applied['isValid'] == true) {
            return _buildAppliedCoupon(payoutController);
          }
          return _buildCouponInput(payoutController);
        }),
      ],
    );
  }

  Widget _buildCouponInput(PayoutController controller) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller.couponController,
              textInputAction: TextInputAction.done,
              onChanged: (_) {},
              onFieldSubmitted: (_) {
                if (controller.canApplyCoupon) controller.applyCoupon();
              },
              decoration: InputDecoration(
                hintText: 'Type your Coupon Code',
                hintStyle: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  color: const Color(0xFF7C7C7C),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 14.h,
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Color(0xFFB8B8B8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Color(0xFFB8B8B8)),
                ),
              ),
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                color: const Color(0xFF1C1C1C),
              ),
            ),
          ),
          SizedBox(width: 8.w),

          Obx(() {
            final disabled = !controller.canApplyCoupon;
            return GestureDetector(
              onTap: disabled ? null : controller.applyCoupon,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 120),
                opacity: disabled ? 0.5 : 1,
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Apply',
                    style: getTextStyle(
                      font: CustomFonts.manrope,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFF8F8F8),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAppliedCoupon(PayoutController controller) {
    final coupon = controller.appliedCoupon!;
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF26A969).withValues(alpha: 0.10),
        border: Border.all(color: const Color(0xFF26A969)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: const Color(0xFF26A969), size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coupon Applied: ${controller.couponController.text}',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF26A969),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  coupon['message'] ?? '',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 12.sp,
                    color: const Color(0xFF26A969),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: controller.removeCoupon,
            child: Icon(
              Icons.close,
              color: const Color(0xFF9E9E9E),
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}
