import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import '../../data/models/product_model.dart';
import 'product_item.dart';

class ProductSection extends StatelessWidget {
  final ProductSectionModel section;
  final Function(ProductModel) onProductTap;
  final Function(ProductModel) onAddToCart;
  final Function(ProductModel)? onFavoriteToggle;
  final VoidCallback onViewAllTap;
  final String? categoryIconPath;
  final String? categoryTitle;
  const ProductSection({
    super.key,
    required this.section,
    required this.onProductTap,
    required this.onAddToCart,
    required this.onViewAllTap,
    this.categoryIconPath,
    this.categoryTitle,
    this.onFavoriteToggle,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (categoryIconPath != null) ...[
                    Image.asset(categoryIconPath!, width: 28.w, height: 26.h),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    categoryTitle ?? 'Unknown Category',
                    style: getTextStyle(
                      font: CustomFonts.obviously,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ebonyBlack,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onViewAllTap,
                child: Text(
                  section.viewAllText,
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ebonyBlack,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.60.h,
            ),
            itemCount: 6,
            itemBuilder: (context, index) => ProductItem(
              product: section.products[index],
              onTap: () => onProductTap(section.products[index]),
              onAddToCart: () => onAddToCart(section.products[index]),
              onFavoriteToggle: onFavoriteToggle != null
                  ? () => onFavoriteToggle!(section.products[index])
                  : null,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
