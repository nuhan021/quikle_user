import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';

class PopularItemsSection extends StatelessWidget {
  final List<SubcategoryModel> subcategories;
  final Function(SubcategoryModel) onSubcategoryTap;

  const PopularItemsSection({
    super.key,
    required this.subcategories,
    required this.onSubcategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Popular Items',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.ebonyBlack,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 120.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: subcategories.length,
            itemBuilder: (context, index) {
              final subcategory = subcategories[index];
              return Container(
                width: 100.w,
                margin: EdgeInsets.only(right: 16.w),
                child: GestureDetector(
                  onTap: () => onSubcategoryTap(subcategory),
                  child: Column(
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: AppColors.homeGrey,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.cardColor,
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.asset(
                            subcategory.iconPath,
                            width: 40.w,
                            height: 40.h,
                            fit: BoxFit.scaleDown,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        subcategory.title,
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.ebonyBlack,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
