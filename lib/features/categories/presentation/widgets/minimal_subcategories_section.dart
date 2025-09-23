import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';

class MinimalSubcategoriesSection extends StatelessWidget {
  final List<SubcategoryModel> subcategories;
  final SubcategoryModel? selectedSubcategory;
  final String categoryIconPath;
  final Function(SubcategoryModel?) onSubcategoryTap;

  const MinimalSubcategoriesSection({
    super.key,
    required this.categoryIconPath,
    required this.subcategories,
    required this.selectedSubcategory,
    required this.onSubcategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    if (subcategories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✔ Reduced vertical padding under header
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 4.h), // was 8.h
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 3, color: Color(0xFFEDEDED)),
            ),
          ),
          child: Text(
            'Subcategories',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.ebonyBlack,
            ),
          ),
        ),

        // (Optional) keep it minimal; remove or keep tiny spacing
        SizedBox(height: 4.h), // was 6.h
        // ✔ Fixed height, no hidden ListView padding, non-primary
        SizedBox(
          height: 60.h, // was 65.h
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            primary: false,
            padding: EdgeInsets.zero,
            itemCount: subcategories.length + 1, // +1 for "All" option
            itemBuilder: (context, index) {
              // First item is "All"
              if (index == 0) {
                final isSelected = selectedSubcategory == null;
                return GestureDetector(
                  onTap: () => onSubcategoryTap(null),
                  child: Container(
                    margin: EdgeInsets.only(right: 12.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 38.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: isSelected
                                ? Border.all(
                                    color: AppColors.beakYellow,
                                    width: 2,
                                  )
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: .08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            categoryIconPath,
                            fit: BoxFit.cover,
                            //size: 20.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'All',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 12.sp,
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
              }

              // Remaining items are subcategories
              final subcategory = subcategories[index - 1];
              final isSelected = selectedSubcategory?.id == subcategory.id;

              return GestureDetector(
                onTap: () => onSubcategoryTap(subcategory),
                child: Container(
                  margin: EdgeInsets.only(right: 12.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 38.h,
                        //width: 38.h, // ensures consistent chip size
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.beakYellow,
                                  width: 2,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: .08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            subcategory.iconPath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                        //width: 56.w, // keeps label on one line nicely
                        child: Text(
                          subcategory.title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppColors.beakYellow
                                : AppColors.ebonyBlack,
                          ),
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
    );
  }
}
