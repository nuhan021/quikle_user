import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';

class GroceryItemsSection extends StatelessWidget {
  final List<SubcategoryModel> mainCategories;
  final List<SubcategoryModel> subcategories;
  final Function(SubcategoryModel) onMainCategoryTap;
  final Function(SubcategoryModel) onSubcategoryTap;
  final SubcategoryModel? selectedMainCategory;
  final String title;

  const GroceryItemsSection({
    super.key,
    required this.mainCategories,
    required this.subcategories,
    required this.onMainCategoryTap,
    required this.onSubcategoryTap,
    this.selectedMainCategory,
    this.title = 'Select Category',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 3, color: Color(0xFFEDEDED)),
              ),
            ),
            child: Text(
              title,
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.ebonyBlack,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),

        
        SizedBox(
          height: 83.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: mainCategories.length,
            itemBuilder: (context, index) {
              final category = mainCategories[index];
              final isSelected = selectedMainCategory?.id == category.id;

              return GestureDetector(
                onTap: () => onMainCategoryTap(category),
                child: Container(
                  width: 60.w,
                  margin: EdgeInsets.only(right: 35.w),
                  child: Column(
                    children: [
                      Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: isSelected
                              ? AppColors.beakYellow.withOpacity(0.3)
                              : null,
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.beakYellow,
                                  width: 2,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            category.iconPath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        category.title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.beakYellow
                              : AppColors.ebonyBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (selectedMainCategory != null && subcategories.isNotEmpty) ...[
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 3, color: Color(0xFFEDEDED)),
                ),
              ),
              child: Text(
                'Select ${selectedMainCategory!.title}',
                style: getTextStyle(
                  font: CustomFonts.obviously,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ebonyBlack,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          
          SizedBox(
            height: 83.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: subcategories.length,
              itemBuilder: (context, index) {
                final subcategory = subcategories[index];

                return GestureDetector(
                  onTap: () => onSubcategoryTap(subcategory),
                  child: Container(
                    width: 60.w,
                    margin: EdgeInsets.only(right: 35.w),
                    child: Column(
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.04),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image.asset(
                              subcategory.iconPath,
                              fit: BoxFit.contain,
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
                            fontSize: 14.sp,
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
