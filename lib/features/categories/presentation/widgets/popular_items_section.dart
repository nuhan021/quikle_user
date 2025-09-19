import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';

class PopularItemsSection extends StatelessWidget {
  final List<SubcategoryModel> subcategories;
  final Function(SubcategoryModel) onSubcategoryTap;
  final String title;
  final SubcategoryModel? selectedSubcategory;

  const PopularItemsSection({
    super.key,
    required this.subcategories,
    required this.onSubcategoryTap,
    this.title = 'Popular Items',
    this.selectedSubcategory,
  });

  @override
  Widget build(BuildContext context) {
    if (subcategories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
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
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.ebonyBlack,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 60.h,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: subcategories.length,
            itemBuilder: (context, index) {
              final subcategory = subcategories[index];
              final isSelected = selectedSubcategory?.id == subcategory.id;
              return GestureDetector(
                onTap: () => onSubcategoryTap(subcategory),
                child: Container(
                  margin: EdgeInsets.only(right: 20.w),
                  child: Column(
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
                              color: Colors.grey.withValues(alpha: .04),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
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
                      Text(
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
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 4.h),
      ],
    );
  }
}
