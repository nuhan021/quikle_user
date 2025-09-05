import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';

class CartBottomSection extends StatelessWidget {
  final VoidCallback onPlaceOrder;
  final VoidCallback onPaymentMethodTap;

  const CartBottomSection({
    super.key,
    required this.onPlaceOrder,
    required this.onPaymentMethodTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(right: 8.w),
                child: Image.asset(
                  ImagePath.homeIcon,
                  width: 40.w,
                  height: 40.h,
                  // fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivering to Home',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.ebonyBlack,
                      ),
                    ),
                    Text(
                      'Aditya Singh, Anytime fitness....',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 14.sp,
                        color: Colors.grey[600]!,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 25.sp,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Change',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.beakYellow,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onPaymentMethodTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.ebonyBlack),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pay Using',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 20.sp,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: GestureDetector(
                  onTap: onPlaceOrder,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        'Place order',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.beakYellow,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
