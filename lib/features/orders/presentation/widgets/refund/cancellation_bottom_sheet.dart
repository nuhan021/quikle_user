import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/enums/refund_enums.dart';
import 'package:quikle_user/features/orders/controllers/refund/refund_controller.dart';
import 'package:quikle_user/features/orders/data/models/refund/cancellation_eligibility_model.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';

/// Bottom sheet for order cancellation with refund impact display
class CancellationBottomSheet extends StatefulWidget {
  final OrderModel order;
  final CancellationEligibility eligibility;

  const CancellationBottomSheet({
    super.key,
    required this.order,
    required this.eligibility,
  });

  @override
  State<CancellationBottomSheet> createState() =>
      _CancellationBottomSheetState();
}

class _CancellationBottomSheetState extends State<CancellationBottomSheet> {
  final RefundController _refundController = Get.find<RefundController>();
  CancellationReason? _selectedReason;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cancel Order',
                    style: getTextStyle(
                      font: CustomFonts.obviously,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ebonyBlack,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Reason selection
              Text(
                'Why are you cancelling?',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ebonyBlack,
                ),
              ),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: CancellationReason.values.map((reason) {
                  final isSelected = _selectedReason == reason;
                  return ChoiceChip(
                    label: Text(reason.displayName),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedReason = selected ? reason : null;
                      });
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    backgroundColor: Colors.grey.shade100,
                    labelStyle: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 13.sp,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected ? AppColors.primary : Colors.black87,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 24.h),

              // Refund impact section
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.homeGrey,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Refund Details',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ebonyBlack,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildAmountRow(
                      'Order amount',
                      '₹${widget.eligibility.orderAmount.toStringAsFixed(2)}',
                    ),
                    if (widget.eligibility.cancellationFee > 0) ...[
                      SizedBox(height: 8.h),
                      _buildAmountRow(
                        'Cancellation fee',
                        '- ₹${widget.eligibility.cancellationFee.toStringAsFixed(2)}',
                        isDeduction: true,
                      ),
                    ] else if (widget.eligibility.isFeeWaived) ...[
                      SizedBox(height: 8.h),
                      Text(
                        'Cancellation fee waived',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                      ),
                    ],
                    SizedBox(height: 12.h),
                    Divider(height: 1, color: Colors.grey.shade400),
                    SizedBox(height: 12.h),
                    _buildAmountRow(
                      'You will get',
                      '₹${widget.eligibility.refundAmount.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Confirm button
              Obx(() {
                final isCancelling = _refundController.isCancelling;
                return SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: _selectedReason == null || isCancelling
                        ? null
                        : _handleCancellation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: isCancelling
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            widget.eligibility.cancellationFee > 0
                                ? 'Cancel with ₹${widget.eligibility.refundAmount.toStringAsFixed(0)} refund'
                                : 'Cancel & get ₹${widget.eligibility.refundAmount.toStringAsFixed(0)} refund',
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountRow(
    String label,
    String amount, {
    bool isDeduction = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: getTextStyle(
            font: CustomFonts.inter,
            fontSize: isTotal ? 14.sp : 13.sp,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: isTotal ? AppColors.ebonyBlack : const Color(0xFF7C7C7C),
          ),
        ),
        Text(
          amount,
          style: getTextStyle(
            font: CustomFonts.inter,
            fontSize: isTotal ? 16.sp : 13.sp,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: isTotal
                ? AppColors.primary
                : (isDeduction ? Colors.red : AppColors.ebonyBlack),
          ),
        ),
      ],
    );
  }

  Future<void> _handleCancellation() async {
    if (_selectedReason == null) return;

    final success = await _refundController.requestCancellation(
      orderId: widget.order.orderId,
      reason: _selectedReason!,
    );

    if (success) {
      Get.back(result: true); // Close bottom sheet and return success
    }
  }
}
