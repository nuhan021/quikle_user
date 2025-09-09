import 'package:quikle_user/features/home/data/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;

  CartItemModel({required this.product, required this.quantity});

  CartItemModel copyWith({ProductModel? product, int? quantity}) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  String get quantityDisplay {
    if (product.weight != null && product.weight!.isNotEmpty) {
      return '$quantity ${product.weight}';
    }
    return '$quantity ${quantity == 1 ? 'unit' : 'units'}';
  }

  double get totalPrice {
    final priceString = product.price.replaceAll(RegExp(r'[^\d.]'), '');
    final price = double.tryParse(priceString) ?? 0.0;
    return price * quantity;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemModel &&
          runtimeType == other.runtimeType &&
          product.id == other.product.id;

  @override
  int get hashCode => product.id.hashCode;
}
