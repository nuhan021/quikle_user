import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order/order_header.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order/order_actions.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order/order_items_list.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order/pricing_details.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order/payment_info_card.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order/shipping_address_card.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order/delivery_info_card.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';
import 'package:quikle_user/features/orders/presentation/screens/order/order_tracking_screen.dart';
import 'package:quikle_user/core/common/widgets/customer_support_fab.dart';
import 'package:quikle_user/core/services/freshchat_service.dart';
import 'package:quikle_user/features/orders/controllers/refund/refund_controller.dart';
import 'package:quikle_user/features/orders/presentation/widgets/refund/cancellation_bottom_sheet.dart';
import 'package:quikle_user/features/orders/presentation/widgets/refund/report_issue_bottom_sheet.dart';
import 'package:quikle_user/features/orders/presentation/screens/refund/payment_refund_status_screen.dart';

class OrderInvoiceScreen extends StatelessWidget {
  final OrderModel order;
  final bool hideActions; // Hide actions if this order is part of a group

  const OrderInvoiceScreen({
    super.key,
    required this.order,
    this.hideActions = false,
  });

  // Get RefundController from global bindings
  RefundController get _refundController => Get.find<RefundController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                UnifiedProfileAppBar(
                  title: 'Order Details',
                  showBackButton: true,
                  showActionButton: order.isTrackable,
                  actionText: order.isTrackable ? 'Track Order' : null,
                  onActionPressed: order.isTrackable
                      ? () => Get.to(() => OrderTrackingScreen(order: order))
                      : null,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      top: 20.h,
                      bottom: 0,
                    ),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OrderHeader(order: order),
                          SizedBox(height: 20.h),
                          OrderItemsList(order: order),
                          SizedBox(height: 20.h),
                          PricingDetails(order: order),
                          SizedBox(height: 20.h),
                          PaymentInfoCard(order: order),
                          SizedBox(height: 20.h),
                          ShippingAddressCard(order: order),
                          SizedBox(height: 20.h),
                          DeliveryInfoCard(order: order),
                          // Show actions only if not part of a group
                          if (!hideActions) ...[
                            SizedBox(height: 20.h),
                            OrderActions(
                              order: order,
                              onCancel: _handleCancelOrder,
                              onReportIssue: _handleReportIssue,
                              onPaymentRefundStatus: _handlePaymentRefundStatus,
                            ),
                          ],
                          SizedBox(height: 100.h), // Extra space for FAB
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Support FAB with order context for better customer support
            CustomerSupportFAB(orderContext: _createOrderContext()),
          ],
        ),
      ),
    );
  }

  /// Helper method to get delivery location string
  String _getDeliveryLocation() {
    if (order.riderInfo == null) return 'Not Assigned';
    // You could enhance this to show actual lat/long if available
    return 'Tracking Available';
  }

  /// Helper method to create order context for Freshchat support
  Map<String, dynamic> _createOrderContext() {
    return FreshchatService.createOrderContext(
      orderId: order.orderId,
      orderStatus: order.statusDisplayName,
      restaurantName: order.vendorInfo?.storeName,
      restaurantPhone: order.vendorInfo?.vendorPhone,
      deliveryPersonName: order.riderInfo?.riderName,
      deliveryPersonPhone: order.riderInfo?.riderPhone,
      deliveryPersonLocation: _getDeliveryLocation(),
      orderDate: DateFormat('dd MMM yyyy, hh:mm a').format(order.orderDate),
      estimatedDelivery: order.estimatedDelivery != null
          ? DateFormat('dd MMM yyyy, hh:mm a').format(order.estimatedDelivery!)
          : null,
      orderTotal: '₹${order.total.toStringAsFixed(2)}',
      items: order.items
          .map((item) => '${item.product.title} x${item.quantity}')
          .toList(),
    );
  }

  // (Previously the in-file builder methods were extracted into separate widgets.)

  /// Handler for Cancel Order button
  Future<void> _handleCancelOrder() async {
    // Check eligibility first
    await _refundController.checkCancellationEligibility(order);

    final eligibility = _refundController.cancellationEligibility;

    if (eligibility == null || !eligibility.isAllowed) {
      Get.snackbar(
        'Cannot Cancel',
        eligibility?.message ?? 'This order cannot be cancelled',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Show cancellation bottom sheet
    final result = await Get.bottomSheet<bool>(
      CancellationBottomSheet(order: order, eligibility: eligibility),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    // Refresh order if cancelled successfully
    if (result == true) {
      // TODO: Refresh order data from API
      Get.back(); // Go back to previous screen
    }
  }

  /// Handler for Report an Issue button
  Future<void> _handleReportIssue() async {
    final result = await Get.bottomSheet<Map<String, dynamic>>(
      ReportIssueBottomSheet(order: order),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    if (result != null) {
      // Show success message with ticket ID
      final ticketId = result['ticketId'];
      final sla = result['sla'];

      Get.snackbar(
        'Issue Reported',
        'Ticket created: $ticketId. We\'ll respond $sla.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    }
  }

  /// Handler for Payment & Refund Status button
  void _handlePaymentRefundStatus() {
    Get.to(() => PaymentRefundStatusScreen(order: order));
  }
}
