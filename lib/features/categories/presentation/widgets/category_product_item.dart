import 'package:flutter/material.dart';
import 'package:quikle_user/core/common/widgets/unified_product_card.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/home/data/models/shop_model.dart';

class CategoryProductItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final VoidCallback? onFavoriteToggle;
  final bool isGroceryCategory;
  final ShopModel? shop;

  const CategoryProductItem({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddToCart,
    this.onFavoriteToggle,
    this.isGroceryCategory = false,
    this.shop,
  });

  @override
  Widget build(BuildContext context) {
    return UnifiedProductCard(
      product: product,
      onTap: onTap,
      onAddToCart: onAddToCart,
      onFavoriteToggle: onFavoriteToggle,
      variant: ProductCardVariant.category,
      isGroceryCategory: isGroceryCategory,
      shop: shop,
    );
  }
}
