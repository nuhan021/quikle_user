import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';

class MinimalSubcategoriesSection extends StatelessWidget {
  final List<SubcategoryModel> subcategories;
  final SubcategoryModel? selectedSubcategory;
  final Function(SubcategoryModel) onSubcategoryTap;

  const MinimalSubcategoriesSection({
    super.key,
    required this.subcategories,
    required this.selectedSubcategory,
    required this.onSubcategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    if (subcategories.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ), // Reduced margins
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Text(
              'Subcategories',
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 12.sp, // Smaller font
                fontWeight: FontWeight.w500,
                color: AppColors.ebonyBlack,
              ),
            ),
          ),
          SizedBox(height: 4.h), // Reduced spacing
          SizedBox(
            height: 50.h, // Increased height to accommodate icon + text
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: subcategories.length,
              itemBuilder: (context, index) {
                final subcategory = subcategories[index];
                final isSelected = selectedSubcategory?.id == subcategory.id;

                return GestureDetector(
                  onTap: () => onSubcategoryTap(subcategory),
                  child: Container(
                    margin: EdgeInsets.only(right: 8.w),
                    child: Column(
                      children: [
                        Container(
                          height: 32.h, // Compact icon container
                          width: 32.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: isSelected
                                ? Border.all(
                                    color: AppColors.beakYellow,
                                    width: 2,
                                  )
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: .04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image.asset(
                              subcategory.iconPath,
                              width: 20.w,
                              height: 20.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          subcategory.title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize:
                                9.sp, // Very small font for compact layout
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
        ],
      ),
    );
  }
}
