import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';
import 'package:quikle_user/features/categories/presentation/widgets/filter_bottom_sheet_enhanced.dart';

class PopularItemsSection extends StatelessWidget {
  /// Fixed height for header delegate: title + horizontal list
  static double kPreferredHeight = 120.0.h;

  final List<SubcategoryModel> subcategories;
  final Function(SubcategoryModel?) onSubcategoryTap;
  final String title;
  final CategoryModel? category;
  final SubcategoryModel? selectedSubcategory;
  final dynamic controller; // Controller for filter functionality (optional)

  const PopularItemsSection({
    super.key,
    required this.subcategories,
    required this.onSubcategoryTap,
    this.title = 'Popular Items',
    this.category,
    this.selectedSubcategory,
    this.controller, // Make it optional
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
            padding: EdgeInsets.symmetric(vertical: 4.h),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 3, color: Color(0xFFEDEDED)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: getTextStyle(
                    font: CustomFonts.obviously,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ebonyBlack,
                  ),
                ),
                if (controller != null) _buildFilterButton(),
              ],
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
                            child: category!.iconPath.startsWith('http')
                                ? Image.network(
                                    category!.iconPath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Icon(Icons.category),
                                  )
                                : Image.asset(
                                    category!.iconPath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Icon(Icons.category),
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
                            child: sub.iconPath.startsWith('http')
                                ? Image.network(
                                    sub.iconPath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.shopping_bag),
                                  )
                                : Image.asset(
                                    sub.iconPath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.shopping_bag),
                                  ),
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

  Widget _buildFilterButton() {
    // Return empty widget if controller is not provided
    if (controller == null) {
      return const SizedBox.shrink();
    }

    final hasActiveFilters =
        controller.selectedFilters.isNotEmpty ||
        controller.selectedSortOption.value != 'relevance';
    final activeCount = controller.selectedFilters.length;

    return GestureDetector(
      onTap: () => _showFilterSheet(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: hasActiveFilters
              ? AppColors.beakYellow.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: hasActiveFilters
                ? AppColors.beakYellow
                : const Color(0xFFE0E0E0),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_list_rounded,
              size: 18.sp,
              color: hasActiveFilters
                  ? AppColors.ebonyBlack
                  : const Color(0xFF666666),
            ),
            SizedBox(width: 4.w),
            Text(
              'Filter',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: hasActiveFilters
                    ? AppColors.ebonyBlack
                    : const Color(0xFF666666),
              ),
            ),
            if (activeCount > 0) ...[
              SizedBox(width: 4.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.beakYellow,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  activeCount.toString(),
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showFilterSheet() {
    Get.bottomSheet(
      FilterBottomSheetEnhanced(controller: controller),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }
}
