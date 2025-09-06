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

                        // For non-grocery categories or show everything in groceries
                        if (!controller.isGroceryCategory) ...[
                          // Popular Items
                          _buildPopularItems(controller),

                          SizedBox(height: 24.h),

                          // Offer Banner
                          Center(child: OfferBanner()),

                          SizedBox(height: 24.h),

                          // Featured Foods
                          _buildFeaturedFoods(controller),

                          SizedBox(height: 24.h),

                          // Recommended for You
                          _buildRecommendedForYou(controller),
                        ] else ...[
                          // Grocery specific layout with back button and categories
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Back to All Categories button (for groceries)
                                if (controller.selectedMainCategory.value !=
                                    null) ...[
                                  GestureDetector(
                                    onTap: controller.resetToMainCategories,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.beakYellow,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.arrow_back,
                                            color: Colors.black,
                                            size: 16,
                                          ),
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
                                ],

                                // Available Subcategories
                                if (controller
                                    .availableSubcategories
                                    .isNotEmpty) ...[
                                  Text(
                                    controller.selectedMainCategory.value !=
                                            null
                                        ? 'Sub Categories'
                                        : 'Categories',
                                    style: getTextStyle(
                                      font: CustomFonts.obviously,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.ebonyBlack,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Wrap(
                                    spacing: 8.w,
                                    runSpacing: 8.h,
                                    children: controller.availableSubcategories
                                        .map(
                                          (subcategory) => GestureDetector(
                                            onTap: () => controller
                                                .onSubcategoryTap(subcategory),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 8.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    controller
                                                            .selectedSubcategory
                                                            .value
                                                            ?.id ==
                                                        subcategory.id
                                                    ? AppColors.beakYellow
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                border: Border.all(
                                                  color: AppColors.cardColor,
                                                ),
                                              ),
                                              child: Text(
                                                subcategory.title,
                                                style: getTextStyle(
                                                  font: CustomFonts.inter,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      controller
                                                              .selectedSubcategory
                                                              .value
                                                              ?.id ==
                                                          subcategory.id
                                                      ? Colors.black
                                                      : AppColors.ebonyBlack,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  SizedBox(height: 16.h),
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
                                  SizedBox(height: 8.h),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 12.w,
                                          mainAxisSpacing: 12.h,
                                          childAspectRatio: 0.75,
                                        ),
                                    itemCount:
                                        controller.displayProducts.length,
                                    itemBuilder: (context, index) {
                                      final product =
                                          controller.displayProducts[index];
                                      return ProductItem(
                                        product: product,
                                        onTap: () =>
                                            controller.onProductTap(product),
                                        onAddToCart: () =>
                                            controller.onAddToCart(product),
                                        onFavoriteToggle: () => controller
                                            .onFavoriteToggle(product),
                                      );
                                    },
                                  ),
                                ] else ...[
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 40.h,
                                      ),
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
                          ),
                        ],

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
                  controller.sectionTitle.value,
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
    // Sample popular items for the category
    final popularItems = _getPopularItemsForCategory(controller);

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
            itemCount: popularItems.length,
            itemBuilder: (context, index) {
              final item = popularItems[index];
              return Container(
                width: 60.w,
                margin: EdgeInsets.only(right: 16.w),
                child: Column(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        color: Colors.grey[100],
                      ),
                      child: Center(
                        child: Icon(
                          item['icon'] as IconData,
                          size: 30.sp,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item['name'] as String,
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
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
                    'Featured Foods',
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
                'Restaurants',
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
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 8, // Sample restaurants
            itemBuilder: (context, index) {
              final restaurants = [
                'Masala Mandir',
                'Tandoori Tarang',
                'Saffron Sagar',
                'Dhaba Diwana',
                'Biriyani Bagaan',
                'Chaat Sagar',
                'Rasam Rajya',
                'Mehfil Mughlai',
              ];

              return Container(
                width: 113.w,
                margin: EdgeInsets.only(right: 8.w),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B0F0F),
                        borderRadius: BorderRadius.circular(28.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 13.33,
                            offset: const Offset(0, 2.67),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.restaurant,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      restaurants[index],
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
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
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.68,
            ),
            itemCount: controller.displayProducts.take(10).length,
            itemBuilder: (context, index) {
              final product = controller.displayProducts[index];
              return _buildRecommendedProductCard(product, controller);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedProductCard(
    product,
    UnifiedCategoryController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  topRight: Radius.circular(8.r),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      product.imagePath,
                      width: 90.w,
                      height: 90.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: () => controller.onFavoriteToggle(product),
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 16.sp,
                          color: product.isFavorite ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Product Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ebonyBlack,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      SizedBox(width: 4.w),
                      Text(
                        '4.8 • 25 min',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 12.sp,
                          color: AppColors.featherGrey,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.price,
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ebonyBlack,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.onAddToCart(product),
                        child: Container(
                          width: 22.w,
                          height: 22.w,
                          decoration: BoxDecoration(
                            color: AppColors.beakYellow,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getPopularItemsForCategory(
    UnifiedCategoryController controller,
  ) {
    // Return popular items based on category type
    if (controller.currentCategory.title.toLowerCase().contains('food')) {
      return [
        {'name': 'Pizza', 'icon': Icons.local_pizza},
        {'name': 'Burger', 'icon': Icons.lunch_dining},
        {'name': 'Pasta', 'icon': Icons.restaurant},
        {'name': 'Sushi', 'icon': Icons.set_meal},
        {'name': 'Salad', 'icon': Icons.eco},
        {'name': 'Coffee', 'icon': Icons.coffee},
      ];
    } else if (controller.currentCategory.title.toLowerCase().contains(
      'medicine',
    )) {
      return [
        {'name': 'Tablets', 'icon': Icons.medication},
        {'name': 'Syrup', 'icon': Icons.local_pharmacy},
        {'name': 'Vitamins', 'icon': Icons.health_and_safety},
        {'name': 'Bandages', 'icon': Icons.healing},
        {'name': 'Antiseptic', 'icon': Icons.medical_services},
        {'name': 'Inhaler', 'icon': Icons.air},
      ];
    } else if (controller.currentCategory.title.toLowerCase().contains(
      'cleaning',
    )) {
      return [
        {'name': 'Detergent', 'icon': Icons.cleaning_services},
        {'name': 'Soap', 'icon': Icons.soap},
        {'name': 'Spray', 'icon': Icons.water_drop},
        {'name': 'Brush', 'icon': Icons.brush},
        {'name': 'Sponge', 'icon': Icons.kitchen},
        {'name': 'Bleach', 'icon': Icons.water_drop},
      ];
    } else if (controller.currentCategory.title.toLowerCase().contains(
      'personal',
    )) {
      return [
        {'name': 'Shampoo', 'icon': Icons.shower},
        {'name': 'Toothpaste', 'icon': Icons.format_paint},
        {'name': 'Lotion', 'icon': Icons.spa},
        {'name': 'Perfume', 'icon': Icons.style},
        {'name': 'Razor', 'icon': Icons.content_cut},
        {'name': 'Cream', 'icon': Icons.face},
      ];
    } else if (controller.currentCategory.title.toLowerCase().contains('pet')) {
      return [
        {'name': 'Food', 'icon': Icons.pets},
        {'name': 'Toys', 'icon': Icons.sports_esports},
        {'name': 'Collar', 'icon': Icons.circle},
        {'name': 'Leash', 'icon': Icons.link},
        {'name': 'Treats', 'icon': Icons.cake},
        {'name': 'Bed', 'icon': Icons.bed},
      ];
    } else {
      // Default popular items
      return [
        {'name': 'Popular', 'icon': Icons.star},
        {'name': 'New', 'icon': Icons.new_releases},
        {'name': 'Sale', 'icon': Icons.local_offer},
        {'name': 'Featured', 'icon': Icons.featured_play_list},
        {'name': 'Trending', 'icon': Icons.trending_up},
        {'name': 'Best', 'icon': Icons.thumb_up},
      ];
    }
  }
}
