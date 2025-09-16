import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/orders/controllers/live_order_controller.dart';

class LiveOrderIndicator extends StatelessWidget {
  const LiveOrderIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveOrderController>(
      init: LiveOrderController(),
      builder: (controller) {
        return Obx(() {
          
          if (!controller.hasLiveOrder) {
            return const SizedBox.shrink();
          }

          return Container(
            margin: EdgeInsets.only(left: 0, right: 0, top: 8.h, bottom: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: controller.navigateToTracking,
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      
                      Row(
                        children: [
                          
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: _getStatusColor(controller.statusText),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 10.w),

                          
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.statusText,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  controller.primaryItemName,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (controller.estimatedTime.isNotEmpty)
                                Text(
                                  controller.estimatedTime,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF2E7D32),
                                  ),
                                ),
                              SizedBox(height: 2.h),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 10.sp,
                                color: Colors.grey[400],
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Order Progress',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '${(controller.progressPercentage * 100).toInt()}%',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2.r),
                            child: LinearProgressIndicator(
                              value: controller.progressPercentage,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getStatusColor(controller.statusText),
                              ),
                              minHeight: 3.h,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'order confirmed':
        return const Color(0xFF2196F3); 
      case 'preparing':
        return const Color(0xFFF57C00); 
      case 'ready for pickup':
        return const Color(0xFF9C27B0); 
      case 'on the way':
        return const Color(0xFF4CAF50); 
      case 'delivered':
        return const Color(0xFF2E7D32); 
      default:
        return const Color(0xFF757575); 
    }
  }
}
