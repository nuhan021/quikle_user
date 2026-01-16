import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/enums/order_enums.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order/order_status_helpers.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';

class OrderHeader extends StatefulWidget {
  final OrderModel order;

  const OrderHeader({super.key, required this.order});

  @override
  State<OrderHeader> createState() => _OrderHeaderState();
}

class _OrderHeaderState extends State<OrderHeader> {
  bool _copied = false;

  void _copyOrderId() {
    Clipboard.setData(ClipboardData(text: widget.order.orderId));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _copied = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section with Status Badge
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: OrderStatusHelpers.getStatusColor(
                widget.order.status,
              ).withValues(alpha: 0.08),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Row(
              children: [
                // Status Icon
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: OrderStatusHelpers.getStatusColor(
                          widget.order.status,
                        ).withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: OrderStatusHelpers.getStatusIcon(widget.order.status),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        OrderStatusHelpers.getStatusText(widget.order.status),
                        style: getTextStyle(
                          font: CustomFonts.obviously,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: OrderStatusHelpers.getStatusColor(
                            widget.order.status,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _getStatusDescription(),
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF7C7C7C),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Order Details Section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order ID with Copy
                Row(
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      size: 16.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Order ID: ',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF7C7C7C),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.order.orderId,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ebonyBlack,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    InkWell(
                      onTap: _copyOrderId,
                      borderRadius: BorderRadius.circular(6.r),
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: _copied
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: Icon(
                            _copied ? Icons.check_rounded : Icons.copy_rounded,
                            key: ValueKey(_copied),
                            size: 14.sp,
                            color: _copied
                                ? AppColors.primary
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),
                Divider(height: 1, color: Colors.grey.shade200),
                SizedBox(height: 12.h),

                // Order Date
                _buildInfoRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'Placed on',
                  value: DateFormat(
                    'MMM d, yyyy · h:mm a',
                  ).format(widget.order.orderDate),
                ),

                // Estimated Delivery
                if (widget.order.estimatedDelivery != null) ...[
                  SizedBox(height: 10.h),
                  _buildInfoRow(
                    icon: Icons.local_shipping_rounded,
                    label: 'Estimated Delivery',
                    value: DateFormat(
                      'MMM d, yyyy · h:mm a',
                    ).format(widget.order.estimatedDelivery!),
                    valueColor: AppColors.beakYellow,
                  ),
                ],

                // Transaction ID
                if (widget.order.transactionId != null) ...[
                  SizedBox(height: 10.h),
                  _buildInfoRow(
                    icon: Icons.payment_rounded,
                    label: 'Transaction ID',
                    value: widget.order.transactionId!,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 14.sp,
          color: AppColors.primary.withValues(alpha: 0.7),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF7C7C7C),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppColors.ebonyBlack,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getStatusDescription() {
    switch (widget.order.status) {
      case OrderStatus.pending:
        return 'Waiting for confirmation';
      case OrderStatus.processing:
        return 'Being processed by vendor';
      case OrderStatus.confirmed:
        return 'Order confirmed by vendor';
      case OrderStatus.preparing:
        return 'Your order is being prepared';
      case OrderStatus.shipped:
        return 'Order has been shipped';
      case OrderStatus.outForDelivery:
        return 'On the way to you';
      case OrderStatus.delivered:
        return 'Successfully delivered';
      case OrderStatus.cancelled:
        return 'Order was cancelled';
      case OrderStatus.refunded:
        return 'Refund has been processed';
    }
  }
}
