import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quikle_user/core/common/widgets/customer_support_fab.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/core/services/freshchat_service.dart';
import 'package:quikle_user/features/orders/controllers/order_tracking_controller.dart';
import 'package:quikle_user/features/orders/controllers/refund/refund_controller.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';
import 'package:quikle_user/features/orders/presentation/widgets/tracking/order_tracking_app_bar.dart';
import 'package:quikle_user/features/orders/presentation/widgets/tracking/order_tracking_map_section.dart';
import 'package:quikle_user/features/orders/presentation/widgets/tracking/time_estimation_section.dart';
import 'package:quikle_user/features/orders/presentation/widgets/tracking/progress_section.dart';
import 'package:quikle_user/features/orders/presentation/widgets/tracking/order_tracking_summary.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order/order_actions.dart';
import 'package:quikle_user/features/orders/presentation/widgets/refund/cancellation_bottom_sheet.dart';
import 'package:quikle_user/features/orders/presentation/widgets/refund/report_issue_bottom_sheet.dart';
import 'package:quikle_user/features/orders/presentation/screens/refund/payment_refund_status_screen.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel order;

  const OrderTrackingScreen({super.key, required this.order});

  // Get RefundController from global bindings
  RefundController get _refundController => Get.find<RefundController>();

  @override
  Widget build(BuildContext context) {
    OrderTrackingController controller;
    if (Get.isRegistered<OrderTrackingController>()) {
      controller = Get.find<OrderTrackingController>();
    } else {
      controller = Get.put(OrderTrackingController());
    }

    controller.initializeWithOrder(order);
    AppLoggerHelper.debug(
      'OrderTrackingScreen initialized with order ID: ${order.vendorInfo!.vendorId}',
    );
    AppLoggerHelper.debug(
      'OrderTrackingScreen initialized with order ID: ${order.vendorInfo!.vendorName}',
    );
    AppLoggerHelper.debug(
      'OrderTrackingScreen initialized with order ID: ${order.vendorInfo!.storeLatitude}',
    );
    AppLoggerHelper.debug(
      'OrderTrackingScreen initialized with order ID: ${order.vendorInfo!.storeLongitude}',
    );

    //SHipping address of the order
    AppLoggerHelper.debug(
      'OrderTrackingScreen initialized with order Shipping Address: ${order.shippingAddress.address}',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                const OrderTrackingAppBar(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.refreshTrackingData,
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 16.h),
                          OrderTrackingMapSection(
                            vendorLat: order.vendorInfo?.storeLatitude,
                            vendorLng: order.vendorInfo?.storeLongitude,
                            vendorName: order.vendorInfo?.vendorName,
                            shippingAddress: order.shippingAddress,
                          ),
                          SizedBox(height: 12.h),
                          OrderTrackingSummary(
                            order: order,
                            controller: controller,
                          ),
                          SizedBox(height: 12.h),
                          TimeEstimationSection(controller: controller),
                          SizedBox(height: 12.h),
                          ProgressSection(controller: controller),
                          SizedBox(height: 12.h),
                          // Order Actions Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: OrderActions(
                              order: order,
                              onCancel: _handleCancelOrder,
                              onReportIssue: _handleReportIssue,
                              onPaymentRefundStatus: _handlePaymentRefundStatus,
                            ),
                          ),
                          SizedBox(height: 100.h), // Extra space for FAB
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Customer Support FAB with order context for real-time delivery support
            CustomerSupportFAB(orderContext: _createOrderContext()),
          ],
        ),
      ),
    );
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
      deliveryPersonLocation: order.riderInfo != null
          ? 'Live Tracking Active'
          : 'Not Assigned',
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
