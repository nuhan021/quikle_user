import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:intl/intl.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/orders/controllers/order_tracking_controller.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';
import 'package:quikle_user/features/orders/presentation/screens/order/order_invoice_screen.dart';

class OrderTrackingSummary extends StatelessWidget {
  final OrderModel order;
  final OrderTrackingController controller;

  const OrderTrackingSummary({
    super.key,
    required this.order,
    required this.controller,
  });

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
            color: Colors.black.withValues(alpha: .04),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(),
            SizedBox(height: 8.h),
            _buildOrderSummary(),
            SizedBox(height: 8.h),
            _buildViewDetailsButton(),
          ],
        );
      }),
    );
  }

  Widget _buildOrderHeader() {
    // Build a compact header that shows the first item's thumbnail + title
    Widget _thumbnail() {
      if (order.items.isEmpty) {
        return Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            Icons.shopping_bag_outlined,
            color: Colors.grey.shade500,
            size: 20.sp,
          ),
        );
      }

      final path = order.items.first.product.imagePath;
      final img = path.isNotEmpty
          ? (path.startsWith('http')
                ? Image.network(
                    path,
                    width: 44.w,
                    height: 44.w,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) =>
                        Container(color: Colors.grey.shade100),
                  )
                : Image.asset(
                    path,
                    width: 44.w,
                    height: 44.w,
                    fit: BoxFit.cover,
                  ))
          : Container(color: Colors.grey.shade100);

      return ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: SizedBox(width: 44.w, height: 44.w, child: img),
      );
    }

    String _mainTitle() {
      if (order.items.isEmpty) return order.orderId;
      final t = order.items.first.product.title.trim();
      return t.isNotEmpty ? t : order.orderId;
    }

    String _subtitle() {
      if (order.items.isEmpty) return '';
      final first = order.items.first;
      final qty = first.quantityDisplay;
      if (order.items.length == 1) return qty;
      return '$qty • +${order.items.length - 1} more';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _thumbnail(),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _mainTitle(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getTextStyle(
                  font: CustomFonts.obviously,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ebonyBlack,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _subtitle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7C7C7C),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    DateFormat(
                      "MMM d, yyyy 'at' h:mm a",
                    ).format(order.orderDate),
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9A9A9A),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(width: 12.w),
        // STATUS — takes required space
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            controller.statusText,
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.ebonyBlack,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${order.items.length} item${order.items.length != 1 ? 's' : ''}',
          style: getTextStyle(
            font: CustomFonts.inter,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF7C7C7C),
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Amount:',
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.ebonyBlack,
              ),
            ),
            Text(
              '₹${order.total.toStringAsFixed(2)}',
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.beakYellow,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildViewDetailsButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Get.to(() => OrderInvoiceScreen(order: order));
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.beakYellow, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'View Order Details',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.beakYellow,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.receipt_long, size: 16.sp, color: AppColors.beakYellow),
          ],
        ),
      ),
    );
  }
}
