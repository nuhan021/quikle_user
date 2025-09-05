import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
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
        _products = allProducts.take(4).toList();
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
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
          SizedBox(height: 16.h),
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
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];

                return GestureDetector(
                  onTap: () => widget.onProductTap?.call(product),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cardColor,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12.r),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Image.asset(
                                    product.imagePath,
                                    width: 60.w,
                                    height: 60.w,
                                    fit: BoxFit.contain,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                                Positioned(
                                  top: 8.h,
                                  right: 8.w,
                                  child: GestureDetector(
                                    onTap: () =>
                                        widget.onFavoriteToggle?.call(product),
                                    child: SizedBox(
                                      width: 20.w,
                                      height: 20.h,
                                      child: Center(
                                        child: Image.asset(
                                          ImagePath.favoriteIcon,
                                          fit: BoxFit.cover,
                                          color: product.isFavorite
                                              ? Colors.red
                                              : AppColors.ebonyBlack.withValues(
                                                  alpha: 0.6,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: getTextStyle(
                                    font: CustomFonts.inter,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.ebonyBlack,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 12.sp,
                                    ),
                                    SizedBox(width: 2.w),
                                    Expanded(
                                      child: Text(
                                        '${product.rating.toStringAsFixed(1)} • ${product.weight ?? 'N/A'}',
                                        style: getTextStyle(
                                          font: CustomFonts.inter,
                                          fontSize: 12.sp,
                                          color: AppColors.ebonyBlack,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Text(
                                      product.price,
                                      style: getTextStyle(
                                        font: CustomFonts.inter,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () =>
                                          widget.onAddToCart?.call(product),
                                      child: Container(
                                        width: 30.w,
                                        height: 30.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            ImagePath.cartIcon,
                                            width: 24.w,
                                            height: 24.w,
                                            fit: BoxFit.cover,
                                            filterQuality: FilterQuality.high,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
