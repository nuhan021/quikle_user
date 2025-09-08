import 'package:flutter/material.dart';
import 'package:quikle_user/core/common/widgets/unified_product_card.dart';
import '../../data/models/cart_item_model.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return UnifiedProductCard(
      product: cartItem.product,
      onTap: () {}, // Cart items don't need onTap navigation
      onIncrease: onIncrease,
      onDecrease: onDecrease,
      onRemove: onRemove,
      variant: ProductCardVariant.cart,
      quantity: cartItem.quantity,
    );
  }
}
