import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/enums/order_enums.dart';
import 'package:quikle_user/features/orders/data/models/order_model.dart';
import 'package:quikle_user/features/orders/presentation/screens/order_tracking_screen.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order_item_widget.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order_status_helpers.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;

  const OrderCard({super.key, required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = order.estimatedDelivery?.difference(now);
    String estimatedDeliveryTime = '';

    if (order.status == OrderStatus.delivered) {
      estimatedDeliveryTime = 'Delivered';
    } else if (order.status == OrderStatus.cancelled) {
      estimatedDeliveryTime = 'Delivery Cancelled';
    } else if (difference != null && difference.inMinutes > 0) {
      estimatedDeliveryTime = '${difference.inMinutes} mins';
    } else if (difference != null && difference.inMinutes <= 0) {
      estimatedDeliveryTime = 'Delivery time passed';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order ${order.orderId}',
                  style: getTextStyle(
                    font: CustomFonts.obviously,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ebonyBlack,
                  ),
                ),
                Text(
                  DateFormat('MMMM d, yyyy').format(order.orderDate),
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.ebonyBlack,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                OrderStatusHelpers.getStatusIcon(order.status),
                SizedBox(width: 4.w),
                Text(
                  OrderStatusHelpers.getStatusText(order.status),
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: OrderStatusHelpers.getStatusColor(order.status),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            if (order.estimatedDelivery != null) ...[
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Estimated Delivery Time: ',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.ebonyBlack,
                      ),
                    ),
                    TextSpan(
                      text: estimatedDeliveryTime,
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7C7C7C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 8.h),
            Container(height: 1.h, color: const Color(0xFFEEEEEE)),
            SizedBox(height: 12.h),
            Text(
              'Items',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.ebonyBlack,
              ),
            ),
            SizedBox(height: 8.h),
            Container(height: 1.h, color: const Color(0xFFEEEEEE)),
            SizedBox(height: 12.h),

            if (order.items.isNotEmpty)
              ...order.items.map((item) => OrderItemWidget(item: item))
            else
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text(
                  'No items found',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7C7C7C),
                  ),
                ),
              ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: getTextStyle(
                    font: CustomFonts.obviously,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ebonyBlack,
                  ),
                ),
                Text(
                  '₹${order.total.toStringAsFixed(2)}',
                  style: getTextStyle(
                    font: CustomFonts.obviously,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ebonyBlack,
                  ),
                ),
              ],
            ),
            if (_shouldShowTrackButton()) ...[
              SizedBox(height: 8.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => OrderTrackingScreen(order: order));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ebonyBlack,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Track Order',
                    style: getTextStyle(
                      font: CustomFonts.obviously,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _shouldShowTrackButton() {
    return order.status == OrderStatus.confirmed ||
        order.status == OrderStatus.shipped ||
        order.status == OrderStatus.outForDelivery;
  }
}
