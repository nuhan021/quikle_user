import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/core/common/widgets/quantity_selector.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/home/data/models/shop_model.dart';
import 'package:quikle_user/features/profile/controllers/favorites_controller.dart';

enum ProductCardVariant { home, category, youMayLike, cart, horizontal }

class UnifiedProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onRemove;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final ProductCardVariant variant;
  final bool isGroceryCategory;
  final ShopModel? shop;
  final int? quantity;
  final bool enableCartAnimation;

  const UnifiedProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onAddToCart,
    this.onFavoriteToggle,
    this.onRemove,
    this.onIncrease,
    this.onDecrease,
    this.variant = ProductCardVariant.home,
    this.isGroceryCategory = false,
    this.shop,
    this.quantity,
    this.enableCartAnimation = true,
  });

  @override
  State<UnifiedProductCard> createState() => _UnifiedProductCardState();
}

class _UnifiedProductCardState extends State<UnifiedProductCard> {
  final GlobalKey _cartButtonKey = GlobalKey();
  final GlobalKey _imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(UnifiedProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _handleAddToCart() {
    if (widget.onAddToCart != null) {
      if (widget.enableCartAnimation) {
        try {
          Get.find<CartAnimationController>();
          _triggerCartAnimation();
        } catch (e) {}
      }
      widget.onAddToCart!();
    }
  }

  void _triggerCartAnimation() {
    final controller = Get.find<CartAnimationController>();

    final sourceBox =
        _imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (sourceBox == null) return;

    final topLeft = sourceBox.localToGlobal(Offset.zero);
    final center = Offset(
      topLeft.dx + sourceBox.size.width / 2,
      topLeft.dy + sourceBox.size.height / 2,
    );

    // Use the new improved animation method
    final startSize = sourceBox.size.shortestSide.clamp(28.0, 80.0);

    controller.addCartAnimation(
      imagePath: widget.product.imagePath,
      startPosition: center,
      startSize: startSize,
      fallbackTarget: Offset(
        MediaQuery.of(context).size.width - 48.w,
        MediaQuery.of(context).size.height - 120.h,
      ),
    );
  }

  double _cardAspectRatio(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    if (h >= 900) return 0.75;
    if (h >= 780) return 0.70;
    return 0.65;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.variant) {
      case ProductCardVariant.cart:
        return _buildCartCard();
      case ProductCardVariant.horizontal:
        return _buildHorizontalCard();
      default:
        return _buildVerticalCard();
    }
  }

  Widget _buildVerticalCard() {
    return GestureDetector(
      onTap: widget.onTap,
      child: AspectRatio(
        aspectRatio: _cardAspectRatio(context),
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
            //mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildImageSection(),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  widget.variant == ProductCardVariant.youMayLike ? 6.w : 6.w,
                  widget.variant == ProductCardVariant.youMayLike ? 6.w : 6.w,
                  widget.variant == ProductCardVariant.youMayLike ? 6.w : 6.w,
                  6.w, // tighter bottom padding
                ),

                child: _buildProductInfo(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    final imageHeight = 50.h;

    return Stack(
      children: [
        Container(
          key: _imageKey,
          height: imageHeight,
          width: double.infinity,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  widget.variant == ProductCardVariant.youMayLike ? 4.r : 4.r,
                ),
              ),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              widget.product.imagePath,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),

        // OTC Badge
        if (widget.product.isMedicine && widget.product.isOTC)
          Positioned(
            // top: widget.variant == ProductCardVariant.youMayLike ? 0.h : 0.h,
            left: 6.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppColors.grocery,
                borderRadius: BorderRadius.circular(3.r),
              ),
              child: Text(
                'OTC',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: widget.variant == ProductCardVariant.youMayLike
                      ? 8.sp
                      : 7.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        if (widget.onFavoriteToggle != null)
          Positioned(
            top: 0.h,
            right: 6.w,
            child: GestureDetector(
              onTap: widget.onFavoriteToggle,
              child: Obx(() {
                final isFavorite = FavoritesController.isProductFavorite(
                  widget.product.id,
                );
                return Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 20.sp,
                  color: isFavorite ? Colors.red : Colors.black54,
                );
              }),
            ),
          ),
      ],
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          widget.product.title,
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

        if (widget.variant == ProductCardVariant.category ||
            widget.variant == ProductCardVariant.youMayLike) ...[
          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 12),
              SizedBox(width: 2.w),
              Text(
                '${widget.product.rating}',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ebonyBlack,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(child: _buildCategorySpecificInfo()),
            ],
          ),
        ],

