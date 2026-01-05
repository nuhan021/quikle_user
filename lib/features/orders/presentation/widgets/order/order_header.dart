import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order/order_status_helpers.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';

class OrderHeader extends StatelessWidget {
  final OrderModel order;

  const OrderHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${order.orderId}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getTextStyle(
                          font: CustomFonts.obviously,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ebonyBlack,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: order.orderId));
                        Get.snackbar(
                          'Copied',
                          'Order ID copied to clipboard',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      child: Icon(
                        Icons.copy,
                        size: 16.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: OrderStatusHelpers.getStatusColor(
                    order.status,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OrderStatusHelpers.getStatusIcon(order.status),
                    SizedBox(width: 4.w),
                    Text(
                      OrderStatusHelpers.getStatusText(order.status),
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: OrderStatusHelpers.getStatusColor(order.status),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                'Order Date: ',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF7C7C7C),
                ),
              ),
              Expanded(
                child: Text(
                  DateFormat('MMMM d, yyyy at h:mm a').format(order.orderDate),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ebonyBlack,
                  ),
                ),
              ),
            ],
          ),
          if (order.estimatedDelivery != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  'Estimated Delivery: ',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7C7C7C),
                  ),
                ),
                Expanded(
                  child: Text(
                    DateFormat(
                      'MMM d, yyyy at h:mm a',
                    ).format(order.estimatedDelivery!),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.beakYellow,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (order.transactionId != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  'Transaction ID: ',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7C7C7C),
                  ),
                ),
                Expanded(
                  child: Text(
                    order.transactionId!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ebonyBlack,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
