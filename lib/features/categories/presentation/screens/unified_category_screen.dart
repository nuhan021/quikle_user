import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/features/categories/controllers/unified_category_controller.dart';
import 'package:quikle_user/features/categories/presentation/widgets/category_app_bar.dart';
import 'package:quikle_user/features/categories/presentation/widgets/search_and_filters_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/popular_items_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/product_grid_section.dart';
import 'package:quikle_user/features/home/presentation/widgets/banners/offer_banner.dart';
import 'package:quikle_user/features/home/presentation/widgets/products/product_item.dart';

class UnifiedCategoryScreen extends StatelessWidget {
  const UnifiedCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UnifiedCategoryController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.homeGrey,
        body: Column(
          children: [
            Obx(
              () => CategoryAppBar(
                title: controller.categoryTitle.value,
                onNotificationTap: () {},
                onProfileTap: () {},
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SearchAndFiltersSection(
                        onSearchTap: () {},
                        onSortTap: () {},
                        onFilterTap: () {},
                        onVoiceTap: () {},
                      ),
                      SizedBox(height: 24.h),

                      // Main categories/subcategories section
                      PopularItemsSection(
                        subcategories: controller.availableSubcategories,
                        onSubcategoryTap: controller.onSubcategoryTap,
                        title: controller.sectionTitle.value.isEmpty
                            ? 'Popular Items'
                            : controller.sectionTitle.value,
                      ),

                      // Show second row for grocery subcategories if main category is selected
                      if (controller.isGroceryCategory &&
                          controller.selectedMainCategory.value != null &&
                          controller.filterSubcategories.isNotEmpty)
                        PopularItemsSection(
                          subcategories: controller.filterSubcategories,
                          onSubcategoryTap: controller.onSubcategoryTap,
                          title:
                              'Select ${controller.selectedMainCategory.value!.title}',
                        ),

                      SizedBox(height: 22.h),
                      OfferBanner(),
                      SizedBox(height: 24.h),
                      _buildContent(controller),
                      SizedBox(height: 32.h),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(UnifiedCategoryController controller) {
    if (controller.showingAllProducts.value) {
      return _buildAllProductsView(controller);
    }

    if (controller.isGroceryCategory) {
      return _buildGroceryContentView(controller);
    }

    return _buildDefaultCategoryView(controller);
  }

  Widget _buildDefaultCategoryView(UnifiedCategoryController controller) {
    return Column(
      children: [
        if (!controller.isGroceryCategory)
          ProductGridSection(
            title: 'Featured ${controller.categoryTitle.value}',
            products: controller.displayProducts,
            onProductTap: controller.onProductTap,
            onAddToCart: controller.onAddToCart,
            onFavoriteToggle: controller.onFavoriteToggle,
            onViewAllTap: controller.showAllProducts,
            maxItems: 6,
            crossAxisCount: 3,
          ),

        if (!controller.isGroceryCategory) SizedBox(height: 12.h),

        ProductGridSection(
          title: controller.isGroceryCategory
              ? controller.productsTitle.value
              : 'Recommended for You',
          products: controller.displayProducts,
          onProductTap: controller.onProductTap,
          onAddToCart: controller.onAddToCart,
          onFavoriteToggle: controller.onFavoriteToggle,
          onViewAllTap: controller.showAllProducts,
          maxItems: controller.isGroceryCategory ? 12 : 6,
          crossAxisCount: 2,
        ),
      ],
    );
  }

  Widget _buildGroceryContentView(UnifiedCategoryController controller) {
    // Only show products if subcategory is selected and products exist
    if (controller.selectedSubcategory.value != null &&
        controller.displayProducts.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ProductGridSection(
          title: controller.productsTitle.value,
          products: controller.displayProducts,
          onProductTap: controller.onProductTap,
          onAddToCart: controller.onAddToCart,
          onFavoriteToggle: controller.onFavoriteToggle,
          showViewAll: false,
          maxItems: controller.displayProducts.length,
          crossAxisCount: 2,
        ),
      );
    }

    // Show message if no products or selections not complete
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Text(
          controller.selectedMainCategory.value == null
              ? 'Please select a category above'
              : controller.selectedSubcategory.value == null
              ? 'Please select a subcategory above'
              : 'No products available',
          style: TextStyle(color: AppColors.featherGrey, fontSize: 16.sp),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildAllProductsView(UnifiedCategoryController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom header without the ProductGridSection border issue
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 3, color: Color(0xFFEDEDED)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${controller.categoryTitle.value} - All Items',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ebonyBlack,
                  ),
                ),
                GestureDetector(
                  onTap: controller.showAllProducts,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.beakYellow,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      'Back to Sections',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Direct GridView without ProductGridSection wrapper to avoid border issues
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.h,
            ),
            itemCount: controller.displayProducts.length,
            itemBuilder: (context, index) {
              final product = controller.displayProducts[index];
              return ProductItem(
                product: product,
                onTap: () => controller.onProductTap(product),
                onAddToCart: () => controller.onAddToCart(product),
                onFavoriteToggle: () => controller.onFavoriteToggle(product),
              );
            },
          ),
        ],
      ),
    );
  }
}
