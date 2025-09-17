import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/common/widgets/unified_product_card.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/profile/controllers/favorites_controller.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';

import 'package:quikle_user/routes/app_routes.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoritesController>();
    final cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      appBar: UnifiedProfileAppBar(
        title: 'My Favorites',
        showActionButton: controller.favoriteProducts.isNotEmpty,
        actionText: 'Clear All',
        onActionPressed: () => _showClearAllDialog(controller),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.beakYellow),
          );
        }

        if (controller.favoriteProducts.isEmpty) {
          return _buildEmptyState();
        }

        return _buildFavoritesList(controller, cartController);
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border,
                size: 48.sp,
                color: AppColors.featherGrey,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'No Favorites Yet',
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.ebonyBlack,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Items you favorite will appear here. Start browsing and tap the heart icon to save your favorite products!',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.featherGrey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.offAllNamed(AppRoute.getMain());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.beakYellow,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                child: Text(
                  'Start Shopping',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList(
    FavoritesController controller,
    CartController cartController,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  '${controller.favoriteProducts.length} ${controller.favoriteProducts.length == 1 ? 'item' : 'items'}',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.featherGrey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          Obx(
            () => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 1.sp,
              ),
              itemCount: controller.favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = controller.favoriteProducts[index];

                return UnifiedProductCard(
                  product: product,
                  variant: ProductCardVariant.home,
                  onTap: () => _navigateToProductDetails(product),
                  onAddToCart: () => _addToCart(product, cartController),
                  onFavoriteToggle: () => _toggleFavorite(product, controller),
                  enableCartAnimation: true,
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  void _navigateToProductDetails(product) {
    Get.toNamed(AppRoute.getProductDetails(), arguments: product);
  }

  void _addToCart(product, CartController cartController) {
    cartController.addToCart(product);
  }

  void _toggleFavorite(product, FavoritesController controller) {
    controller.toggleFavorite(product);

    final isFavorite = controller.isFavorite(product.id);

    Get.snackbar(
      isFavorite ? 'Added to Favorites' : 'Removed from Favorites',
      isFavorite
          ? '${product.title} has been added to your favorites'
          : '${product.title} has been removed from your favorites',
      backgroundColor: isFavorite ? AppColors.success : AppColors.warning,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.all(16.w),
      borderRadius: 8.r,
    );
  }

  void _showClearAllDialog(FavoritesController controller) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Clear All Favorites',
          style: getTextStyle(
            font: CustomFonts.obviously,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to remove all items from your favorites? This action cannot be undone.',
          style: getTextStyle(
            font: CustomFonts.inter,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.clearAllFavorites();
              Get.back();
              Get.snackbar(
                'Favorites Cleared',
                'All favorites have been removed',
                backgroundColor: AppColors.warning,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
                margin: EdgeInsets.all(16.w),
                borderRadius: 8.r,
              );
            },
            child: Text(
              'Clear All',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
