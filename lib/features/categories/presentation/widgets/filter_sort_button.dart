import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/categories/presentation/widgets/filter_bottom_sheet_enhanced.dart';
import 'package:quikle_user/features/categories/presentation/widgets/sort_bottom_sheet.dart';

class FilterSortButton extends StatelessWidget {
  final dynamic
  controller; // Can be UnifiedCategoryController or CategoryProductsController

  const FilterSortButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasActiveFilters =
          controller.selectedFilters.isNotEmpty ||
          controller.selectedSortOption.value != 'relevance';

      final activeCount = controller.selectedFilters.length;

      return Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 8.h),
        child: Row(
          children: [
            // Sort Button
            Expanded(
              child: _buildButton(
                icon: Icons.sort_rounded,
                label: _getSortLabel(controller.selectedSortOption.value),
                onTap: () => _showSortSheet(context),
                isActive: controller.selectedSortOption.value != 'relevance',
              ),
            ),
            SizedBox(width: 8.w),
            // Filter Button
            Expanded(
              child: _buildButton(
                icon: Icons.filter_list_rounded,
                label: 'Filter',
                badge: activeCount > 0 ? activeCount.toString() : null,
                onTap: () => _showFilterSheet(context),
                isActive: hasActiveFilters,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    String? badge,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.beakYellow.withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isActive ? AppColors.beakYellow : const Color(0xFFE0E0E0),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon removed as requested — show label only
              Flexible(
                child: Text(
                  label,
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: isActive
                        ? AppColors.ebonyBlack
                        : const Color(0xFF666666),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (badge != null) ...[
                SizedBox(width: 4.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.beakYellow,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    badge,
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
      ),
    );
  }

  String _getSortLabel(String sortOption) {
    switch (sortOption) {
      case 'price_low_high':
        return 'Price ↑';
      case 'price_high_low':
        return 'Price ↓';
      case 'rating':
        return 'Rating';
      case 'popularity':
        return 'Popular';
      case 'newest':
        return 'Newest';
      case 'discount':
        return 'Discount';
      default:
        return 'Sort';
    }
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SortBottomSheet(controller: controller),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheetEnhanced(controller: controller),
    );
  }
}
