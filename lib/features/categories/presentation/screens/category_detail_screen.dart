import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import 'package:quikle_user/features/categories/controllers/category_detail_controller.dart';
import 'package:quikle_user/features/categories/presentation/widgets/popular_items_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/featured_products_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/recommended_products_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/subcategory_grid_section.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryDetailController());

    return Scaffold(
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

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              // Popular Items Section
              if (controller.popularSubcategories.isNotEmpty) ...[
                PopularItemsSection(
                  subcategories: controller.popularSubcategories,
                  onSubcategoryTap: controller.onSubcategoryTap,
                ),
                SizedBox(height: 24.h),
              ],

              // All Subcategories Section (for groceries)
              if (controller.allSubcategories.isNotEmpty) ...[
                SubcategoryGridSection(
                  title: 'All Categories',
                  subcategories: controller.allSubcategories,
                  onSubcategoryTap: controller.onSubcategoryTap,
                ),
                SizedBox(height: 24.h),
              ],

              // Featured Products Section
              if (controller.featuredProducts.isNotEmpty) ...[
                FeaturedProductsSection(
                  products: controller.featuredProducts,
                  onProductTap: controller.onProductTap,
                  onAddToCart: controller.onAddToCart,
                  onFavoriteToggle: controller.onFavoriteToggle,
                ),
                SizedBox(height: 24.h),
              ],

              // Recommended Products Section
              if (controller.recommendedProducts.isNotEmpty) ...[
                RecommendedProductsSection(
                  products: controller.recommendedProducts,
                  onProductTap: controller.onProductTap,
                  onAddToCart: controller.onAddToCart,
                  onFavoriteToggle: controller.onFavoriteToggle,
                ),
              ],

              SizedBox(height: 24.h),
            ],
          ),
        );
      }),
    );
  }
}
