import 'package:quikle_user/features/home/data/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;
  final bool isUrgent;

  CartItemModel({
    required this.product,
    required this.quantity,
    this.isUrgent = false,
  });

  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
    bool? isUrgent,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isUrgent: isUrgent ?? this.isUrgent,
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

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'isUrgent': isUrgent,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      isUrgent: json['isUrgent'] as bool? ?? false,
    );
  }
}
