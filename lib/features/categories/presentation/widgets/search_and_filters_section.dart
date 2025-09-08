import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';

class SearchAndFiltersSection extends StatelessWidget {
  final Function(String)? onSearchChanged;
  final VoidCallback? onSortTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onVoiceTap;
  final String searchHint;
  final TextEditingController? searchController;

  const SearchAndFiltersSection({
    super.key,
    this.onSearchChanged,
    this.onSortTap,
    this.onFilterTap,
    this.onVoiceTap,
    this.searchHint = 'Search products...',
    this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 16.w),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: onSearchChanged,
                          decoration: InputDecoration(
                            hintText: searchHint,
                            hintStyle: getTextStyle(
                              font: CustomFonts.manrope,
                              fontWeight: FontWeight.w500,
                              color: AppColors.featherGrey,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          style: getTextStyle(
                            font: CustomFonts.manrope,
                            fontWeight: FontWeight.w500,
                            color: AppColors.ebonyBlack,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Image.asset(
                          ImagePath.voiceIcon,
                          width: 20.w,
                          height: 20.h,
                        ),
                        onPressed: onVoiceTap,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: AppColors.beakYellow,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    Iconsax.search_normal,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    // Search functionality can be triggered here if needed
                    // For now, the search is handled by onChanged in TextField
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),
          Row(
            children: [
              _FilterButton(text: 'Sort', icon: Iconsax.sort, onTap: onSortTap),
              SizedBox(width: 8.w),
              _FilterButton(
                text: 'Filter',
                icon: Iconsax.filter,
                onTap: onFilterTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onTap;

  const _FilterButton({required this.text, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18.sp, color: Colors.black),
            SizedBox(width: 4.w),
            Text(
              text,
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
