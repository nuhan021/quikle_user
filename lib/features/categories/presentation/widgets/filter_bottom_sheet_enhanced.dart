import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/categories/data/models/filter_sort_models.dart';

class FilterBottomSheetEnhanced extends StatefulWidget {
  final dynamic
  controller; // Can be UnifiedCategoryController or CategoryProductsController

  const FilterBottomSheetEnhanced({super.key, required this.controller});

  @override
  State<FilterBottomSheetEnhanced> createState() =>
      _FilterBottomSheetEnhancedState();
}

class _FilterBottomSheetEnhancedState extends State<FilterBottomSheetEnhanced> {
  late List<String> tempSelectedFilters;
  late String tempSelectedSort;

  @override
  void initState() {
    super.initState();
    tempSelectedFilters = List.from(widget.controller.selectedFilters);
    tempSelectedSort = widget.controller.selectedSortOption.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Container(
              margin: EdgeInsets.only(top: 10.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ebonyBlack,
                    ),
                  ),
                  TextButton(
                    onPressed: _resetFilters,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Clear All',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.beakYellow,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1.h, color: const Color(0xFFE0E0E0)),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sort Section
                    Text(
                      'Sort By',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ebonyBlack,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildSortOptions(),
                    SizedBox(height: 24.h),
                    Divider(height: 1.h, color: const Color(0xFFE0E0E0)),
                    SizedBox(height: 16.h),
                    // Price Range Section
                    Text(
                      'Price Range',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ebonyBlack,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildQuickFilters(),
                  ],
                ),
              ),
            ),
            // Bottom Actions
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10.r,
                    offset: Offset(0, -2.h),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.beakYellow,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Apply Filters',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section titles removed per UX request (no visible "Price Range" header)

  Widget _buildSortOptions() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: SortOption.options.map((option) {
        final isSelected = tempSelectedSort == option.id;
        return GestureDetector(
          onTap: () {
            setState(() {
              tempSelectedSort = option.id;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.beakYellow.withOpacity(0.2)
                  : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? AppColors.beakYellow : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  option.label,
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.ebonyBlack
                        : const Color(0xFF666666),
                  ),
                ),
                if (isSelected) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.check_circle,
                    size: 16.sp,
                    color: AppColors.beakYellow,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickFilters() {
    // Render each quick filter on its own full-width row (one per row)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: FilterOption.quickFilters.map((filter) {
        final isSelected = tempSelectedFilters.contains(filter.id);
        return Column(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      tempSelectedFilters.remove(filter.id);
                    } else {
                      // Keep only one price filter at a time
                      tempSelectedFilters.removeWhere(
                        (f) =>
                            FilterOption.quickFilters.any((qf) => qf.id == f),
                      );
                      tempSelectedFilters.add(filter.id);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.beakYellow.withOpacity(0.2)
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.beakYellow
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          filter.label,
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 14.sp,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected
                                ? AppColors.ebonyBlack
                                : const Color(0xFF666666),
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          size: 16.sp,
                          color: AppColors.beakYellow,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],
        );
      }).toList(),
    );
  }

  void _resetFilters() {
    setState(() {
      tempSelectedFilters.clear();
      tempSelectedSort = 'relevance';
    });
  }

  void _applyFilters() {
    widget.controller.onFilterChanged(tempSelectedFilters);
    if (tempSelectedSort != widget.controller.selectedSortOption.value) {
      widget.controller.onSortChanged(tempSelectedSort);
    }
    Get.back();
  }
}
