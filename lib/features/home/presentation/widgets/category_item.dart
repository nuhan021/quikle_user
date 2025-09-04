import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import '../../data/models/category_model.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const CategoryItem({super.key, required this.category, required this.onTap});

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
            const SizedBox(height: 6), // Reduced from 8 to 6
            Flexible(
              child: Text(
                category.title,
                style: getTextStyle(
                  font: CustomFonts.inter,
                  color: Colors.black,
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
