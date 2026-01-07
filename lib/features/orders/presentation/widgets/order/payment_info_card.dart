import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';

class PaymentInfoCard extends StatelessWidget {
  final OrderModel order;

  const PaymentInfoCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
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
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.ebonyBlack,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.payment, size: 20.sp, color: AppColors.beakYellow),
              SizedBox(width: 8.w),
              Text(
                _getPaymentMethodDisplayName(),
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ebonyBlack,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodDisplayName() {
    switch (order.paymentMethod.type.name) {
      case 'cashOnDelivery':
        return 'Cash on Delivery';
      case 'googlePay':
        return 'Google Pay';
      case 'paytm':
        return 'Paytm';
      case 'phonePe':
        return 'PhonePe';
      case 'razorpay':
        return 'Razorpay';
      case 'cashfree':
        return 'Cashfree';
      case 'wallet':
        return 'Wallet';
      default:
        return 'Unknown Payment Method';
    }
  }
}
