import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';
import 'package:quikle_user/core/common/widgets/floating_cart_button.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
// navbar navigation helper not needed on this screen after navbar removal
import 'package:quikle_user/features/home/data/models/product_model.dart';
import '../../controllers/product_controller.dart';
import '../widgets/product_image_widget.dart';
import '../widgets/product_info_widget.dart';
import '../widgets/store_info_widget.dart';
import '../widgets/description_widget.dart';
import '../widgets/reviews_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // Navbar removed: no animation controller or nav key required
  final GlobalKey _imageKey = GlobalKey();
  final GlobalKey _addToCartKey = GlobalKey();
  late final ProductController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadProductDetails(widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardInset > 0;
    final systemNavHeight = MediaQuery.of(context).viewPadding.bottom;

    return CartAnimationWrapper(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: AppColors.homeGrey,
          appBar: CommonAppBar(
            title: "Product Details",
            showBackButton: true,
            showNotification: false,
            showProfile: false,
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Obx(
                      () => controller.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              padding: EdgeInsets.all(16.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (controller.product != null)
                                    // wrap image with a key so we can
                                    // calculate its position for the
                                    // cart animation
                                    Container(
                                      key: _imageKey,
                                      child: ProductImageWidget(
                                        imagePath:
                                            controller.product!.imagePath,
                                        isFavorite:
                                            controller.product!.isFavorite,
                                        onFavoriteToggle:
                                            controller.onFavoriteToggle,
                                      ),
                                    ),
                                  SizedBox(height: 24.h),
                                  if (controller.product != null)
                                    ProductInfoWidget(
                                      title: controller.product!.title,
                                      rating: controller.product!.rating,
                                      reviewCount:
                                          controller.product!.reviewsCount,
                                      price: controller.product!.price,
                                      originalPrice:
                                          controller
                                              .product!
                                              .beforeDiscountPrice ??
                                          '',
                                      discount:
                                          '${controller.product!.discountPercentage}% OFF',
                                    ),
                                  SizedBox(height: 16.h),
                                  if (controller.shop != null)
                                    StoreInfoWidget(shop: controller.shop!),
                                  SizedBox(height: 24.h),
                                  DescriptionWidget(
                                    description: controller.description,
                                  ),
                                  SizedBox(height: 16.h),
                                  _buildAddToCartButton(
                                    enabled:
                                        controller.product?.canAddToCart ??
                                        true,
                                    onPressed: controller.onAddToCart,
                                  ),
                                  SizedBox(height: 24.h),
                                  ReviewsWidget(
                                    rating: controller.product?.rating ?? 4.8,
                                    reviews: controller.reviews,
                                    ratingDistribution:
                                        controller.ratingDistribution,
                                    onSeeAll: controller.onSeeAllReviews,
                                    onWriteReview: controller.onWriteReview,
                                  ),
                                  SizedBox(height: 24.h),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              ),

              // Floating cart: hide while keyboard is open to avoid UI jump
              if (!isKeyboardOpen)
                FloatingCartButton(bottomInset: systemNavHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddToCartButton({
    required bool enabled,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        key: _addToCartKey,
        onPressed: enabled
            ? () {
                // trigger cart animation from the Add To Cart button on this
                // page (product details should originate from the button)
                try {
                  final sourceBox =
                      _addToCartKey.currentContext?.findRenderObject()
                          as RenderBox?;
                  if (sourceBox != null && controller.product != null) {
                    final topLeft = sourceBox.localToGlobal(Offset.zero);
                    final center = Offset(
                      topLeft.dx + sourceBox.size.width / 2,
                      topLeft.dy + sourceBox.size.height / 2,
                    );
                    final startSize = sourceBox.size.shortestSide.clamp(
                      28.0,
                      80.0,
                    );
                    try {
                      final animController =
                          Get.find<CartAnimationController>();
                      animController.addCartAnimation(
                        imagePath: controller.product!.imagePath,
                        startPosition: center,
                        startSize: startSize,
                        fallbackTarget: Offset(
                          MediaQuery.of(context).size.width - 48.w,
                          MediaQuery.of(context).size.height - 120.h,
                        ),
                      );
                    } catch (e) {}
                  }
                } catch (e) {}

                if (onPressed != null) onPressed();
              }
            : null,
        icon: Icon(
          Icons.shopping_bag_outlined,
          color: Colors.white,
          size: 20.sp,
        ),
        label: Text(
          'Add To Cart',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? Colors.black : Colors.grey,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }
}
