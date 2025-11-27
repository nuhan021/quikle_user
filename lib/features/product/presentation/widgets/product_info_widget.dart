import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';

class ProductInfoWidget extends StatelessWidget {
  final String title;
  final double rating;
  final int reviewCount;
  final String price;
  final String originalPrice;
  final String discount;

  const ProductInfoWidget({
    super.key,
    required this.title,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.originalPrice,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = price != originalPrice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getTextStyle(
            font: CustomFonts.obviously,
            fontSize: 20.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.ebonyBlack,
          ),
        ),
        SizedBox(height: 8.h),

        Row(
          children: [
            Icon(Icons.star, color: Colors.orange, size: 16.sp),
            SizedBox(width: 4.w),
            Text(
              '$rating',
              style: getTextStyle(
                font: CustomFonts.inter,
                color: AppColors.ebonyBlack,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              '• $reviewCount reviews',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontWeight: FontWeight.w300,
                color: AppColors.ebonyBlack,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        Row(
          children: [
            Text(
              price,
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.ebonyBlack,
              ),
            ),
            if (hasDiscount) ...[
              SizedBox(width: 8.w),
              Text(
                originalPrice,
                style:
                    getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.featherGrey,
                    ).copyWith(
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.featherGrey,
                      decorationThickness: 1.5,
                    ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                child: Text(
                  discount,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.beakYellow,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
