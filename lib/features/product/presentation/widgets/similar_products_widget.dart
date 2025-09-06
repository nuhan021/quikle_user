import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/home/presentation/widgets/products/product_item.dart';

class SimilarProductsWidget extends StatelessWidget {
  final List<ProductModel> products;
  final Function(ProductModel) onProductTap;

  const SimilarProductsWidget({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You may like',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Container(
                width: 120.w,
                margin: EdgeInsets.only(right: 12.w),
                child: ProductItem(
                  product: products[index],
                  onTap: () => onProductTap(products[index]),
                  onAddToCart: () {},
                  onFavoriteToggle: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