        // Urgent delivery option for medicine items only
        if (widget.product.isMedicine && widget.onAddToCart != null) ...[
          SizedBox(height: 6.h),
          _buildUrgentDeliveryOption(),
        ],

        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.product.price,
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.ebonyBlack,
              ),
            ),
            if (widget.onAddToCart != null) _buildCartSection(),
          ],
        ),
      ],
    );
  }

  Widget _buildCartSection() {
    return GetBuilder<CartController>(
      builder: (cartController) {
        final currentQuantity = cartController.getProductQuantity(
          widget.product,
        );
        final currentIsInCart = currentQuantity > 0;

        if (currentIsInCart) {
          return QuantitySelector(
            quantity: currentQuantity,
            onIncrease: () {
              cartController.addProductToCart(widget.product);
            },
            onDecrease: () {
              cartController.removeProductFromCart(widget.product);
            },
            fontSize: 12.sp,
            iconSize: 14.sp,
            enableCartAnimation: widget.enableCartAnimation,
            productImagePath: widget.product.imagePath,
          );
        } else {
          return _buildAddToCartButton();
        }
      },
    );
  }

  Widget _buildAddToCartButton() {
    return GestureDetector(
      key: _cartButtonKey,
      onTap: widget.product.canAddToCart ? _handleAddToCart : null,
      child: Container(
        //width: 24.w,
        height: 24.w,
        decoration: BoxDecoration(
          color: widget.product.canAddToCart
              ? Colors.transparent
              : Colors.grey.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(6.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Center(
          child: Image.asset(
            ImagePath.cartIcon,
            width: widget.variant == ProductCardVariant.youMayLike
                ? 22.w
                : null,
            height: widget.variant == ProductCardVariant.youMayLike
                ? 22.w
                : null,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            color: widget.product.canAddToCart ? null : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildUrgentDeliveryOption() {
    return GetBuilder<CartController>(
      builder: (cartController) {
        bool isUrgent = cartController.isProductUrgent(widget.product);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.red.shade400, width: 1.5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Urgent',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade600,
                ),
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: () {
                  if (cartController.isProductInCart(widget.product)) {
                    cartController.toggleProductUrgentStatus(widget.product);
                  } else {
                    cartController.addProductToCart(
                      widget.product,
                      isUrgent: true,
                    );
                    _triggerCartAnimation();
                  }
                },
                child: Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isUrgent ? Colors.red : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(3.r),
                    color: isUrgent ? Colors.red : Colors.transparent,
                  ),
                  child: isUrgent
                      ? Icon(Icons.check, size: 8.sp, color: Colors.white)
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategorySpecificInfo() {
    if (widget.isGroceryCategory) {
      return Row(
        children: [
          Icon(Icons.scale_outlined, color: AppColors.featherGrey, size: 10.w),
          SizedBox(width: 2.w),
          Flexible(
            child: Text(
              widget.product.weight ?? '1 piece',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 10.sp,
                color: AppColors.featherGrey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(Icons.access_time, color: AppColors.featherGrey, size: 10.w),
          SizedBox(width: 2.w),
          Flexible(
            child: Text(
              widget.shop?.deliveryTime ?? '30 Min',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 10.sp,
                color: AppColors.featherGrey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildCartCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Image.asset(
                  widget.product.imagePath,
                  // width: 40.w,
                  // height: 40.w,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: GestureDetector(
              onTap: widget.onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ebonyBlack,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    widget.product.price,
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ebonyBlack,
                    ),
                  ),
                  if (widget.quantity != null) ...[
                    SizedBox(height: 6.h),
                    Text(
                      'Total: \$ ${(widget.quantity! * _getNumericPrice()).toStringAsFixed(2)}',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.ebonyBlack,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (widget.onIncrease != null &&
              widget.onDecrease != null &&
              widget.onRemove != null)
            Column(
              children: [
                GestureDetector(
                  onTap: widget.onRemove,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Icon(Icons.close, size: 16.sp, color: Colors.red),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onDecrease,
                      child: Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: AppColors.ebonyBlack,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        '${widget.quantity ?? 1}',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ebonyBlack,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onIncrease,
                      child: Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: AppColors.ebonyBlack,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCard() {
    return Container(
      width: 120.w,
      margin: EdgeInsets.only(right: 12.w),
      child: _buildVerticalCard(),
    );
  }

  double _getNumericPrice() {
    final priceString = widget.product.price.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(priceString) ?? 0.0;
  }
}
