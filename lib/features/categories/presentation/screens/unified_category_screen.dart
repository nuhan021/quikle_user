import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import 'package:quikle_user/features/categories/controllers/unified_category_controller.dart';
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
        body: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              _buildAppBar(controller),

              // Main Content
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search Bar and Filters
                        _buildSearchAndFilters(),

                        SizedBox(height: 16.h),

                        // Unified layout for all categories (including groceries)
                        Obx(() {
                          if (controller.showingAllProducts.value) {
                            // Show all products in grid
                            return _buildAllProductsGrid(controller);
                          } else if (controller.isGroceryCategory &&
                              controller.selectedMainCategory.value != null) {
                            // Grocery category selected - show subcategories and products
                            return _buildGrocerySelectedView(controller);
                          } else {
                            // Show normal layout with sections
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Popular Items (Categories for groceries, Subcategories for others)
                                _buildPopularItems(controller),

                                SizedBox(height: 24.h),

                                // Offer Banner (hide if grocery category is selected)
                                if (!(controller.isGroceryCategory &&
                                    controller.selectedMainCategory.value !=
                                        null))
                                  Center(child: OfferBanner()),

                                if (!(controller.isGroceryCategory &&
                                    controller.selectedMainCategory.value !=
                                        null))
                                  SizedBox(height: 24.h),

                                // Conditional section display based on subcategory selection
                                Obx(() {
                                  if (controller.shouldShowCombinedSection) {
                                    // Show combined section when a subcategory is selected
                                    return _buildCombinedItemsSection(
                                      controller,
                                    );
                                  } else {
                                    // Show separate Featured and Recommended sections when no subcategory is selected
                                    return Column(
                                      children: [
                                        // Featured Foods
                                        _buildFeaturedFoods(controller),

                                        SizedBox(height: 24.h),

                                        // Recommended for You
                                        _buildRecommendedForYou(controller),
                                      ],
                                    );
                                  }
                                }),
                              ],
                            );
                          }
                        }),

                        SizedBox(height: 100.h), // Bottom spacing
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(UnifiedCategoryController controller) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        border: Border(
          bottom: BorderSide(color: AppColors.gradientColor, width: 2),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Category Title
            Expanded(
              child: Obx(
                () => Text(
                  controller.categoryTitle.value,
                  style: getTextStyle(
                    font: CustomFonts.obviously,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ebonyBlack,
                  ),
                ),
              ),
            ),

            // Right side icons
            Row(
              children: [
                IconButton(
                  icon: const Icon(Iconsax.notification, color: Colors.black),
                  onPressed: () {
                    // Handle notification tap
                  },
                ),
                SizedBox(width: 8.w),
                IconButton(
                  icon: const Icon(
                    Iconsax.user_cirlce_add,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    // Handle profile tap
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          // Search Bar
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'Search for "Biryani"',
                            style: getTextStyle(
                              font: CustomFonts.manrope,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.featherGrey,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: const Icon(
                          Iconsax.search_normal,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: AppColors.beakYellow,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Iconsax.search_normal,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Sort and Filter buttons
          Row(
            children: [
              _buildFilterButton('Sort', Iconsax.sort),
              SizedBox(width: 12.w),
              _buildFilterButton('Filter', Iconsax.filter),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18.sp, color: Colors.black),
          SizedBox(width: 4.w),
          Text(
            text,
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularItems(UnifiedCategoryController controller) {
    // Show actual subcategories as popular items
    final subcategories = controller.availableSubcategories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Popular Items',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.ebonyBlack,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 83.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: subcategories.length,
            itemBuilder: (context, index) {
              final subcategory = subcategories[index];
              return GestureDetector(
                onTap: () => controller.onSubcategoryTap(subcategory),
                child: Container(
                  width: 60.w,
                  margin: EdgeInsets.only(right: 16.w),
                  child: Column(
                    children: [
                      Obx(
                        () => Container(
                          width: 60.w,
                          height: 60.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            color:
                                controller.selectedSubcategory.value?.id ==
                                    subcategory.id
                                ? AppColors.beakYellow.withValues(alpha: 0.3)
                                : Colors.grey[100],
                            border: Border.all(
                              color:
                                  controller.selectedSubcategory.value?.id ==
                                      subcategory.id
                                  ? AppColors.beakYellow
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              subcategory.iconPath,
                              width: 30.w,
                              height: 30.w,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.category,
                                  size: 30.sp,
                                  color:
                                      controller
                                              .selectedSubcategory
                                              .value
                                              ?.id ==
                                          subcategory.id
                                      ? AppColors.beakYellow
                                      : Colors.orange,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Obx(
                        () => Text(
                          subcategory.title,
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 12.sp,
                            fontWeight:
                                controller.selectedSubcategory.value?.id ==
                                    subcategory.id
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color:
                                controller.selectedSubcategory.value?.id ==
                                    subcategory.id
                                ? AppColors.beakYellow
                                : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedFoods(UnifiedCategoryController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 28.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      color: Colors.grey[100],
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      size: 16,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Featured ${controller.categoryTitle.value}',
                    style: getTextStyle(
                      font: CustomFonts.obviously,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ebonyBlack,
                    ),
                  ),
                ],
              ),
              Text(
                'View all',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h,
              childAspectRatio: 0.7,
            ),
            itemCount: controller.displayProducts.length > 6
                ? 6
                : controller.displayProducts.length,
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
        ),
      ],
    );
  }

  Widget _buildRecommendedForYou(UnifiedCategoryController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommended for You',
                style: getTextStyle(
                  font: CustomFonts.obviously,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ebonyBlack,
                ),
              ),
              GestureDetector(
                onTap: () => controller.showAllProducts(),
                child: Text(
                  'View all',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.68,
            ),
            itemCount: (controller.displayProducts.length > 6)
                ? ((controller.displayProducts.length - 6) > 6
                      ? 6
                      : controller.displayProducts.length - 6)
                : 0,
            itemBuilder: (context, index) {
              // Skip first 6 products (used in featured) and take next available
              final productIndex = index + 6;
              final product = controller.displayProducts[productIndex];
              return ProductItem(
                product: product,
                onTap: () => controller.onProductTap(product),
                onAddToCart: () => controller.onAddToCart(product),
                onFavoriteToggle: () => controller.onFavoriteToggle(product),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCombinedItemsSection(UnifiedCategoryController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.productsTitle.value,
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ebonyBlack,
                ),
              ),
              GestureDetector(
                onTap: () => controller.showAllProducts(),
                child: Text(
                  'View all',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.68,
            ),
            itemCount: controller.displayProducts.length > 12
                ? 12
                : controller.displayProducts.length,
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
        ),
      ],
    );
  }

  Widget _buildAllProductsGrid(UnifiedCategoryController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with back to sections button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${controller.categoryTitle.value} - All Items',
                style: getTextStyle(
                  font: CustomFonts.obviously,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ebonyBlack,
                ),
              ),
              GestureDetector(
                onTap: () => controller.showAllProducts(),
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
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // All products grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.68,
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

  Widget _buildGrocerySelectedView(UnifiedCategoryController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back to All Categories button
          GestureDetector(
            onTap: controller.resetToMainCategories,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.beakYellow,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back, color: Colors.black, size: 16),
                  SizedBox(width: 4.w),
                  Text(
                    'Back to All Categories',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Subcategories horizontal scroll (same design as popular items)
          if (controller.availableSubcategories.isNotEmpty) ...[
            Text(
              'Sub Categories',
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.ebonyBlack,
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 83.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.availableSubcategories.length,
                itemBuilder: (context, index) {
                  final subcategory = controller.availableSubcategories[index];
                  return GestureDetector(
                    onTap: () => controller.onSubcategoryTap(subcategory),
                    child: Container(
                      width: 60.w,
                      margin: EdgeInsets.only(right: 16.w),
                      child: Column(
                        children: [
                          Obx(
                            () => Container(
                              width: 60.w,
                              height: 60.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                color:
                                    controller.selectedSubcategory.value?.id ==
                                        subcategory.id
                                    ? AppColors.beakYellow.withValues(
                                        alpha: 0.3,
                                      )
                                    : Colors.grey[100],
                                border: Border.all(
                                  color:
                                      controller
                                              .selectedSubcategory
                                              .value
                                              ?.id ==
                                          subcategory.id
                                      ? AppColors.beakYellow
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Image.asset(
                                  subcategory.iconPath,
                                  width: 30.w,
                                  height: 30.w,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.category,
                                      size: 30.sp,
                                      color:
                                          controller
                                                  .selectedSubcategory
                                                  .value
                                                  ?.id ==
                                              subcategory.id
                                          ? AppColors.beakYellow
                                          : Colors.orange,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Obx(
                            () => Text(
                              subcategory.title,
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                fontSize: 12.sp,
                                fontWeight:
                                    controller.selectedSubcategory.value?.id ==
                                        subcategory.id
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color:
                                    controller.selectedSubcategory.value?.id ==
                                        subcategory.id
                                    ? AppColors.beakYellow
                                    : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24.h),
          ],

          // Products Grid
          if (controller.displayProducts.isNotEmpty) ...[
            Text(
              'Products',
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.ebonyBlack,
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
                childAspectRatio: 0.68,
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
          ] else ...[
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: Text(
                  'No products available',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 16.sp,
                    color: AppColors.featherGrey,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
