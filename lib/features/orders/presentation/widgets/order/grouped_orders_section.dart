import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/orders/data/models/order/grouped_order_model.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order/brief_order_card.dart';
import 'package:quikle_user/features/orders/controllers/refund/refund_controller.dart';
import 'package:quikle_user/features/orders/presentation/widgets/refund/cancellation_bottom_sheet.dart';
import 'package:quikle_user/features/orders/presentation/widgets/refund/report_issue_bottom_sheet.dart';
import 'package:quikle_user/features/orders/presentation/screens/refund/payment_refund_status_screen.dart';

/// Displays a group of orders that share the same parent_order_id
/// Shows all orders in the group with a three-dot menu for group actions
class GroupedOrdersSection extends StatelessWidget {
  final GroupedOrderModel groupedOrder;
  final Function(OrderModel) onOrderTap;
  final Function(OrderModel)? onTrack;

  const GroupedOrdersSection({
    super.key,
    required this.groupedOrder,
    required this.onOrderTap,
    this.onTrack,
  });

  RefundController get _refundController {
    if (!Get.isRegistered<RefundController>()) {
      Get.put(RefundController());
    }
    return Get.find<RefundController>();
  }

  @override
  Widget build(BuildContext context) {
    // If only one order and no parent_order_id, show as single card
    if (groupedOrder.orders.length == 1 &&
        groupedOrder.orders.first.parentOrderId == null) {
      // Single order - actions are allowed in invoice screen
      return BriefOrderCard(
        order: groupedOrder.orders.first,
        onTap: () => onOrderTap(groupedOrder.orders.first),
        onTrack: groupedOrder.orders.first.isTrackable
            ? () => onTrack?.call(groupedOrder.orders.first)
            : null,
      );
    }

    // Show grouped orders with header and three-dot menu
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group Header with three-dot menu
          _buildGroupHeader(),

          // Divider
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Divider(height: 1.h, color: Colors.grey.shade200),
          ),

          // Individual orders - pass hideActions parameter
          ...groupedOrder.orders.asMap().entries.map((entry) {
            final order = entry.value;
            return Column(
              children: [
                BriefOrderCard(
                  order: order,
                  onTap: () =>
                      onOrderTap(order), // Already handled in orders_screen
                  onTrack: order.isTrackable
                      ? () => onTrack?.call(order)
                      : null,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGroupHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${groupedOrder.orders.length} orders',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ebonyBlack,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '• ₹${groupedOrder.totalAmount.toStringAsFixed(2)}',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.beakYellow,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Three-dot menu
          IconButton(
            onPressed: () => _showGroupActionsMenu(),
            icon: Icon(
              Icons.more_vert,
              color: AppColors.ebonyBlack,
              size: 20.sp,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.h),
          ),
        ],
      ),
    );
  }

  void _showGroupActionsMenu() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 12.h, bottom: 20.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              // Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Text(
                      'Group Actions',
                      style: getTextStyle(
                        font: CustomFonts.obviously,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ebonyBlack,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Action items
              if (groupedOrder.canBeCancelled)
                _buildActionItem(
                  icon: Icons.cancel_outlined,
                  label: 'Cancel All Orders',
                  color: Colors.red,
                  onTap: () {
                    Get.back();
                    _handleCancelAllOrders();
                  },
                ),

              _buildActionItem(
                icon: Icons.report_problem_outlined,
                label: 'Report an Issue',
                color: Colors.orange,
                onTap: () {
                  Get.back();
                  _handleReportIssue();
                },
              ),

              _buildActionItem(
                icon: Icons.payment_outlined,
                label: 'Payment & Refund Status',
                color: AppColors.beakYellow,
                onTap: () {
                  Get.back();
                  _handlePaymentRefundStatus();
                },
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                label,
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ebonyBlack,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCancelAllOrders() async {
    // Use the first order for eligibility check (applies to entire group)
    final firstOrder = groupedOrder.orders.first;
    await _refundController.checkCancellationEligibility(firstOrder);

    final eligibility = _refundController.cancellationEligibility;

    if (eligibility == null || !eligibility.isAllowed) {
      Get.snackbar(
        'Cannot Cancel',
        eligibility?.message ?? 'These orders cannot be cancelled',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    // Show cancellation bottom sheet
    final result = await Get.bottomSheet<bool>(
      CancellationBottomSheet(order: firstOrder, eligibility: eligibility),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    if (result == true) {
      // Refresh orders list
      Get.snackbar(
        'Success',
        'Order group cancelled successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );
    }
  }

  Future<void> _handleReportIssue() async {
    // Use the first order for issue reporting (applies to entire group)
    final firstOrder = groupedOrder.orders.first;
    final result = await Get.bottomSheet<Map<String, dynamic>>(
      ReportIssueBottomSheet(order: firstOrder),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    if (result != null) {
      final ticketId = result['ticketId'];
      final sla = result['sla'];

      Get.snackbar(
        'Issue Reported',
        'Ticket created: $ticketId. We\'ll respond $sla.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );
    }
  }

  void _handlePaymentRefundStatus() {
    // Use the first order for payment/refund status (represents the group)
    final firstOrder = groupedOrder.orders.first;
    Get.to(() => PaymentRefundStatusScreen(order: firstOrder));
  }
}
