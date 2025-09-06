import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: ShapeDecoration(
          color: AppColors.textWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          shadows: [
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
            // product image box
            Stack(
              children: [
                Container(
                  height: 90.h,
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Center(
                    child: Image.asset(
                      product.imagePath,
                      width: 56.w,
                      height: 56.w,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
                // Favorite icon in top right corner
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: Center(
                        child: Image.asset(
                          ImagePath.favoriteIcon,
                          fit: BoxFit.cover,
                          color: product.isFavorite
                              ? Colors.red
                              : AppColors.ebonyBlack.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.ebonyBlack,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 4.h),

                    // Rating and Reviews Row
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 12),
                        SizedBox(width: 2.w),
                        Text(
                          '${product.rating}',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.ebonyBlack,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '(${product.reviewsCount})',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 10.sp,
                            color: AppColors.featherGrey,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.price,
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ebonyBlack,
                          ),
                        ),
                        GestureDetector(
                          onTap: onAddToCart,
                          child: Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: BoxDecoration(
                              //color: const Color(0xFFFF6B35),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Center(
                              child: Image.asset(
                                ImagePath.cartIcon,
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
  }
}
