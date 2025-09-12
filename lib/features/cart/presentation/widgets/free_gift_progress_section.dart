import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';

class FreeGiftAndProgressSection extends StatelessWidget {
  const FreeGiftAndProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Free gift for you!',
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.ebonyBlack,
              ),
            ),

            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.homeGrey,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icon box
                    Container(
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.card_giftcard,
                          color: Colors.red,
                          size: 40.sp,
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Vertical divider
                    VerticalDivider(
                      width: 1.w + 12.w, // keeps spacing
                      thickness: 1,
                      color: Colors.grey[400],
                    ),

                    SizedBox(width: 12.w),

                    // Details + Add
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'District Movie Voucher',
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.ebonyBlack,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            '\$12.00',
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ebonyBlack,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            '1 unit',
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.ebonyBlack,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Text(
                                'Free',
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.freeColor,
                                ),
                              ),
                              const Spacer(),
                              // Button
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 8.h,
                                  ),
                                  backgroundColor: AppColors.ebonyBlack,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                ),
                                onPressed: () {
                                  /* add action */
                                },
                                child: Text(
                                  'Add',
                                  style: getTextStyle(
                                    font: CustomFonts.inter,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.beakYellow,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Progress area (kept inside same card)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6.h,
                  child: LinearProgressIndicator(
                    value: 0.3,
                    backgroundColor: AppColors.featherGrey,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.beakYellow,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Image.asset(
                      ImagePath.lockIcon,
                      width: 20.sp,
                      height: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Add items worth more.',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.ebonyBlack,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
