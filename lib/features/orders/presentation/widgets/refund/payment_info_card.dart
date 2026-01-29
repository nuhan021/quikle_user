import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';

/// Widget displaying payment information
class PaymentInfoCard extends StatelessWidget {
  final OrderModel order;
  final double? totalAmount;

  const PaymentInfoCard({super.key, required this.order, this.totalAmount});

  @override
  Widget build(BuildContext context) {
    final paymentMethod = order.paymentMethod.name;
    final amountPaid = totalAmount ?? order.total;

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
          if (order.transactionId != null) ...[
            SizedBox(height: 12.h),
            _buildInfoRow(
              'Transaction ID',
              order.transactionId!,
              copyable: true,
            ),
          ],
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
}
