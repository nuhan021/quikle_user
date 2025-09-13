import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import '../../controllers/payout_controller.dart';
import '../../data/models/delivery_option_model.dart';

class DeliveryOptionsSection extends StatelessWidget {
  const DeliveryOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final payoutController = Get.find<PayoutController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Delivery Options',
          style: getTextStyle(
            font: CustomFonts.obviously,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16.h),
        Obx(() {
          return Column(
            children: [
              ...payoutController.deliveryOptions.map(
                (option) => _buildDeliveryOption(option, payoutController),
              ),
              SizedBox(height: 8.h),
              _buildUrgentDeliveryOption(payoutController),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildDeliveryOption(
    DeliveryOptionModel option,
    PayoutController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.selectDeliveryOption(option),
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: option.isSelected
                      ? Colors.black
                      : Colors.grey.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: option.isSelected
                  ? Container(
                      margin: EdgeInsets.all(4.w),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF484848),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    option.description,
                    style: getTextStyle(
                      font: CustomFonts.manrope,
                      fontSize: 14.sp,
                      color: const Color(0xFF7C7C7C),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '\$${option.price.toStringAsFixed(2)}',
              style: getTextStyle(
                font: CustomFonts.manrope,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.info_outline,
              size: 16.sp,
              color: const Color(0xFFE03E1A),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrgentDeliveryOption(PayoutController controller) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
            height: 20.h,
            child: Image.asset(ImagePath.dangerIcon, fit: BoxFit.cover),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mark As Urgent',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF484848),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Priority delivery (extra fee applies)',
                  style: getTextStyle(
                    font: CustomFonts.manrope,
                    fontSize: 14.sp,
                    color: const Color(0xFF7C7C7C),
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            return Switch(
              value: controller.isUrgentDelivery,
              onChanged: (value) => controller.toggleUrgentDelivery(),
              activeThumbColor: Colors.white,
              activeTrackColor: Colors.black,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.black,
            );
          }),
          SizedBox(width: 8.w),
          Icon(Icons.info_outline, size: 16.sp, color: const Color(0xFFE03E1A)),
        ],
      ),
    );
  }
}
