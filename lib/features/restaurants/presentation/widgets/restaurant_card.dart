import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/restaurants/data/models/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback onTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120.w,
        margin: EdgeInsets.only(right: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.ebonyBlack.withValues(alpha: 0.08),
              offset: const Offset(0, 1),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 70.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  topRight: Radius.circular(8.r),
                ),
                color: AppColors.homeGrey,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  topRight: Radius.circular(8.r),
                ),
                child: Image.asset(
                  restaurant.getDisplayImage(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.homeGrey,
                      child: const Icon(
                        Icons.restaurant,
                        color: AppColors.featherGrey,
                        size: 24,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      font: CustomFonts.obviously,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ebonyBlack,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    restaurant.cuisines.join(', '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.featherGrey,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 12.sp,
                            color: AppColors.beakYellow,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            restaurant.rating.toString(),
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.ebonyBlack,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        restaurant.deliveryTime,
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.featherGrey,
                        ),
                      ),
                    ],
                  ),
                  if (!restaurant.isOpen) ...[
                    SizedBox(height: 2.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                      child: Text(
                        'Closed',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
