import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/chatting/presentation/screens/chat_screen.dart';
import 'package:quikle_user/features/orders/controllers/order_tracking_controller.dart';

class DeliveryPersonCard extends StatelessWidget {
  final OrderTrackingController controller;

  const DeliveryPersonCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final riderInfo = controller.order.riderInfo;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: const Color(0xFFF0F0F0),
            backgroundImage: riderInfo?.riderImage != null
                ? NetworkImage(riderInfo!.riderImage!)
                : null,
            child: riderInfo?.riderImage == null
                ? Icon(
                    Icons.person,
                    color: const Color(0xFF7C7C7C),
                    size: 20.sp,
                  )
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  riderInfo?.riderName ?? 'Delivery Person',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF333333),
                  ),
                ),
                Text(
                  'Delivery Partner',
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
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  final phone = riderInfo?.riderPhone;
                  if (phone != null) {
                    controller.contactDeliveryPerson(phone);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06BD4C),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(Icons.phone, color: Colors.white, size: 16.sp),
                ),
              ),
              SizedBox(width: 8.w), // spacing between icons
              GestureDetector(
                onTap: () {
                  final riderId = riderInfo?.riderId?.toString() ?? '3';
                  Get.to(() => ChatScreen(riderId: riderId));
                },
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06A0BD), // blue-ish chat color
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(Icons.chat, color: Colors.white, size: 16.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
