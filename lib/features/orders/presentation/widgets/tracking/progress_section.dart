import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/orders/controllers/order_tracking_controller.dart';
import 'package:quikle_user/features/orders/presentation/widgets/tracking/progress_step.dart';

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
        fontSize: 14.sp,
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
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF333333),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                height: 4.h,
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
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.ebonyBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSteps() {
    // Recompute isCompleted/isCurrent here based on controller.order.status
    // to avoid any mismatch between service-provided flags and the current
    // controller state.
    return Column(
      children: controller.deliverySteps.map((step) {
        final status = step['status'];
        // default to false if no status available
        bool isCompleted = false;
        bool isCurrent = false;

        try {
          final orderStatus = controller.order.status;
          if (status != null) {
            // Compare based on index if it's an enum
            // If status is an enum value from OrderStatus, it will have index
            final stepIndex = (status as dynamic).index as int?;
            final orderIndex = (orderStatus as dynamic).index as int?;
            if (stepIndex != null && orderIndex != null) {
              isCompleted = orderIndex > stepIndex;
              isCurrent = orderIndex == stepIndex;
            } else {
              // Fallback: direct equality
              isCurrent = orderStatus == status;
              isCompleted = false;
            }
          }
        } catch (_) {
          // ignore and fallback to service-provided values
          isCompleted = step['isCompleted'] ?? false;
          isCurrent = step['isCurrent'] ?? false;
        }

        final merged = Map<String, dynamic>.from(step)
          ..['isCompleted'] = isCompleted
          ..['isCurrent'] = isCurrent;

        return ProgressStep(step: merged);
      }).toList(),
    );
  }
}
