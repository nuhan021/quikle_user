import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/home/data/models/shop_model.dart';
import 'package:quikle_user/features/categories/presentation/widgets/category_product_item.dart';

class ProductGridSection extends StatelessWidget {
  final String title;
  final List<ProductModel> products;
  final Function(ProductModel) onProductTap;
  final Function(ProductModel) onAddToCart;
  final Function(ProductModel) onFavoriteToggle;
  final VoidCallback? onViewAllTap;
  final int maxItems;
  final int crossAxisCount;
  final bool showViewAll;
  final bool isGroceryCategory;
  final Map<String, ShopModel>? shops;

  const ProductGridSection({
    super.key,
    required this.title,
    required this.products,
    required this.onProductTap,
    required this.onAddToCart,
    required this.onFavoriteToggle,
    this.onViewAllTap,
    this.maxItems = 6,
    this.crossAxisCount = 2,
    this.showViewAll = true,
    this.isGroceryCategory = false,
    this.shops,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    final displayProducts = products.take(maxItems).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 3, color: Color(0xFFEDEDED)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: getTextStyle(
                      font: CustomFonts.obviously,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ebonyBlack,
                    ),
                  ),
                  if (showViewAll && onViewAllTap != null)
                    GestureDetector(
                      onTap: onViewAllTap,
                      child: Text(
                        'View all',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: crossAxisCount == 3 ? 0.70 : 1.1,
            ),
            itemCount: displayProducts.length,
            itemBuilder: (context, index) {
              final product = displayProducts[index];
              final shop = shops?[product.shopId];

              return CategoryProductItem(
                product: product,
                onTap: () => onProductTap(product),
                onAddToCart: () => onAddToCart(product),
                onFavoriteToggle: () => onFavoriteToggle(product),
                isGroceryCategory: isGroceryCategory,
                shop: shop,
              );
            },
          ),
        ),
      ],
    );
  }
}
