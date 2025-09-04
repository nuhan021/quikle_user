import 'package:flutter/material.dart';

class ProductModel {
  final String title;
  final String price;
  final IconData icon;

  const ProductModel({
    required this.title,
    required this.price,
    required this.icon,
  });
}

class ProductSectionModel {
  final String title;
  final String viewAllText;
  final List<ProductModel> products;

  const ProductSectionModel({
    required this.title,
    required this.viewAllText,
    required this.products,
  });
}
