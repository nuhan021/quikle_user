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

    // final showCancelledBanner = order.status == OrderStatus.cancelled;

    return Column(
      children: [
        // Cancelled Banner
        // if (showCancelledBanner)
        //   Container(
        //     width: double.infinity,
        //     padding: EdgeInsets.all(16.w),
        //     margin: EdgeInsets.only(bottom: 12.h),
        //     decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //         colors: [Colors.red.shade50, Colors.red.shade100],
        //         begin: Alignment.topLeft,
        //         end: Alignment.bottomRight,
        //       ),
        //       borderRadius: BorderRadius.circular(12.r),
        //       border: Border.all(color: Colors.red.shade200, width: 1),
        //     ),
        //     child: Row(
        //       children: [
        //         Container(
        //           padding: EdgeInsets.all(8.w),
        //           decoration: BoxDecoration(
        //             color: Colors.white,
        //             shape: BoxShape.circle,
        //           ),
        //           child: Icon(
        //             Icons.cancel_rounded,
        //             color: Colors.red,
        //             size: 24.sp,
        //           ),
        //         ),
        //         SizedBox(width: 12.w),
        //         Expanded(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(
        //                 'Order Cancelled',
        //                 style: getTextStyle(
        //                   font: CustomFonts.obviously,
        //                   fontSize: 14.sp,
        //                   fontWeight: FontWeight.w600,
        //                   color: Colors.red.shade900,
        //                 ),
        //               ),
        //               SizedBox(height: 2.h),
        //               Text(
        //                 'Your order has been cancelled as requested.',
        //                 style: getTextStyle(
        //                   font: CustomFonts.inter,
        //                   fontSize: 12.sp,
        //                   fontWeight: FontWeight.w400,
        //                   color: Colors.red.shade700,
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),

        // Quick Actions Grid
        Container(
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
              Text(
                'Quick Actions',
                style: getTextStyle(
                  font: CustomFonts.obviously,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ebonyBlack,
                ),
              ),
              SizedBox(height: 16.h),

              // Action Cards in a responsive grid
              if (canShowCancelButton) ...[
                _buildActionCard(
                  icon: Icons.cancel_rounded,
                  iconColor: Colors.red,
                  iconBgColor: Colors.red.shade50,
                  title: 'Cancel Order',
                  subtitle: 'Cancel and get refund',
                  onTap: onCancel,
                ),
                SizedBox(height: 12.h),
              ] else if (showDisabledCancelButton) ...[
                _buildActionCard(
                  icon: Icons.cancel_rounded,
                  iconColor: Colors.grey.shade400,
                  iconBgColor: Colors.grey.shade100,
                  title: 'Cancel Order',
                  subtitle: order.status == OrderStatus.outForDelivery
                      ? 'Not available - Out for delivery'
                      : 'Not available - Already delivered',
                  onTap: null,
                  isDisabled: true,
                ),
                SizedBox(height: 12.h),
              ],

              _buildActionCard(
                icon: Icons.report_problem_rounded,
                iconColor: AppColors.primary,
                iconBgColor: AppColors.primary.withValues(alpha: 0.1),
                title: 'Report an Issue',
                subtitle: 'Missing or damaged items',
                onTap: onReportIssue,
              ),
              SizedBox(height: 12.h),

              _buildActionCard(
                icon: Icons.account_balance_wallet_rounded,
                iconColor: const Color(0xFF2E7D32),
                iconBgColor: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                title: 'Payment & Refund',
                subtitle: 'View transaction details',
                onTap: onPaymentRefundStatus,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    bool isDisabled = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isDisabled ? Colors.grey.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDisabled ? Colors.grey.shade200 : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: iconColor, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isDisabled
                            ? Colors.grey.shade400
                            : AppColors.ebonyBlack,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: isDisabled
                            ? Colors.grey.shade400
                            : const Color(0xFF7C7C7C),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isDisabled)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.sp,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
