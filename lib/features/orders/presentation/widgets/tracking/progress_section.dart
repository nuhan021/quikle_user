import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/orders/controllers/order_tracking_controller.dart';
import 'package:quikle_user/features/orders/presentation/widgets/tracking/progress_step.dart';

class ProgressSection extends StatefulWidget {
  final OrderTrackingController controller;

  const ProgressSection({super.key, required this.controller});

  @override
  State<ProgressSection> createState() => _ProgressSectionState();
}

class _ProgressSectionState extends State<ProgressSection> {
  bool _isExpanded = false;

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
        if (widget.controller.isLoading.value) {
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
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Delivery Progress',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF333333),
            ),
          ),
          Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: const Color(0xFF666666),
            size: 24.sp,
          ),
        ],
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
                widget.controller.statusText,
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
                  widthFactor: widget.controller.progressPercentage,
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
          '${(widget.controller.progressPercentage * 100).toInt()}%',
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
    // Show only current step when collapsed
    if (!_isExpanded) {
      final currentStep = widget.controller.deliverySteps.firstWhere((step) {
        try {
          final orderStatus = widget.controller.order.status;
          final status = step['status'];
          if (status == null) return false;

          final stepIndex = (status as dynamic).index as int?;
          final orderIndex = (orderStatus as dynamic).index as int?;
          if (stepIndex != null && orderIndex != null) {
            return orderIndex == stepIndex;
          }
          return orderStatus == status;
        } catch (_) {
          return step['isCurrent'] ?? false;
        }
      }, orElse: () => widget.controller.deliverySteps.last);

      bool isCompleted = false;
      bool isCurrent = false;

      try {
        final orderStatus = widget.controller.order.status;
        final status = currentStep['status'];
        if (status != null) {
          final stepIndex = (status as dynamic).index as int?;
          final orderIndex = (orderStatus as dynamic).index as int?;
          if (stepIndex != null && orderIndex != null) {
            isCompleted = orderIndex > stepIndex;
            isCurrent = orderIndex == stepIndex;
          } else {
            isCurrent = orderStatus == status;
            isCompleted = false;
          }
        }
      } catch (_) {
        isCompleted = currentStep['isCompleted'] ?? false;
        isCurrent = currentStep['isCurrent'] ?? false;
      }

      final merged = Map<String, dynamic>.from(currentStep)
        ..['isCompleted'] = isCompleted
        ..['isCurrent'] = isCurrent;

      return ProgressStep(step: merged);
    }

    // Show all steps when expanded
    return Column(
      children: widget.controller.deliverySteps.map((step) {
        final status = step['status'];
        bool isCompleted = false;
        bool isCurrent = false;

        try {
          final orderStatus = widget.controller.order.status;
          if (status != null) {
            final stepIndex = (status as dynamic).index as int?;
            final orderIndex = (orderStatus as dynamic).index as int?;
            if (stepIndex != null && orderIndex != null) {
              isCompleted = orderIndex > stepIndex;
              isCurrent = orderIndex == stepIndex;
            } else {
              isCurrent = orderStatus == status;
              isCompleted = false;
            }
          }
        } catch (_) {
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
