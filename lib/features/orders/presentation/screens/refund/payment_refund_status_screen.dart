import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/orders/controllers/refund/refund_controller.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';
import 'package:quikle_user/features/orders/data/models/refund/refund_info_model.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';

/// Screen displaying payment and refund status with timeline
class PaymentRefundStatusScreen extends StatefulWidget {
  final OrderModel order;

  const PaymentRefundStatusScreen({super.key, required this.order});

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
    // Load refund status if order has refund data
    if (widget.order.refundStatus != null) {
      _refundController.loadRefundStatus(widget.order.orderId);
    }
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
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPaymentInfoCard(),
                      SizedBox(height: 16.h),
                      if (widget.order.refundAmount != null ||
                          _refundController.refundInfo != null)
                        _buildRefundStatusCard(),
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

  Widget _buildPaymentInfoCard() {
    final paymentMethod = widget.order.paymentMethod.name;
    final amountPaid = widget.order.total;

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
          Text(
            'Payment Information',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.ebonyBlack,
            ),
          ),
          SizedBox(height: 16.h),
          _buildInfoRow('Payment Method', paymentMethod),
          SizedBox(height: 12.h),
          _buildInfoRow('Amount Paid', '₹${amountPaid.toStringAsFixed(2)}'),
          if (widget.order.transactionId != null) ...[
            SizedBox(height: 12.h),
            _buildInfoRow(
              'Transaction ID',
              widget.order.transactionId!,
              copyable: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRefundStatusCard() {
    final refundInfo = _refundController.refundInfo;
    final refundAmount =
        refundInfo?.refundAmount ?? widget.order.refundAmount ?? 0.0;
    final refundReference =
        refundInfo?.refundReference ?? widget.order.refundReference;

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
          Text(
            'Refund Information',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.ebonyBlack,
            ),
          ),
          SizedBox(height: 16.h),
          _buildInfoRow('Refund Amount', '₹${refundAmount.toStringAsFixed(2)}'),
          SizedBox(height: 12.h),
          _buildInfoRow(
            'Refund Destination',
            refundInfo?.destination.displayName ?? 'Original payment method',
          ),
          if (refundReference != null) ...[
            SizedBox(height: 12.h),
            _buildInfoRow(
              'Refund Reference (RRN)',
              refundReference,
              copyable: true,
            ),
          ],
          SizedBox(height: 20.h),
          _buildRefundTimeline(refundInfo),
          SizedBox(height: 16.h),
          _buildExpectedCompletion(refundInfo),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool copyable = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getTextStyle(
            font: CustomFonts.inter,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF7C7C7C),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ebonyBlack,
                  ),
                ),
              ),
              if (copyable) ...[
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    Get.snackbar(
                      'Copied',
                      '$label copied to clipboard',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  child: Icon(
                    Icons.copy,
                    size: 16.sp,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRefundTimeline(RefundInfo? refundInfo) {
    final steps = [
      {
        'title': 'Refund initiated',
        'completed': refundInfo?.initiatedAt != null,
        'time': refundInfo?.initiatedAt,
      },
      {
        'title': 'Refund processed',
        'completed': refundInfo?.processedAt != null,
        'time': refundInfo?.processedAt,
      },
      {
        'title': 'Refund completed',
        'completed': refundInfo?.completedAt != null,
        'time': refundInfo?.completedAt,
        'expected': refundInfo?.expectedCompletionDate,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Refund Timeline',
          style: getTextStyle(
            font: CustomFonts.inter,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.ebonyBlack,
          ),
        ),
        SizedBox(height: 12.h),
        ...steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isLast = index == steps.length - 1;
          final completed = step['completed'] as bool;
          final time = step['time'] as DateTime?;
          final expected = step['expected'] as DateTime?;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: completed
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: completed
                        ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                        : null,
                  ),
                  if (!isLast)
                    Container(
                      width: 2.w,
                      height: 40.h,
                      color: completed
                          ? AppColors.primary
                          : Colors.grey.shade300,
                    ),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title'] as String,
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: completed
                            ? AppColors.ebonyBlack
                            : Colors.grey.shade600,
                      ),
                    ),
                    if (time != null)
                      Text(
                        DateFormat('dd MMM yyyy, hh:mm a').format(time),
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600,
                        ),
                      )
                    else if (!completed && expected != null)
                      Text(
                        'Expected by ${DateFormat('dd MMM yyyy').format(expected)}',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.beakYellow,
                        ),
                      ),
                    SizedBox(height: isLast ? 0 : 12.h),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildExpectedCompletion(RefundInfo? refundInfo) {
    final message =
        refundInfo?.getExpectedTimelineMessage() ??
        'Refund initiated. Expected within 3–5 business days.';

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18.sp, color: AppColors.primary),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.ebonyBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
