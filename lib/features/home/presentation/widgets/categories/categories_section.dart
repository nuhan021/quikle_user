
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/category_model.dart';
import 'category_item.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({
    super.key,
    required this.categories,
    required this.onCategoryTap,
    this.selectedCategoryId = '0',
    this.showTitle = true,
  });

  final List<CategoryModel> categories;
  final Function(CategoryModel) onCategoryTap;
  final String selectedCategoryId;
  final bool showTitle;
  static double get kHeight => 70.h;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double verticalPad = 16 * 2;
        final bool hasBounded =
            constraints.hasBoundedHeight && constraints.maxHeight.isFinite;

        // Never give less than one item’s height.

        final double listHeight = hasBounded
            ? math.max(kHeight, constraints.maxHeight - verticalPad)
            : kHeight;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: const BoxDecoration(color: Color(0x33CFCFCF)),
          child: SizedBox(
            height: listHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(
                    right: index < categories.length - 1 ? 24.w : 0,
                  ),
                  child: CategoryItem(
                    category: categories[index],
                    onTap: () => onCategoryTap(categories[index]),
                    isSelected: categories[index].id == selectedCategoryId,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
