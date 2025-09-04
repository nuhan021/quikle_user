import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import 'product_item.dart';

class ProductSection extends StatelessWidget {
  final ProductSectionModel section;
  final Function(ProductModel) onProductTap;
  final Function(ProductModel) onAddToCart;
  final VoidCallback onViewAllTap;

  const ProductSection({
    super.key,
    required this.section,
    required this.onProductTap,
    required this.onAddToCart,
    required this.onViewAllTap,
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
              Text(
                section.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: onViewAllTap,
                child: Text(
                  section.viewAllText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFF6B35),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 6,
            itemBuilder: (context, index) => ProductItem(
              product: section.products[index],
              onTap: () => onProductTap(section.products[index]),
              onAddToCart: () => onAddToCart(section.products[index]),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
