import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';

class GroceryNavigationSection extends StatelessWidget {
  final VoidCallback onBackToCategories;
  final List<SubcategoryModel> subcategories;
  final Function(SubcategoryModel) onSubcategoryTap;

  const GroceryNavigationSection({
    super.key,
    required this.onBackToCategories,
    required this.subcategories,
    required this.onSubcategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back to All Categories button
        GestureDetector(
          onTap: onBackToCategories,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.beakYellow,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_back, color: Colors.black, size: 16),
                SizedBox(width: 4.w),
                Text(
                  'Back to Categories',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // Subcategories horizontal scroll
        if (subcategories.isNotEmpty) ...[
          Text(
            'Sub Categories',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.ebonyBlack,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 83.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: subcategories.length,
              itemBuilder: (context, index) {
                final subcategory = subcategories[index];
                return GestureDetector(
                  onTap: () => onSubcategoryTap(subcategory),
                  child: Container(
                    width: 60.w,
                    margin: EdgeInsets.only(right: 16.w),
                    child: Column(
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.04),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image.asset(
                              subcategory.iconPath,
                              width: 32.w,
                              height: 32.h,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          subcategory.title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.ebonyBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
