import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/common/widgets/unified_product_card.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import '../../../data/models/product_model.dart';

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
    final visibleCount = math.min(section.products.length, 6);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            height: 32.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.homeGrey,
              border: Border(
                bottom: BorderSide(color: Color(0xFFEDEDED), width: 2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (categoryIconPath != null) ...[
                      Image.asset(categoryIconPath!, width: 28.w, height: 26.h),
                      SizedBox(width: 6.w),
                    ],
                    Text(
                      categoryTitle ?? 'Unknown Category',
                      style: getTextStyle(
                        font: CustomFonts.obviously,
                        fontSize: 16.sp,
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
          ),

          // Grid
          GridView.builder(
            padding: EdgeInsets.only(top: 12.h),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h,
              childAspectRatio: 0.75.sp,
              //childAspectRatio: categoryTitle == "Medicines" ? 0.6.sp : 0.75.sp,
            ),
            itemCount: visibleCount,
            itemBuilder: (context, index) {
              final product = section.products[index];
              return UnifiedProductCard(
                product: product,
                onTap: () => onProductTap(product),
                onAddToCart: () => onAddToCart(product),
                onFavoriteToggle: onFavoriteToggle != null
                    ? () => onFavoriteToggle!(product)
                    : null,
              );
            },
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
