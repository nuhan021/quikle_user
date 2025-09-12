import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/core/common/widgets/floating_cart_button.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
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
              Obx(
                () => controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: EdgeInsets.all(16.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.product != null)
                              ProductImageWidget(
                                imagePath: controller.product!.imagePath,
                                isFavorite: controller.product!.isFavorite,
                                onFavoriteToggle: controller.onFavoriteToggle,
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
                              StoreInfoWidget(shop: controller.shop!),

                            SizedBox(height: 24.h),

                            
                            DescriptionWidget(
                              description: controller.description,
                            ),

                            SizedBox(height: 16.h),
                            if (!(controller.product?.isMedicine == true &&
                                controller.product!.isOTC))
                              _buildAddToCartButton(
                                enabled:
                                    (controller.product?.canAddToCart ?? true),
                                onPressed: controller.onAddToCart,
                              ),

                            if (controller.product?.isMedicine == true &&
                                controller.product!.isOTC)
                              Column(
                                children: [
                                  SizedBox(height: 24.h),
                                  Container(
                                    padding: EdgeInsets.all(16.sp),
                                    decoration: BoxDecoration(
                                      color:
                                          controller
                                              .product!
                                              .hasPrescriptionUploaded
                                          ? Colors.green.shade50
                                          : Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color:
                                            controller
                                                .product!
                                                .hasPrescriptionUploaded
                                            ? Colors.green
                                            : Colors.orange,
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              controller
                                                      .product!
                                                      .hasPrescriptionUploaded
                                                  ? Icons.check_circle
                                                  : Icons.warning,
                                              color:
                                                  controller
                                                      .product!
                                                      .hasPrescriptionUploaded
                                                  ? Colors.green
                                                  : Colors.orange,
                                              size: 20.sp,
                                            ),
                                            SizedBox(width: 8.w),
                                            Expanded(
                                              child: Text(
                                                controller
                                                        .product!
                                                        .hasPrescriptionUploaded
                                                    ? 'Prescription Uploaded'
                                                    : 'OTC Medicine - Prescription Required',
                                                style: getTextStyle(
                                                  font: CustomFonts.inter,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      controller
                                                          .product!
                                                          .hasPrescriptionUploaded
                                                      ? Colors.green.shade700
                                                      : Colors.orange.shade700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          controller
                                                  .product!
                                                  .hasPrescriptionUploaded
                                              ? 'Your prescription has been uploaded and verified. You can now add this OTC medicine to your cart.'
                                              : 'This is an Over-The-Counter (OTC) medicine that requires a valid prescription. Please upload your prescription to add this item to your cart.',
                                          style: getTextStyle(
                                            font: CustomFonts.inter,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.ebonyBlack
                                                .withValues(alpha: 0.7),
                                          ),
                                        ),
                                        SizedBox(height: 12.h),
                                        if (!controller
                                            .product!
                                            .hasPrescriptionUploaded)
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton.icon(
                                              onPressed: controller
                                                  .onUploadPrescription,
                                              icon: Icon(
                                                Icons.upload_file,
                                                size: 16.sp,
                                                color: Colors.white,
                                              ),
                                              label: Text(
                                                'Upload Prescription',
                                                style: getTextStyle(
                                                  font: CustomFonts.inter,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange,
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 8.h,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        6.r,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          )
                                        else
                                          Row(
                                            children: [
                                              Expanded(
                                                child: OutlinedButton.icon(
                                                  onPressed: controller
                                                      .onViewPrescription,
                                                  icon: Icon(
                                                    Icons.visibility,
                                                    size: 16.sp,
                                                    color:
                                                        Colors.green.shade700,
                                                  ),
                                                  label: Text(
                                                    'View Prescription',
                                                    style: getTextStyle(
                                                      font: CustomFonts.inter,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.green.shade700,
                                                    ),
                                                  ),
                                                  style: OutlinedButton.styleFrom(
                                                    side: const BorderSide(
                                                      color: Colors.green,
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 8.h,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6.r,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              OutlinedButton.icon(
                                                onPressed: controller
                                                    .onUploadPrescription,
                                                icon: Icon(
                                                  Icons.edit,
                                                  size: 16.sp,
                                                  color: Colors.green.shade700,
                                                ),
                                                label: Text(
                                                  'Update',
                                                  style: getTextStyle(
                                                    font: CustomFonts.inter,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        Colors.green.shade700,
                                                  ),
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                    color: Colors.green,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 8.h,
                                                    horizontal: 12.w,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6.r,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 12.h),
                                  _buildAddToCartButton(
                                    enabled:
                                        (controller
                                                .product
                                                ?.hasPrescriptionUploaded ==
                                            true) &&
                                        (controller.product?.canAddToCart ??
                                            true),
                                    onPressed: controller.onAddToCart,
                                  ),
                                ],
                              ),

                            SizedBox(height: 24.h),

                            ReviewsWidget(
                              rating: controller.product?.rating ?? 4.8,
                              reviews: controller.reviews,
                              ratingDistribution: controller.ratingDistribution,
                              onSeeAll: controller.onSeeAllReviews,
                              onWriteReview: controller.onWriteReview,
                            ),

                            SizedBox(height: 24.h),

                            QuestionsWidget(
                              questions: controller.questions,
                              onAskQuestion: controller.onAskQuestion,
                              onReply: controller.onReplyToQuestion,
                            ),

                            SizedBox(height: 24.h),
                            YouMayLikeSection(
                              onAddToCart: (p) =>
                                  controller.addToCartFromSimilar(p),
                              onFavoriteToggle: (p) =>
                                  controller.onFavoriteToggleFromSimilar(p),
                              onProductTap: (p) =>
                                  controller.onSimilarProductTap(p),
                            ),

                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
              ),

              
              const FloatingCartButton(),
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
          enabled ? 'Add To Cart' : 'Upload Prescription Required',
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
