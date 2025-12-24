import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import '../../controllers/payout_controller.dart';
import '../../data/models/delivery_option_model.dart';
import '../../../cart/controllers/cart_controller.dart';

class DeliveryOptionsSection extends StatelessWidget {
  const DeliveryOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final payoutController = Get.find<PayoutController>();
    final cartController = Get.find<CartController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Opacity(
            opacity: payoutController.isUrgentDelivery ? 0.5 : 1.0,
            child: IgnorePointer(
              ignoring: payoutController.isUrgentDelivery,
              child: Container(
                padding: EdgeInsets.all(16.w),
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
                child: Column(
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
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            // Clip the inner row to the same radius so any selected
                            // background (yellow) cannot overflow the rounded
                            // border of the container.
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.r),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildTableCell(
                                      option:
                                          payoutController.deliveryOptions[0],
                                      controller: payoutController,
                                      showRightBorder: true,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildTableCell(
                                      option:
                                          payoutController.deliveryOptions[1],
                                      controller: payoutController,
                                      showRightBorder: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Obx(() {
                            final selected = payoutController.deliveryOptions
                                .firstWhereOrNull((o) => o.isSelected);
                            return Text(
                              selected?.description ?? '',
                              style: getTextStyle(
                                font: CustomFonts.manrope,
                                fontSize: 14.sp,
                                color: const Color(0xFF7C7C7C),
                              ),
                              textAlign: TextAlign.center,
                            );
                          }),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        }),
        SizedBox(height: 8.h),
        Container(
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
              Expanded(
                child: Text(
                  'Delivery Preference',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF484848),
                  ),
                ),
              ),
              SizedBox(
                width: 200.w,
                child: TextField(
                  controller: payoutController.deliveryPreferenceController,
                  decoration: InputDecoration(
                    hintText: 'e.g. Don\'t call',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 8.h),
        Obx(() {
          if (cartController.hasMedicineItems) {
            return _buildUrgentDeliveryOption(payoutController);
          } else {
            return const SizedBox.shrink();
          }
        }),
      ],
    );
  }

  Widget _buildTableCell({
    required DeliveryOptionModel option,
    required PayoutController controller,
    required bool showRightBorder,
  }) {
    final cartController = Get.find<CartController>();
    final hasMultipleCategories = cartController.hasMultipleCategories;

    // Disable split delivery if all items are from same category
    final bool isDisabled =
        option.type.name == 'split' && !hasMultipleCategories;

    return GestureDetector(
      onTap: isDisabled ? null : () => controller.selectDeliveryOption(option),
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: option.isSelected
                ? AppColors.beakYellow
                : Colors.transparent,
            border: Border(
              right: showRightBorder
                  ? const BorderSide(color: Colors.black)
                  : BorderSide.none,
            ),
            // Round only the outer corners of each cell so the selected
            // background color is clipped inside the parent's rounded box.
            borderRadius: showRightBorder
                ? BorderRadius.only(
                    topLeft: Radius.circular(6.r),
                    bottomLeft: Radius.circular(6.r),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(6.r),
                    bottomRight: Radius.circular(6.r),
                  ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                option.title,
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 12.sp,
                  fontWeight: option.isSelected
                      ? FontWeight.w600
                      : FontWeight.w500,
                  color: option.isSelected
                      ? Colors.black
                      : const Color(0xFF484848),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                '₹${option.price.toStringAsFixed(2)}',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 12.sp,
                  fontWeight: option.isSelected
                      ? FontWeight.w600
                      : FontWeight.w500,
                  color: option.isSelected
                      ? Colors.black
                      : const Color(0xFF484848),
                ),
              ),
            ],
          ),
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
              onChanged: (_) => controller.toggleUrgentDelivery(),
              activeThumbColor: Colors.white,
              activeTrackColor: AppColors.beakYellow,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: AppColors.ebonyBlack,
            );
          }),
          // SizedBox(width: 8.w),
          // Icon(Icons.info_outline, size: 16.sp, color: Colors.red),
        ],
      ),
    );
  }
}
