import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';
import 'package:quikle_user/features/categories/presentation/widgets/filter_bottom_sheet_enhanced.dart';

class MinimalSubcategoriesSection extends StatelessWidget {
  static double get kPreferredHeight => 120.h;

  final List<SubcategoryModel> subcategories;
  final SubcategoryModel? selectedSubcategory;
  final String categoryIconPath;
  final Function(SubcategoryModel?) onSubcategoryTap;
  final dynamic controller; // Controller for filter functionality

  const MinimalSubcategoriesSection({
    super.key,
    required this.categoryIconPath,
    required this.subcategories,
    required this.selectedSubcategory,
    required this.onSubcategoryTap,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (subcategories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: kPreferredHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            // padding: EdgeInsets.symmetric(vertical: 4.h),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 3, color: Color(0xFFEDEDED)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subcategories',
                  style: getTextStyle(
                    font: CustomFonts.obviously,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ebonyBlack,
                  ),
                ),
                _buildFilterButton(),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          SizedBox(
            height: 60.h,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,

              primary: false,
              padding: EdgeInsets.zero,
              itemCount: subcategories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Show the selected subcategory's icon at index 0 when available,
                  // otherwise fall back to the category icon. The logical selection
                  // state for "All" remains when selectedSubcategory == null.
                  final isSelected = selectedSubcategory == null;
                  final displayImagePath =
                      selectedSubcategory?.iconPath ?? categoryIconPath;

                  return GestureDetector(
                    onTap: () => onSubcategoryTap(null),
                    child: Container(
                      margin: EdgeInsets.only(right: 12.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 38.h,
                            width: 38.h,
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: _buildImage(displayImagePath),
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
                          width: 38.h,
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: _buildImage(subcategory.iconPath),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        SizedBox(
                          // width: 50.w,
                          child: Text(
                            subcategory.title,
                            textAlign: TextAlign.center,
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
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    // Check if it's a network URL
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[200],
            child: Center(
              child: SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.beakYellow,
                  ),
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          // Fallback to a placeholder icon
          return Container(
            color: Colors.grey[200],
            child: Image.asset(
              ImagePath.logo,
              fit: BoxFit.contain,
              // color: Colors.grey,
            ),
          );
        },
      );
    } else {
      // Use asset image for local paths
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: Icon(
              Icons.shopping_bag,
              size: 20.sp,
              color: AppColors.beakYellow,
            ),
          );
        },
      );
    }
  }

  Widget _buildFilterButton() {
    if (controller == null) {
      return const SizedBox.shrink();
    }

    return Obx(() {
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
    });
  }

  void _showFilterSheet() {
    Get.bottomSheet(
      FilterBottomSheetEnhanced(controller: controller),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }
}
