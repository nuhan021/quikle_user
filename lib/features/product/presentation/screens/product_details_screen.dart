import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/core/common/widgets/custom_navbar.dart';
import 'package:quikle_user/core/common/widgets/floating_cart_button.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/navigation/navbar_navigation_helper.dart';
import 'package:quikle_user/features/cart/presentation/widgets/you_may_like_section.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import '../../controllers/product_controller.dart';
import '../widgets/product_image_widget.dart';
import '../widgets/product_info_widget.dart';
import '../widgets/store_info_widget.dart';
import '../widgets/description_widget.dart';
import '../widgets/reviews_widget.dart';
import '../widgets/questions_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _navController;
  final GlobalKey _navKey = GlobalKey();
  double _navBarHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _navController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _navController.dispose();
    super.dispose();
  }

  void _measureNavBarHeight() {
    final ctx = _navKey.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final h = box.size.height;
    if (h > 0 && (h - _navBarHeight).abs() > 0.5) {
      setState(() => _navBarHeight = h);
    }
  }

  void _onNavItemTapped(int index) {
    NavbarNavigationHelper.navigateToTab(index);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureNavBarHeight());
    const double cartMargin = 16.0;

    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardInset > 0;

    final controller = Get.put(ProductController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadProductDetails(widget.product);
    });

    return CartAnimationWrapper(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: AppColors.homeGrey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.h),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
                border: Border(
                  bottom: BorderSide(color: AppColors.gradientColor, width: 2),
                ),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.ebonyBlack,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        'Product Details',
                        style: getTextStyle(
                          font: CustomFonts.obviously,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.ebonyBlack,
                          lineHeight: 1.3,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.onShareProduct,
                      child: Icon(
                        Icons.share,
                        color: AppColors.ebonyBlack,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _navController,
                      builder: (context, _) {
                        final bottomInset = isKeyboardOpen
                            ? 0.0
                            : _navController.value * _navBarHeight;
                        return Padding(
                          padding: EdgeInsets.only(bottom: bottomInset),
                          child: Obx(
                            () => controller.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : SingleChildScrollView(
                                    padding: EdgeInsets.all(16.sp),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (controller.product != null)
                                          ProductImageWidget(
                                            imagePath:
                                                controller.product!.imagePath,
                                            isFavorite:
                                                controller.product!.isFavorite,
                                            onFavoriteToggle:
                                                controller.onFavoriteToggle,
                                          ),
                                        SizedBox(height: 24.h),
                                        if (controller.product != null)
                                          ProductInfoWidget(
                                            title: controller.product!.title,
                                            rating: controller.product!.rating,
                                            reviewCount: 500,
                                            price: controller.product!.price,
                                            originalPrice: '\$3.99',
                                            discount: '26% OFF',
                                          ),
                                        SizedBox(height: 16.h),
                                        if (controller.shop != null)
                                          StoreInfoWidget(
                                            shop: controller.shop!,
                                          ),
                                        SizedBox(height: 24.h),
                                        DescriptionWidget(
                                          description: controller.description,
                                        ),
                                        SizedBox(height: 16.h),
                                        _buildAddToCartButton(
                                          enabled:
                                              controller
                                                  .product
                                                  ?.canAddToCart ??
                                              true,
                                          onPressed: controller.onAddToCart,
                                        ),
                                        SizedBox(height: 24.h),
                                        ReviewsWidget(
                                          rating:
                                              controller.product?.rating ?? 4.8,
                                          reviews: controller.reviews,
                                          ratingDistribution:
                                              controller.ratingDistribution,
                                          onSeeAll: controller.onSeeAllReviews,
                                          onWriteReview:
                                              controller.onWriteReview,
                                        ),
                                        SizedBox(height: 24.h),
                                        QuestionsWidget(
                                          questions: controller.questions,
                                          onAskQuestion:
                                              controller.onAskQuestion,
                                          onReply: controller.onReplyToQuestion,
                                        ),
                                        SizedBox(height: 24.h),
                                        YouMayLikeSection(
                                          onAddToCart: (p) => controller
                                              .addToCartFromSimilar(p),
                                          onFavoriteToggle: (p) => controller
                                              .onFavoriteToggleFromSimilar(p),
                                          onProductTap: (p) =>
                                              controller.onSimilarProductTap(p),
                                        ),
                                        SizedBox(height: 24.h),
                                      ],
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              /// Navbar that hides on keyboard open
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 180),
                  offset: isKeyboardOpen
                      ? const Offset(0, 1)
                      : const Offset(0, 0),
                  child: KeyedSubtree(
                    key: _navKey,
                    child: CustomNavBar(
                      currentIndex: -1,
                      onTap: _onNavItemTapped,
                    ),
                  ),
                ),
              ),

              /// Floating Cart Button with proper inset
              AnimatedBuilder(
                animation: _navController,
                builder: (context, _) {
                  final inset =
                      (isKeyboardOpen
                          ? keyboardInset
                          : _navController.value * _navBarHeight) +
                      cartMargin;
                  return FloatingCartButton(bottomInset: inset);
                },
              ),
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
        onPressed: enabled ? onPressed : null,
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
