import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/profile/payment/data/models/payment_method_model.dart';

class PaymentMethodListItem extends StatelessWidget {
  final PaymentMethodModel paymentMethod;
  final VoidCallback? onRemove;

  const PaymentMethodListItem({
    super.key,
    required this.paymentMethod,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A616161),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          if (paymentMethod.type.iconPath != null)
            Image.asset(paymentMethod.type.iconPath!, width: 24.w, height: 24.w)
          else
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: AppColors.homeGrey,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Icon(
                Iconsax.wallet_3,
                size: 16.sp,
                color: AppColors.textSecondary,
              ),
            ),

          SizedBox(width: 12.w),

          Expanded(
            child: Text(
              paymentMethod.type.displayName,
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF262D2C),
              ),
            ),
          ),

          // if (paymentMethod.isRemovable && onRemove != null)
          //   GestureDetector(
          //     onTap: onRemove,
          //     child: SizedBox(
          //       width: 18.w,
          //       height: 18.w,
          //       child: Icon(
          //         Iconsax.close_circle,
          //         size: 18.sp,
          //         color: const Color(0xFFE03E1A),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
