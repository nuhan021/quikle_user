import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';

class PopularItemsSection extends StatelessWidget {
  /// Fixed height for header delegate: title + horizontal list
  static const double kPreferredHeight = 100.0;

  final List<SubcategoryModel> subcategories;
  final Function(SubcategoryModel?) onSubcategoryTap;
  final String title;
  final CategoryModel? category;
  final SubcategoryModel? selectedSubcategory;

  const PopularItemsSection({
    super.key,
    required this.subcategories,
    required this.onSubcategoryTap,
    this.title = 'Popular Items',
    this.category,
    this.selectedSubcategory,
  });

  @override
  Widget build(BuildContext context) {
    if (subcategories.isEmpty || category == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: kPreferredHeight,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.h),
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
          SizedBox(height: 8.h),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: subcategories.length + 1, // +1 for "All"
              itemBuilder: (context, index) {
                if (index == 0) {
                  final isSelected = selectedSubcategory == null;
                  return GestureDetector(
                    onTap: () => onSubcategoryTap(null),
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
                            child: Image.asset(
                              category!.iconPath,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'All',
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

                final sub = subcategories[index - 1];
                final isSelected = selectedSubcategory?.id == sub.id;
                return GestureDetector(
                  onTap: () => onSubcategoryTap(sub),
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
                            child: Image.asset(sub.iconPath, fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          sub.title,
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
        ],
      ),
    );
  }
}
