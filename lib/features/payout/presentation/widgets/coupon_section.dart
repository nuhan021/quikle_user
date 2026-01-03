import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            GestureDetector(
              onTap: () {
                payoutController.viewAllCoupons();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF26A969), Color(0xFF1EA254)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_offer, color: Colors.white, size: 12.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'View all',
                      style: getTextStyle(
                        font: CustomFonts.manrope,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        const Divider(height: 1, thickness: 1, color: Color(0xFFE8E9E9)),
        SizedBox(height: 12.h),

        Obx(() {
          // Touch the reactive applied-coupon so Obx subscribes to it and
          // rebuilds when it changes. Use the public (nullable) getter for
          // easier value access below.
          final _ = payoutController.appliedCouponRx.value;
          final applied = payoutController.appliedCoupon;
          return Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: applied != null && applied['isValid'] == true
                      ? Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: const Color(0xFF26A969),
                              size: 18.sp,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Coupon Applied',
                                        style: getTextStyle(
                                          font: CustomFonts.manrope,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.ebonyBlack,
                                        ),
                                      ),

                                      Text(
                                        // Use the coupon controller text (kept in sync by the
                                        // CouponController) which is simpler and avoids
                                        // null-safety analyzer issues here.
                                        '${payoutController.couponController.text}',
                                        style: getTextStyle(
                                          font: CustomFonts.inter,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF26A969),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'No coupon applied',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 14.sp,
                            color: const Color(0xFF333333),
                          ),
                        ),
                ),
                SizedBox(width: 12.w),
              ],
            ),
          );
        }),
      ],
    );
  }
}
