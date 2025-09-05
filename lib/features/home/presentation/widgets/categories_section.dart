import 'package:flutter/material.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import '../../data/models/category_model.dart';
import 'category_item.dart';

class CategoriesSection extends StatelessWidget {
  final List<CategoryModel> categories;
  final Function(CategoryModel) onCategoryTap;
  final int selectedCategoryId;

  const CategoriesSection({
    super.key,
    required this.categories,
    required this.onCategoryTap,
    this.selectedCategoryId = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'All Categories',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(color: Color(0x33CFCFCF)),
          child: SizedBox(
            height: 96,
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
        ),
      ],
    );
  }
}
