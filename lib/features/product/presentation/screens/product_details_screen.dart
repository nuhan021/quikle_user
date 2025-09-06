import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/widgets/floating_cart_button.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/features/cart/presentation/widgets/you_may_like_section.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import '../../controllers/product_controller.dart';
import '../widgets/product_image_widget.dart';
import '../widgets/product_info_widget.dart';
import '../widgets/store_info_widget.dart';
import '../widgets/description_widget.dart';
import '../widgets/reviews_widget.dart';
import '../widgets/questions_widget.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadProductDetails(product);
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
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
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
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
                      //textAlign: TextAlign.center,
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
            Obx(
              () => controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(16.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Image
                                if (controller.product != null)
                                  ProductImageWidget(
                                    imagePath: controller.product!.imagePath,
                                    isFavorite: controller.product!.isFavorite,
                                    onFavoriteToggle:
                                        controller.onFavoriteToggle,
                                    onShare: controller.onShareProduct,
                                  ),

                                SizedBox(height: 24.h),

                                // Product Info
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
                                  StoreInfoWidget(shop: controller.shop!),

                                SizedBox(height: 24.h),
                                DescriptionWidget(
                                  description: controller.description,
                                ),

                                SizedBox(height: 24.h),

                                // Reviews
                                ReviewsWidget(
                                  rating: controller.product?.rating ?? 4.8,
                                  reviews: controller.reviews,
                                  ratingDistribution:
                                      controller.ratingDistribution,
                                  onSeeAll: controller.onSeeAllReviews,
                                  onWriteReview: controller.onWriteReview,
                                ),

                                SizedBox(height: 24.h),

                                // Questions
                                QuestionsWidget(
                                  questions: controller.questions,
                                  onAskQuestion: controller.onAskQuestion,
                                  onReply: controller.onReplyToQuestion,
                                ),

                                SizedBox(height: 24.h),
                                YouMayLikeSection(
                                  onAddToCart: (product) =>
                                      controller.addToCartFromSimilar(product),
                                  onFavoriteToggle: (product) => controller
                                      .onFavoriteToggleFromSimilar(product),
                                  onProductTap: (product) =>
                                      controller.onSimilarProductTap(product),
                                ),

                                SizedBox(height: 100.h),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.all(16.sp),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: SafeArea(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: controller.onAddToCart,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.shopping_bag_outlined,
                                      color: Colors.white,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Add To Cart',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),

            const FloatingCartButton(),
          ],
        ),
      ),
    );
  }
}
