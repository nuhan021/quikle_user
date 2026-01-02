import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/common/widgets/unified_product_card.dart';
import 'package:quikle_user/core/services/suggested_products_service.dart';
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
  late final SuggestedProductsService _suggestedService;

  @override
  void initState() {
    super.initState();
    _suggestedService = SuggestedProductsService.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final products = _suggestedService.suggestedProducts;
      final isLoading = _suggestedService.isLoading;

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

          if (isLoading)
            SizedBox(
              height: 200.h,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.ebonyBlack),
              ),
            )
          else if (products.isEmpty)
            SizedBox(
              height: 200.h,
              child: Center(
                child: Text(
                  'No suggestions available',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 150.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return Container(
                    width: 120.w,
                    margin: EdgeInsets.only(right: 8.w),
                    child: UnifiedProductCard(
                      product: product,
                      onTap: () => widget.onProductTap?.call(product),
                      onAddToCart: () => widget.onAddToCart?.call(product),
                      onFavoriteToggle: () =>
                          widget.onFavoriteToggle?.call(product),
                      variant: ProductCardVariant.youMayLike,
                      isGroceryCategory: true,
                    ),
                  );
                },
              ),
            ),
        ],
      );
    });
  }
}
