import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import '../../controllers/payout_controller.dart';

class ShippingAddressSection extends StatelessWidget {
  const ShippingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final payoutController = Get.find<PayoutController>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Shipping Address',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.ebonyBlack,
            ),
          ),
          SizedBox(height: 8.h),
          Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
          SizedBox(height: 12.h),

          Obx(() {
            final a = payoutController.selectedShippingAddress;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFFE8E9E9)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFF0F0F0)),
                        ),
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 18.sp,
                          color: const Color(0xFF7C7C7C),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        a?.typeDisplayName ?? 'Home',
                        style: getTextStyle(
                          font: CustomFonts.manrope,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF28272F),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a?.name ?? 'Aanya Desai',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF484848),
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Text(
                          a?.fullAddress ?? '28 Crescent Day. LA Port, CA.',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 14.sp,
                            color: const Color(0xFF7C7C7C),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 20.sp,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
