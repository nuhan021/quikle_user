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
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Text(
              'Subcategories',
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.ebonyBlack,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          SizedBox(
            height: 70.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: subcategories.length,
              itemBuilder: (context, index) {
                final subcategory = subcategories[index];
                final isSelected = selectedSubcategory?.id == subcategory.id;

                return GestureDetector(
                  onTap: () => onSubcategoryTap(subcategory),
                  child: Container(
                    margin: EdgeInsets.only(right: 12.w),
                    child: Column(
                      children: [
                        Container(
                          height: 48.h,
                          width: 48.w,
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
                              width: 38.w,
                              height: 38.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          subcategory.title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
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
