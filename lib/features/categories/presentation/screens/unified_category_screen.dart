import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/common/widgets/address_widget.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/core/common/widgets/custom_navbar.dart';
import 'package:quikle_user/core/common/widgets/floating_cart_button.dart';
import 'package:quikle_user/core/common/widgets/voice_search_overlay.dart';
import 'package:quikle_user/core/common/widgets/product_card_shimmer.dart';
import 'package:quikle_user/features/categories/presentation/widgets/category_screen_shimmer.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/navigation/navbar_navigation_helper.dart';
import 'package:quikle_user/features/categories/controllers/unified_category_controller.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';
import 'package:quikle_user/features/categories/presentation/widgets/search_and_filters_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/popular_items_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/product_grid_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/category_product_item.dart';
import 'package:quikle_user/features/orders/presentation/widgets/live_order_indicator.dart';
import 'package:quikle_user/features/restaurants/presentation/widgets/top_restaurants_section.dart';
import 'package:quikle_user/features/prescription/presentation/widgets/prescription_upload_section.dart';

class UnifiedCategoryScreen extends StatefulWidget {
  const UnifiedCategoryScreen({super.key});

  @override
  State<UnifiedCategoryScreen> createState() => _UnifiedCategoryScreenState();
}

class _UnifiedCategoryScreenState extends State<UnifiedCategoryScreen>
    with TickerProviderStateMixin {
  late final AnimationController _navController;
  final GlobalKey _navKey = GlobalKey();
  double _navBarHeight = 0.0;

  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();

    _navController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: 1.0,
    );

    // Add scroll listener for pagination
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    final controller = Get.find<UnifiedCategoryController>();

    final scrollPercent =
        _scroll.position.pixels / _scroll.position.maxScrollExtent;
    print(
      '📜 Scroll position: ${_scroll.position.pixels.toStringAsFixed(0)} / ${_scroll.position.maxScrollExtent.toStringAsFixed(0)} (${(scrollPercent * 100).toStringAsFixed(1)}%)',
    );
    print(
      '📊 showingAllProducts: ${controller.showingAllProducts.value}, isLoadingMore: ${controller.isLoadingMore.value}, hasMore: ${controller.hasMore.value}',
    );

    // Trigger load more when 10% scrolled and showing all products
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent * 0.8) {
      print('🎯 Reached 10% threshold');
      if (controller.showingAllProducts.value) {
        print('✅ Calling loadMoreProducts()');
        controller.loadMoreProducts();
      } else {
        print('⚠️ NOT showing all products, skipping load');
      }
    }
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
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
    if (index == 2) return;
    NavbarNavigationHelper.navigateToTab(index);
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse &&
          _navController.value != 0.0 &&
          _navController.status != AnimationStatus.reverse) {
        _navController.reverse();
      } else if (notification.direction == ScrollDirection.forward &&
          _navController.value != 1.0 &&
          _navController.status != AnimationStatus.forward) {
        _navController.forward();
      } else if (notification.direction == ScrollDirection.idle &&
          _navController.value != 1.0) {
        _navController.forward();
      }
    }
    if (notification is ScrollEndNotification && _navController.value != 1.0) {
      _navController.forward();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureNavBarHeight());

    final controller = Get.put(UnifiedCategoryController());
    final searchController = TextEditingController();

    final keyboard = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboard > 0;

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
              SafeArea(
                child: NotificationListener<ScrollNotification>(
                  onNotification: _onScrollNotification,
                  child: Obx(() {
                    final hasPopular = controller.isGroceryCategory
                        ? controller.allCategories.isNotEmpty
                        : controller.availableSubcategories.isNotEmpty;

                    final totalHeaderHeight =
                        SearchAndFiltersSection.kPreferredHeight +
                        (hasPopular ? PopularItemsSection.kPreferredHeight : 0);

                    final selectedMainCategoryId =
                        controller.selectedMainCategory.value?.id ?? 'none';
                    final selectedSubcategoryId =
                        controller.selectedSubcategory.value?.id ?? 'none';

                    return CustomScrollView(
                      physics: const ClampingScrollPhysics(),
                      controller: _scroll,
                      slivers: [
                        // 🔸 AppBar
                        SliverToBoxAdapter(
                          child: CommonAppBar(
                            title: controller.categoryTitle.value,
                            showNotification: false,
                            showProfile: false,
                            onBackTap: () => Get.back(),
                            addressWidget: AddressWidget(),
                          ),
                        ),

                        // 🔸 Pinned Search + Filter/Sort + Popular
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _UnifiedHeaderDelegate(
                            searchSection: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: SearchAndFiltersSection(
                                searchController: searchController,
                                onSearchChanged: controller.onSearchChanged,
                                onVoiceTap: controller.onVoiceSearchPressed,
                                dynamicHint: controller.currentPlaceholder,
                              ),
                            ),
                            popularSection: hasPopular
                                ? (controller.isLoading.value
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                          ),
                                          child: const PopularItemsShimmer(
                                            itemCount: 5,
                                          ),
                                        )
                                      : Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                          ),
                                          child: PopularItemsSection(
                                            subcategories:
                                                controller.isGroceryCategory
                                                ? controller.allCategories
                                                : controller
                                                      .availableSubcategories,
                                            onSubcategoryTap:
                                                controller.onSubcategoryTap,
                                            title: controller.isGroceryCategory
                                                ? 'Categories'
                                                : controller
                                                      .sectionTitle
                                                      .value
                                                      .isEmpty
                                                ? 'Popular Items'
                                                : controller.sectionTitle.value,
                                            selectedSubcategory:
                                                controller.isGroceryCategory
                                                ? controller
                                                      .selectedMainCategory
                                                      .value
                                                : controller
                                                      .selectedSubcategory
                                                      .value,
                                            category:
                                                controller.currentCategory,
                                            controller: controller,
                                          ),
                                        ))
                                : const SizedBox.shrink(),

                            totalHeight: totalHeaderHeight,
                            rebuildToken: [
                              controller.isGroceryCategory,
                              selectedMainCategoryId,
                              selectedSubcategoryId,
                              controller.currentPlaceholder.value,
                              hasPopular,
                            ].join('|'),
                          ),
                        ),

                        // 🔸 Offer Banner + Top Restaurants + Content
                        Obx(() {
                          // Show full page loading only on initial load
                          if (controller.isLoading.value) {
                            return SliverList(
                              delegate: SliverChildListDelegate([
                                // Show prescription shimmer for medicine category
                                if (controller.isMedicineCategory) ...[
                                  const PrescriptionUploadShimmer(),
                                  SizedBox(height: 8.h),
                                ],
                                // Show restaurant shimmer for food category
                                if (controller.isFoodCategory) ...[
                                  const TopRestaurantsShimmer(itemCount: 6),
                                  SizedBox(height: 16.h),
                                ],
                                // Product grid shimmer
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  child: Column(
                                    children: [
                                      const ProductGridHeaderShimmer(),
                                      SizedBox(height: 12.h),
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 8.w,
                                              mainAxisSpacing: 8.h,
                                              childAspectRatio: 0.70,
                                            ),
                                        itemCount: 9,
                                        itemBuilder: (context, index) =>
                                            const ProductCardShimmer(),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            );
                          }

                          final showTopRestaurants =
                              controller.isFoodCategory &&
                              controller.showRestaurants.value &&
                              controller.topRestaurants.isNotEmpty;

                          // Show restaurants at top only when "All" is selected
                          final showRestaurantsAtTop =
                              showTopRestaurants &&
                              controller.selectedSubcategory.value == null;

                          return SliverList(
                            delegate: SliverChildListDelegate([
                              // Top Restaurants Section (Food category only, when "All" is selected)
                              if (showRestaurantsAtTop) ...[
                                // SizedBox(height: 10.h),
                                TopRestaurantsSection(
                                  restaurants: controller.topRestaurants,
                                  onRestaurantTap: controller.onRestaurantTap,
                                  title: 'Top 25 Restaurants',
                                ),
                                SizedBox(height: 16.h),
                              ],
                              if (controller.isMedicineCategory) ...[
                                // SizedBox(height: 16.h),
                                const PrescriptionUploadSection(),
                                SizedBox(height: 8.h),
                              ],
                              // Main content (products) - show shimmer only when loading products
                              if (controller.isLoadingProducts.value)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  child: Column(
                                    children: [
                                      const ProductGridHeaderShimmer(),
                                      SizedBox(height: 12.h),
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 8.w,
                                              mainAxisSpacing: 8.h,
                                              childAspectRatio: 0.70,
                                            ),
                                        itemCount: 9,
                                        itemBuilder: (context, index) =>
                                            const ProductCardShimmer(),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 4.h,
                                  ),
                                  child: _buildContent(
                                    controller,
                                    showTopRestaurants && !showRestaurantsAtTop,
                                  ),
                                ),
                            ]),
                          );
                        }),
                      ],
                    );
                  }),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 180),
                  offset: isKeyboardOpen
                      ? const Offset(0, 1)
                      : const Offset(0, 0),
                  child: SizeTransition(
                    axisAlignment: 1.0,
                    sizeFactor: _navController,
                    child: KeyedSubtree(
                      key: _navKey,
                      child: CustomNavBar(
                        currentIndex: 2,
                        onTap: _onNavItemTapped,
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _navController,
                builder: (context, _) {
                  final inset = isKeyboardOpen
                      ? keyboard
                      : (_navController.value * _navBarHeight);
                  return FloatingCartButton(bottomInset: inset);
                },
              ),
              Obx(() {
                if (!controller.isListening) return const SizedBox.shrink();
                return VoiceSearchOverlay(
                  soundLevel: controller.soundLevel,
                  onCancel: controller.stopVoiceSearch,
                );
              }),
              AnimatedBuilder(
                animation: _navController,
                builder: (context, _) {
                  final inset = isKeyboardOpen
                      ? keyboard
                      : (_navController.value * _navBarHeight);
                  return LiveOrderIndicator(bottomInset: inset);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    UnifiedCategoryController controller,
    bool showRestaurantsInMiddle,
  ) {
    if (controller.showingAllProducts.value) {
      return _buildAllProductsView(controller);
    }
    if (controller.isGroceryCategory) {
      return _buildGroceryContentView(controller);
    }
    return _buildDefaultCategoryView(controller, showRestaurantsInMiddle);
  }

  Widget _buildDefaultCategoryView(
    UnifiedCategoryController controller,
    bool showRestaurantsInMiddle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (controller.displayProducts.isNotEmpty)
          ProductGridSection(
            title: controller.productsTitle.value,
            categoryName: controller.categoryTitle.value,
            products: controller.displayProducts,
            onProductTap: controller.onProductTap,
            onAddToCart: controller.onAddToCart,
            onFavoriteToggle: controller.onFavoriteToggle,
            onViewAllTap: controller.showAllProducts,
            maxItems: 9,
            crossAxisCount: 3,
            isGroceryCategory: controller.isGroceryCategory,
            shops: controller.shops,
          ),

        // Top 25 Restaurants in the middle (when specific subcategory is selected)
        if (showRestaurantsInMiddle) ...[
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            child: TopRestaurantsSection(
              restaurants: controller.topRestaurants,
              onRestaurantTap: controller.onRestaurantTap,
              title: 'Top 25 Restaurants',
            ),
          ),
          SizedBox(height: 16.h),
        ],

        if (!controller.isGroceryCategory &&
            controller.recommendedProducts.isNotEmpty) ...[
          ProductGridSection(
            title: 'Recommended for You',
            products: controller.recommendedProducts,
            categoryName: controller.categoryTitle.value,
            onProductTap: controller.onProductTap,
            onAddToCart: controller.onAddToCart,
            onFavoriteToggle: controller.onFavoriteToggle,
            maxItems: 8,
            crossAxisCount: 2,
            isGroceryCategory: controller.isGroceryCategory,
            shops: controller.shops,
          ),
          SizedBox(height: 40.h),
        ],
        if (controller.displayProducts.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: Center(
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
    if (controller.displayProducts.isNotEmpty) {
      return ProductGridSection(
        title: controller.productsTitle.value,
        categoryName: controller.categoryTitle.value,
        products: controller.displayProducts,
        onProductTap: controller.onProductTap,
        onAddToCart: controller.onAddToCart,
        onFavoriteToggle: controller.onFavoriteToggle,
        onViewAllTap: controller.showAllProducts,
        maxItems: 9,
        crossAxisCount: 3,
        isGroceryCategory: controller.isGroceryCategory,
        shops: controller.shops,
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Center(
        child: Text(
          'No products available',
          style: TextStyle(color: AppColors.featherGrey, fontSize: 16.sp),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildAllProductsView(UnifiedCategoryController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 3, color: Color(0xFFEDEDED)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.productsTitle.value,
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
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h,
              childAspectRatio: controller.isMedicineCategory ? 0.65 : 0.70,
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
          // Loading indicator for pagination
          Obx(() {
            if (controller.isLoadingMore.value) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                    childAspectRatio: controller.isMedicineCategory
                        ? 0.65
                        : 0.70,
                  ),
                  itemCount: 3, // Show 3 shimmer cards while loading more
                  itemBuilder: (context, index) => const ProductCardShimmer(),
                ),
              );
            }
            // Show "No more products" message if there are no more items
            if (!controller.hasMore.value &&
                controller.displayProducts.isNotEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Center(
                  child: Text(
                    'No more products',
                    style: TextStyle(
                      color: AppColors.featherGrey,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          // Add extra space to ensure content is scrollable even with few items
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}

class _UnifiedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget searchSection;
  final Widget popularSection;
  final double totalHeight;
  final Object? rebuildToken;

  _UnifiedHeaderDelegate({
    required this.searchSection,
    required this.popularSection,
    required this.totalHeight,
    this.rebuildToken,
  });

  @override
  double get minExtent => totalHeight + 1.0;

  @override
  double get maxExtent => totalHeight + 1.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Base child (the actual header content)
    final Widget child = SizedBox(
      height: totalHeight + 1.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [searchSection, popularSection],
      ),
    );

    // Determine whether to show elevation when content is scrolled under
    final bool showElevation = shrinkOffset > 0 || overlapsContent;

    // Apply a glassy backdrop with blur + translucent background
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          color: AppColors.homeGrey.withValues(alpha: .6),
          child: Material(
            color: Colors.transparent,
            elevation: showElevation ? 4.0 : 0.0,
            shadowColor: Colors.black.withValues(alpha: .08),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.homeGrey.withValues(alpha: .6),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: .12),
                    width: 1,
                  ),
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _UnifiedHeaderDelegate oldDelegate) {
    return totalHeight != oldDelegate.totalHeight ||
        rebuildToken != oldDelegate.rebuildToken;
  }
}
