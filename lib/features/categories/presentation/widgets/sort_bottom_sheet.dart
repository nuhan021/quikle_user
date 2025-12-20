import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/categories/data/models/filter_sort_models.dart';

class SortBottomSheet extends StatelessWidget {
  final dynamic
  controller; // Can be UnifiedCategoryController or CategoryProductsController

  const SortBottomSheet({super.key, required this.controller});

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
                    'Sort By',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ebonyBlack,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, size: 24.sp),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            // Sort Options
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: SortOption.options.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1.h, color: const Color(0xFFF0F0F0)),
              itemBuilder: (context, index) {
                final option = SortOption.options[index];

                return Obx(() {
                  final isSelected =
                      controller.selectedSortOption.value == option.id;

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        controller.onSortChanged(option.id);
                        Get.back();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        child: Row(
                          children: [
                            // Icon removed as requested — show label only
                            // Label
                            Expanded(
                              child: Text(
                                option.label,
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize: 15.sp,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? AppColors.ebonyBlack
                                      : const Color(0xFF333333),
                                ),
                              ),
                            ),
                            // Check Icon
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: AppColors.beakYellow,
                                size: 24.sp,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
