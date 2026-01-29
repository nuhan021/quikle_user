import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/features/orders/controllers/refund/refund_controller.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';
import 'package:quikle_user/features/orders/presentation/widgets/refund/payment_info_card.dart';
import 'package:quikle_user/features/orders/presentation/widgets/refund/payment_refund_shimmer.dart';
import 'package:quikle_user/features/orders/presentation/widgets/refund/refund_status_card.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';

/// Screen displaying payment and refund status with timeline
class PaymentRefundStatusScreen extends StatefulWidget {
  final OrderModel order;
  final double? totalAmount;

  const PaymentRefundStatusScreen({
    super.key,
    required this.order,
    this.totalAmount,
  });

  @override
  State<PaymentRefundStatusScreen> createState() =>
      _PaymentRefundStatusScreenState();
}

class _PaymentRefundStatusScreenState extends State<PaymentRefundStatusScreen> {
  late final RefundController _refundController;

  @override
  void initState() {
    super.initState();
    _refundController = Get.find<RefundController>();
    // Always load refund status to check if refund exists
    _refundController.loadRefundStatus(
      widget.order.orderId,
      parentOrderId: widget.order.parentOrderId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const UnifiedProfileAppBar(
              title: 'Payment & Refund Status',
              showBackButton: true,
            ),
            Expanded(
              child: Obx(() {
                final isLoading = _refundController.isLoadingRefundStatus;

                if (isLoading) {
                  return const PaymentRefundShimmer();
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PaymentInfoCard(
                        order: widget.order,
                        totalAmount: widget.totalAmount,
                      ),
                      SizedBox(height: 16.h),
                      if (_refundController.refundInfo != null)
                        RefundStatusCard(
                          refundInfo: _refundController.refundInfo!,
                          fallbackRefundReference: widget.order.refundReference,
                        ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
