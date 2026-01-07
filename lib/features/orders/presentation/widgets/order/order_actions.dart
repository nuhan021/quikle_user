import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';
import 'package:quikle_user/core/utils/constants/enums/order_enums.dart';

class OrderActions extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onCancel;
  final VoidCallback onReportIssue;
  final VoidCallback onPaymentRefundStatus;

  const OrderActions({
    super.key,
    required this.order,
    required this.onCancel,
    required this.onReportIssue,
    required this.onPaymentRefundStatus,
  });

  @override
  Widget build(BuildContext context) {
    final canShowCancelButton =
        order.status == OrderStatus.processing ||
        order.status == OrderStatus.confirmed ||
        order.status == OrderStatus.preparing ||
        order.status == OrderStatus.shipped;

    final showDisabledCancelButton =
        order.status == OrderStatus.outForDelivery ||
        order.status == OrderStatus.delivered;

    final showCancelledBanner = order.status == OrderStatus.cancelled;

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
          if (showCancelledBanner) ...[
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.cancel_outlined, color: Colors.red, size: 20.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Your order has been cancelled as requested.',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.red.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
          ],

          if (canShowCancelButton)
            SizedBox(
              width: double.infinity,
              height: 44.h,
              child: OutlinedButton.icon(
                onPressed: onCancel,
                icon: Icon(Icons.cancel_outlined, size: 18.sp),
                label: Text('Cancel Order'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            )
          else if (showDisabledCancelButton) ...[
            SizedBox(
              width: double.infinity,
              height: 44.h,
              child: OutlinedButton.icon(
                onPressed: null,
                icon: Icon(Icons.cancel_outlined, size: 18.sp),
                label: Text('Cancel Order'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              order.status == OrderStatus.outForDelivery
                  ? "Cancellation isn't available because your order is already out for delivery. If you need help, tap 'Report an Issue' or 'Chat with support'."
                  : "This order has already been delivered, so it can't be cancelled. If something is wrong, tap 'Report an Issue'.",
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF7C7C7C),
              ),
            ),
          ],

          if (canShowCancelButton || showDisabledCancelButton)
            SizedBox(height: 12.h),

          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: OutlinedButton.icon(
              onPressed: onReportIssue,
              icon: Icon(Icons.report_problem_outlined, size: 18.sp),
              label: Text('Report an Issue'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: OutlinedButton.icon(
              onPressed: onPaymentRefundStatus,
              icon: Icon(Icons.account_balance_wallet_outlined, size: 18.sp),
              label: Text('Payment & Refund Status'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.ebonyBlack,
                side: BorderSide(color: Colors.grey.shade400),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
