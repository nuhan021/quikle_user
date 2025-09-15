import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/category_model.dart';
import 'category_item.dart';

class CategoriesSection extends StatelessWidget {
  final List<CategoryModel> categories;
  final Function(CategoryModel) onCategoryTap;
  final String selectedCategoryId;
  final bool showTitle;

  const CategoriesSection({
    super.key,
    required this.categories,
    required this.onCategoryTap,
    this.selectedCategoryId = '0',
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBounded =
            constraints.hasBoundedHeight && constraints.maxHeight.isFinite;
        final double verticalPad = 16.0 * 2;
        final double fallbackListHeight = 63.h;
        final double listHeight = hasBounded
            ? math.max(0.0, constraints.maxHeight - verticalPad)
            : fallbackListHeight;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(color: Color(0x33CFCFCF)),
          child: SizedBox(
            height: listHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(
                    right: index < categories.length - 1 ? 24 : 0,
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
