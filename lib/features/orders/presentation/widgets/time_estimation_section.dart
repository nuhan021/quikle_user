import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/orders/controllers/order_tracking_controller.dart';
import 'package:quikle_user/features/orders/presentation/widgets/delivery_person_card.dart';

class TimeEstimationSection extends StatelessWidget {
  final OrderTrackingController controller;

  const TimeEstimationSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: controller.isActiveDelivery
            ? const Color(0xFFFFF8E1)
            : Colors.white,
        border: controller.isActiveDelivery
            ? const Border(left: BorderSide(color: Color(0xFFFFC200), width: 3))
            : null,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            _buildTimeInfo(),
            if (controller.isActiveDelivery &&
                controller.trackingData.value?['deliveryPerson'] != null) ...[
              SizedBox(height: 16.h),
              DeliveryPersonCard(controller: controller),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildTimeInfo() {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          color: controller.isActiveDelivery
              ? const Color(0xFFFFC200)
              : const Color(0xFF7C7C7C),
          size: 24.sp,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.isActiveDelivery
                    ? 'Your order is on the way!'
                    : 'Estimated Delivery Time',
                style: getTextStyle(
                  font: CustomFonts.obviously,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: controller.isActiveDelivery
                      ? const Color(0xFFFFC200)
                      : const Color(0xFF333333),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                controller.isActiveDelivery
                    ? 'Delivery person is approaching your location'
                    : 'Arriving in ${controller.estimatedTime.value}',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF7C7C7C),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
