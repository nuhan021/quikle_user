import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
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
        width: 70.w, // Fixed width to prevent overflow
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: isSelected
                  ? BoxDecoration(
                      color: const Color(0xFFFF6B35).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFFF6B35),
                        width: 2,
                      ),
                    )
                  : null,
              child: category.iconPath.isNotEmpty
                  ? Image.asset(
                      category.iconPath,
                      width: 30.w,
                      height: 30.h,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.category,
                          size: 30.sp,
                          color: isSelected
                              ? const Color(0xFFFF6B35)
                              : const Color(0xFFFF6B35),
                        );
                      },
                    )
                  : Icon(
                      Icons.category,
                      size: 30.sp,
                      color: isSelected
                          ? const Color(0xFFFF6B35)
                          : const Color(0xFFFF6B35),
                    ),
            ),
            const SizedBox(height: 6), // Reduced from 8 to 6
            Flexible(
              child: Text(
                category.title,
                style: getTextStyle(
                  font: CustomFonts.inter,
                  color: isSelected ? const Color(0xFFFF6B35) : Colors.black,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
