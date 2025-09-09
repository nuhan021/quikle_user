import 'package:flutter/material.dart';
import 'package:quikle_user/core/common/widgets/unified_product_card.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final VoidCallback? onFavoriteToggle;

  const ProductItem({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddToCart,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return UnifiedProductCard(
      product: product,
      onTap: onTap,
      onAddToCart: onAddToCart,
      onFavoriteToggle: onFavoriteToggle,
      variant: ProductCardVariant.home,
    );
  }
}
