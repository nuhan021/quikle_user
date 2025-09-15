import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import '../../../data/models/category_model.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;
  final bool isSelected;

  const CategoryItem({
    super.key,
    required this.category,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 50.w,
        // ensure cell is tall enough for icon + gap + text
        height: 44.h + 6.h + 16.h, // ≈66h total, adjust 16.h if font bigger
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 44.w,
              height: 44.h,
              child: category.iconPath.isNotEmpty
                  ? Image.asset(
                      category.iconPath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.category,
                          size: 30.sp,
                          color: const Color(0xFFFF6B35),
                        );
                      },
                    )
                  : Icon(
                      Icons.category,
                      size: 30.sp,
                      color: const Color(0xFFFF6B35),
                    ),
            ),
            SizedBox(height: 6.h),
            Text(
              category.title,
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 12.sp,
                color: AppColors.ebonyBlack,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
