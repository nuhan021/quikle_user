import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/orders/data/models/order/grouped_order_model.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order/brief_order_card.dart';
import 'package:quikle_user/features/orders/controllers/refund/refund_controller.dart';
import 'package:quikle_user/features/orders/controllers/orders_controller.dart';
import 'package:quikle_user/features/orders/presentation/widgets/refund/cancellation_bottom_sheet.dart';
import 'package:quikle_user/features/orders/presentation/widgets/refund/report_issue_bottom_sheet.dart';
import 'package:quikle_user/features/orders/presentation/screens/refund/payment_refund_status_screen.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order/order_status_helpers.dart';

class GroupedOrdersSection extends StatefulWidget {
  final GroupedOrderModel groupedOrder;
  final Function(OrderModel) onOrderTap;
  final Function(OrderModel)? onTrack;

  const GroupedOrdersSection({
    super.key,
    required this.groupedOrder,
    required this.onOrderTap,
    this.onTrack,
  });

  @override
  State<GroupedOrdersSection> createState() => _GroupedOrdersSectionState();
}

class _GroupedOrdersSectionState extends State<GroupedOrdersSection> {
  bool _isCopied = false;

  // Get RefundController from global bindings
  RefundController get _refundController => Get.find<RefundController>();

  @override
  Widget build(BuildContext context) {
    // if (widget.groupedOrder.orders.length == 1 &&
    //     widget.groupedOrder.orders.first.parentOrderId == null) {
    //   return BriefOrderCard(
    //     order: widget.groupedOrder.orders.first,
    //     onTap: () => widget.onOrderTap(widget.groupedOrder.orders.first),
    //     onTrack: widget.groupedOrder.orders.first.isTrackable
    //         ? () => widget.onTrack?.call(widget.groupedOrder.orders.first)
    //         : null,
    //   );
    // }

    // Show grouped orders with minimal clean design
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Clean header
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
            child: _buildCleanHeader(),
          ),

          // Divider
          Divider(height: 1.h, color: const Color(0xFFF1F5F9)),

          // Individual order items
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                ...widget.groupedOrder.orders.asMap().entries.map((entry) {
                  final index = entry.key;
                  final order = entry.value;
                  return Column(
                    children: [
                      if (index > 0) SizedBox(height: 16.h),
                      _buildOrderItem(order),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCleanHeader() {
    final parentOrderId = widget.groupedOrder.parentOrderId;
    final formattedDate = _formatOrderDate(widget.groupedOrder.orderDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Order ID, copy button, total, and three-dot menu
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Order ID with flexible width and ellipsis
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      parentOrderId,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  // Copy button with icon change animation
                  InkWell(
                    onTap: () => _copyToClipboard(parentOrderId),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        _isCopied ? Icons.check_circle : Icons.copy,
                        key: ValueKey(_isCopied),
                        size: 16.sp,
                        color: _isCopied
                            ? AppColors.primary
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Total
            Text(
              '₹${widget.groupedOrder.totalAmount.toStringAsFixed(2)}',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
            SizedBox(width: 8.w),
            // Three-dot menu
            InkWell(
              onTap: _showGroupActionsMenu,
              borderRadius: BorderRadius.circular(12.r),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Icon(
                  Icons.more_vert,
                  color: const Color(0xFF64748B),
                  size: 20.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        // Row 2: Date
        Text(
          formattedDate,
          style: getTextStyle(
            font: CustomFonts.inter,
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));

    // Change icon to checkmark
    setState(() {
      _isCopied = true;
    });

    // Revert back to copy icon after 1 second
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isCopied = false;
      });
    }
  }

  String _formatOrderDate(DateTime date) {
    // Format: "Jan 10, 2026 • 04:12 PM"
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = monthNames[date.month - 1];
    final day = date.day;
    final year = date.year;

    final hour = date.hour > 12
        ? date.hour - 12
        : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$month $day, $year • ${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  Widget _buildOrderItem(OrderModel order) {
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    if (firstItem == null) return const SizedBox.shrink();

    final productTitle = firstItem.product.title.trim().isNotEmpty
        ? firstItem.product.title
        : 'Product';
    final imagePath = firstItem.product.imagePath;
    final quantity = firstItem.quantityDisplay;
    final price = firstItem.product.price;

    return InkWell(
      onTap: () => widget.onOrderTap(order),
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            _buildProductImage(imagePath),
            SizedBox(width: 12.w),

            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    productTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1E293B),
                      lineHeight: 1.4,
                    ),
                  ),
                  SizedBox(height: 6.h),

                  // Status with icon
                  Row(
                    children: [
                      OrderStatusHelpers.getStatusIcon(order.status),
                      SizedBox(width: 6.w),
                      Text(
                        OrderStatusHelpers.getStatusText(order.status),
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: OrderStatusHelpers.getStatusColor(
                            order.status,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  // Quantity and price
                  Text(
                    '$quantity • ₹$price',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            // Right side: Track and DETAILS buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Track button (if trackable)
                if (order.isTrackable)
                  InkWell(
                    onTap: () => widget.onTrack?.call(order),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.beakYellow,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Track',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                if (order.isTrackable) SizedBox(height: 8.h),
                // DETAILS button
                InkWell(
                  onTap: () => widget.onOrderTap(order),
                  borderRadius: BorderRadius.circular(4.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    child: Text(
                      'DETAILS',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String imagePath) {
    if (imagePath.isEmpty) {
      return Container(
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          Icons.image_outlined,
          color: const Color(0xFFCBD5E1),
          size: 24.sp,
        ),
      );
    }

    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(6.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: imagePath.startsWith('http')
            ? Image.network(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => Icon(
                  Icons.broken_image,
                  color: const Color(0xFFCBD5E1),
                  size: 24.sp,
                ),
              )
            : Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => Icon(
                  Icons.broken_image,
                  color: const Color(0xFFCBD5E1),
                  size: 24.sp,
                ),
              ),
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
              if (widget.groupedOrder.canBeCancelled)
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
    // Calculate group total and pass grouped order info for eligibility check
    await _refundController.checkCancellationEligibilityForGroup(
      widget.groupedOrder,
    );

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

    // Show cancellation bottom sheet with group refund amount
    final firstOrder = widget.groupedOrder.orders.first;
    final result = await Get.bottomSheet<bool>(
      CancellationBottomSheet(
        order: firstOrder,
        eligibility: eligibility,
        isGroupCancellation: true,
        totalOrders: widget.groupedOrder.orders.length,
        parentOrderId:
            widget.groupedOrder.parentOrderId, // Pass parent order ID
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    if (result == true) {
      // Refresh orders list to show updated status
      final ordersController = Get.find<OrdersController>();
      await ordersController.refreshOrders();
    }
  }

  Future<void> _handleReportIssue() async {
    // Use the first order for issue reporting (applies to entire group)
    final firstOrder = widget.groupedOrder.orders.first;
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
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
        // backgroundColor: Colors.green.withValues(alpha: 0.1),
        // colorText: Colors.green,
      );
    }
  }

  void _handlePaymentRefundStatus() {
    final firstOrder = widget.groupedOrder.orders.first;
    _refundController;

    Get.to(
      () => PaymentRefundStatusScreen(
        order: firstOrder,
        totalAmount: widget.groupedOrder.totalAmount,
      ),
    );
  }
}
