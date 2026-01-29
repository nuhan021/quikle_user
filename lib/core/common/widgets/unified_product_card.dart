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
import 'package:quikle_user/features/profile/favorites/controllers/favorites_controller.dart';

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
      // First perform the add-to-cart action so that any widgets that appear
      // (like the floating cart button) are built. Then trigger the animation
      // in a post-frame callback so the cart position is available.
      widget.onAddToCart!();
      if (widget.enableCartAnimation) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            Get.find<CartAnimationController>();
            _triggerCartAnimation();
          } catch (e) {}
        });
      }
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
    final bool isMedicine = widget.product.isMedicine;

    return Container(
      decoration: ShapeDecoration(
        color: AppColors.textWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(flex: 3, fit: FlexFit.loose, child: _buildImageSection()),
          Flexible(
            flex: 3,
            fit: FlexFit.loose,
            child: Padding(
              padding: isMedicine
                  ? EdgeInsets.only(left: 6.w, right: 6.w)
                  : EdgeInsets.all(6.w),
              child: _buildProductInfo(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    final imagePath = widget.product.imagePath ?? '';
    final isNetworkImage =
        imagePath.isNotEmpty &&
        (imagePath.startsWith('http://') || imagePath.startsWith('https://'));

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Container(
            key: _imageKey,
            width: double.infinity,
            height: double.infinity,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: isNetworkImage
                ? Image.network(
                    imagePath,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Image.asset(ImagePath.logo, fit: BoxFit.contain),
                      );
                    },
                  )
                : (imagePath.isNotEmpty
                      ? Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        )
                      : Center(
                          child: Icon(
                            Icons.image,
                            size: 28.sp,
                            color: AppColors.featherGrey,
                          ),
                        )),
          ),

          if (widget.product.isMedicine && widget.product.isOTC)
            Positioned(
              top: 6.h,
              left: 6.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.grocery,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'OTC',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          if (widget.onFavoriteToggle != null)
            Positioned(
              top: 4.h,
              right: 4.w,
              child: GestureDetector(
                onTap: widget.onFavoriteToggle,
                child: Obx(() {
                  final isFavorite = FavoritesController.isProductFavorite(
                    widget.product.id,
                  );
                  return Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 18.sp,
                    color: isFavorite ? Colors.red : Colors.black54,
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            widget.product.title,
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.ebonyBlack,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        SizedBox(height: 6.h),

        if (widget.variant == ProductCardVariant.category ||
            widget.variant == ProductCardVariant.youMayLike) ...[
          if (widget.isGroceryCategory) ...[
            _buildCategorySpecificInfo(),
            SizedBox(height: 4.h),
          ] else ...[
            Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 10.sp),
                SizedBox(width: 2.w),
                Text(
                  '${widget.product.rating}',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ebonyBlack,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(child: _buildCategorySpecificInfo()),
              ],
            ),
            SizedBox(height: 4.h),
          ],
        ],

        if (widget.product.isMedicine && widget.onAddToCart != null) ...[
          _buildUrgentDeliveryOption(),
          SizedBox(height: 4.h),
        ],

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                widget.product.price,
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ebonyBlack,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.onAddToCart != null) ...[
              SizedBox(width: 4.w),
              _buildCartSection(),
            ],
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
            fontSize: 10.sp,
            iconSize: 12.sp,
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
        width: 22.w,
        height: 22.w,
        decoration: BoxDecoration(
          color: widget.product.canAddToCart
              ? Colors.transparent
              : Colors.grey.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(4.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          ImagePath.cartIcon,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          color: widget.product.canAddToCart ? null : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildUrgentDeliveryOption() {
    return GetBuilder<CartController>(
      builder: (cartController) {
        bool isUrgent = cartController.isProductUrgent(widget.product);

        return GestureDetector(
          onTap: () {
            if (cartController.isProductInCart(widget.product)) {
              cartController.toggleProductUrgentStatus(widget.product);
            } else {
              cartController.addProductToCart(widget.product, isUrgent: true);
              _triggerCartAnimation();
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isUrgent ? Colors.red.shade500 : Colors.white,
              border: Border.all(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 10.sp,
                  color: isUrgent ? Colors.white : Colors.red,
                ),
                Expanded(
                  child: Text(
                    'Urgent Delivery',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: isUrgent ? Colors.white : Colors.red,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategorySpecificInfo() {
    if (widget.isGroceryCategory) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              //widget.product.weight ?? '1 piece',
              '[ ${widget.product.weight ?? '1 piece'} ]',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time, color: AppColors.featherGrey, size: 9.sp),
          SizedBox(width: 2.w),
          Flexible(
            child: Text(
              widget.shop?.deliveryTime ?? '30 Min',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 8.sp,
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
                      'Total: ₹${(widget.quantity! * _getNumericPrice()).toStringAsFixed(2)}',
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
