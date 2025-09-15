import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/orders/controllers/order_tracking_controller.dart';
import 'package:quikle_user/features/orders/presentation/widgets/progress_step.dart';

class ProgressSection extends StatelessWidget {
  final OrderTrackingController controller;

  const ProgressSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(),
            SizedBox(height: 16.h),
            _buildProgressBar(),
            SizedBox(height: 24.h),
            _buildProgressSteps(),
          ],
        );
      }),
    );
  }

  Widget _buildSectionTitle() {
    return Text(
      'Delivery Progress',
      style: getTextStyle(
        font: CustomFonts.obviously,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF333333),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.statusText,
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF333333),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                height: 8.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: controller.progressPercentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.ebonyBlack,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        Text(
          '${(controller.progressPercentage * 100).toInt()}%',
          style: getTextStyle(
            font: CustomFonts.obviously,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.ebonyBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSteps() {
    return Column(
      children: controller.deliverySteps
          .map((step) => ProgressStep(step: step))
          .toList(),
    );
  }
}
