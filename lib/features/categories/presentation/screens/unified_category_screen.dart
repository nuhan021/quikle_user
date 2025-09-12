import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/core/common/widgets/floating_cart_button.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/features/categories/controllers/unified_category_controller.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';
import 'package:quikle_user/features/categories/presentation/widgets/search_and_filters_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/popular_items_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/product_grid_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/sort_bottom_sheet.dart';
import 'package:quikle_user/features/categories/presentation/widgets/filter_bottom_sheet.dart';
import 'package:quikle_user/features/categories/presentation/widgets/category_product_item.dart';
import 'package:quikle_user/features/restaurants/presentation/widgets/top_restaurants_section.dart';
import 'package:quikle_user/features/home/presentation/widgets/banners/offer_banner.dart';
import 'package:quikle_user/routes/app_routes.dart';

class UnifiedCategoryScreen extends StatelessWidget {
  const UnifiedCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UnifiedCategoryController());
    final searchController = TextEditingController();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: CartAnimationWrapper(
        child: Scaffold(
          backgroundColor: AppColors.homeGrey,
          body: Stack(
            children: [
              Column(
                children: [
                  Obx(
                    () => CommonAppBar(
                      title: controller.categoryTitle.value,
                      onNotificationTap: () =>
                          Get.toNamed(AppRoute.getNotificationSettings()),
                      onProfileTap: () => Get.toNamed(AppRoute.getMyProfile()),
                      onBackTap: () => Get.back(),
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
                              searchController: searchController,
                              onSearchChanged: controller.onSearchChanged,
                              onSortTap: () =>
                                  _showSortBottomSheet(context, controller),
                              onFilterTap: () =>
                                  _showFilterBottomSheet(context, controller),
                              onVoiceTap: () {},
                              searchHint:
                                  'Search in ${controller.categoryTitle.value}...',
                            ),
                            SizedBox(height: 24.h),

                            // Main categories section - always visible
                            PopularItemsSection(
                              subcategories: controller.isGroceryCategory
                                  ? controller.allCategories
                                  : controller.availableSubcategories,
                              onSubcategoryTap: controller.onSubcategoryTap,
                              title: controller.isGroceryCategory
                                  ? 'Categories'
                                  : controller.sectionTitle.value.isEmpty
                                  ? 'Popular Items'
                                  : controller.sectionTitle.value,
                              selectedSubcategory: controller.isGroceryCategory
                                  ? controller.selectedMainCategory.value
                                  : controller.selectedSubcategory.value,
                            ),

                            // Top Restaurants section - only for food category
                            if (controller.isFoodCategory &&
                                controller.showRestaurants.value &&
                                controller.topRestaurants.isNotEmpty) ...[
                              SizedBox(height: 24.h),
                              TopRestaurantsSection(
                                restaurants: controller.topRestaurants,
                                onRestaurantTap: controller.onRestaurantTap,
                                title: 'Top 25 Restaurants',
                              ),
                            ],

                            // Subcategories section - show for grocery when main category is selected
                            if (controller.isGroceryCategory &&
                                controller.selectedMainCategory.value != null &&
                                controller.filterSubcategories.isNotEmpty) ...[
                              SizedBox(height: 20.h),
                              PopularItemsSection(
                                subcategories: controller.filterSubcategories,
                                onSubcategoryTap: controller.onSubcategoryTap,
                                title:
                                    'Select ${controller.selectedMainCategory.value!.title}',
                                selectedSubcategory:
                                    controller.selectedSubcategory.value,
                              ),
                            ],

                            SizedBox(height: 26.h),
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
              // Floating Cart Button
              const FloatingCartButton(),
            ],
          ),
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
        // Show main product grid if products are available
        if (controller.displayProducts.isNotEmpty)
          ProductGridSection(
            title: controller.productsTitle.value,
            products: controller.displayProducts,
            onProductTap: controller.onProductTap,
            onAddToCart: controller.onAddToCart,
            onFavoriteToggle: controller.onFavoriteToggle,
            onViewAllTap: controller.showAllProducts,
            maxItems: 12,
            crossAxisCount: 2,
            isGroceryCategory: controller.isGroceryCategory,
            shops: controller.shops,
          ),

        // Show recommended products section for non-grocery categories
        if (!controller.isGroceryCategory &&
            controller.recommendedProducts.isNotEmpty) ...[
          SizedBox(height: 24.h),
          ProductGridSection(
            title: 'Recommended for You',
            products: controller.recommendedProducts,
            onProductTap: controller.onProductTap,
            onAddToCart: controller.onAddToCart,
            onFavoriteToggle: controller.onFavoriteToggle,
            maxItems: 8,
            crossAxisCount: 2,
            isGroceryCategory: controller.isGroceryCategory,
            shops: controller.shops,
          ),
        ],

        // Show message if no products available
        if (controller.displayProducts.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Text(
                'No products available',
                style: TextStyle(color: AppColors.featherGrey, fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGroceryContentView(UnifiedCategoryController controller) {
    // Show products if main category is selected
    if (controller.selectedMainCategory.value != null &&
        controller.displayProducts.isNotEmpty) {
      return ProductGridSection(
        title: controller.productsTitle.value,
        products: controller.displayProducts,
        onProductTap: controller.onProductTap,
        onAddToCart: controller.onAddToCart,
        onFavoriteToggle: controller.onFavoriteToggle,
        showViewAll: false,
        maxItems: controller.displayProducts.length,
        crossAxisCount: 2,
        isGroceryCategory: controller.isGroceryCategory,
        shops: controller.shops,
      );
    }

    // Show message if no main category selected
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Text(
          'Please select a category above',
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

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.95.h,
            ),
            itemCount: controller.displayProducts.length,
            itemBuilder: (context, index) {
              final product = controller.displayProducts[index];
              final shop = controller.getShopForProduct(product);

              return CategoryProductItem(
                product: product,
                onTap: () => controller.onProductTap(product),
                onAddToCart: () => controller.onAddToCart(product),
                onFavoriteToggle: () => controller.onFavoriteToggle(product),
                isGroceryCategory: controller.isGroceryCategory,
                shop: shop,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSortBottomSheet(
    BuildContext context,
    UnifiedCategoryController controller,
  ) {
    Get.bottomSheet(
      SortBottomSheet(
        selectedSort: controller.selectedSortOption.value,
        onSortSelected: controller.onSortChanged,
      ),
      isScrollControlled: true,
    );
  }

  void _showFilterBottomSheet(
    BuildContext context,
    UnifiedCategoryController controller,
  ) {
    Get.bottomSheet(
      FilterBottomSheet(
        selectedFilters: controller.selectedFilters,
        priceRange: controller.priceRange,
        showOnlyInStock: controller.showOnlyInStock.value,
        onFiltersApplied: (filters, priceRange, showOnlyInStock) {
          controller.onFilterChanged(filters);
          controller.onPriceRangeChanged(priceRange);
          controller.onStockFilterChanged(showOnlyInStock);
        },
      ),
      isScrollControlled: true,
    );
  }
}
