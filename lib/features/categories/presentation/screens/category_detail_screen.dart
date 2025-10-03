import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/core/common/widgets/floating_cart_button.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/categories/controllers/category_detail_controller.dart';
import 'package:quikle_user/features/categories/presentation/widgets/popular_items_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/product_grid_section.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryDetailController());

    return CartAnimationWrapper(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.ebonyBlack),
            onPressed: () => Get.back(),
          ),
          title: Obx(
            () => Text(
              controller.categoryTitle.value,
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.ebonyBlack,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    if (controller.popularSubcategories.isNotEmpty) ...[
                      PopularItemsSection(
                        subcategories: controller.popularSubcategories,
                        onSubcategoryTap: controller.onSubcategoryTap,
                      ),
                      SizedBox(height: 24.h),
                    ],

                    if (controller.recommendedProducts.isNotEmpty) ...[
                      ProductGridSection(
                        title: 'Recommended for You',
                        categoryName: controller.categoryTitle.value,
                        products: controller.recommendedProducts,
                        onProductTap: controller.onProductTap,
                        onAddToCart: controller.onAddToCart,
                        onFavoriteToggle: controller.onFavoriteToggle,
                        maxItems: 8,
                        crossAxisCount: 2,
                      ),
                    ],

                    SizedBox(height: 24.h),
                  ],
                ),
              ),

              const FloatingCartButton(),
            ],
          );
        }),
      ),
    );
  }
}
