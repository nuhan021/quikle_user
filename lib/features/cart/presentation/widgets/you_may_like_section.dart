import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/common/widgets/unified_product_card.dart';
import 'package:quikle_user/features/home/data/services/home_services.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';

class YouMayLikeSection extends StatefulWidget {
  final Function(ProductModel)? onAddToCart;
  final Function(ProductModel)? onFavoriteToggle;
  final Function(ProductModel)? onProductTap;

  const YouMayLikeSection({
    super.key,
    this.onAddToCart,
    this.onFavoriteToggle,
    this.onProductTap,
  });

  @override
  State<YouMayLikeSection> createState() => _YouMayLikeSectionState();
}

class _YouMayLikeSectionState extends State<YouMayLikeSection> {
  final HomeService _homeService = HomeService();
  List<ProductModel> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final allProducts = await _homeService.fetchAllProducts();
      allProducts.shuffle();
      setState(() {
        _products = allProducts.take(6).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You may like',
          style: getTextStyle(
            font: CustomFonts.obviously,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.ebonyBlack,
          ),
        ),

        SizedBox(height: 12.h),

        if (_isLoading)
          SizedBox(
            height: 200.h,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.ebonyBlack),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.75,
            ),
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];

              return UnifiedProductCard(
                product: product,
                onTap: () => widget.onProductTap?.call(product),
                onAddToCart: () => widget.onAddToCart?.call(product),
                onFavoriteToggle: () => widget.onFavoriteToggle?.call(product),
                variant: ProductCardVariant.youMayLike,
                isGroceryCategory: true,
              );
            },
          ),
      ],
    );
  }
}
