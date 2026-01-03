import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/widgets/address_widget.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/core/common/widgets/custom_navbar.dart';
import 'package:quikle_user/core/common/widgets/floating_cart_button.dart';
import 'package:quikle_user/core/common/widgets/voice_search_overlay.dart';
import 'package:quikle_user/core/common/widgets/product_card_shimmer.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/navigation/navbar_navigation_helper.dart';
import 'package:quikle_user/features/categories/controllers/category_products_controller.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';
import 'package:quikle_user/features/categories/presentation/widgets/search_and_filters_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/category_product_item.dart';
import 'package:quikle_user/features/categories/presentation/widgets/minimal_subcategories_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/minimal_subcategories_shimmer.dart';
import 'package:quikle_user/features/categories/presentation/widgets/load_more_products_shimmer.dart';
import 'package:quikle_user/features/orders/presentation/widgets/live_order_indicator.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen>
    with TickerProviderStateMixin {
  late AnimationController _navController;
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

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    _navController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final controller = Get.find<CategoryProductsController>();

    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent * 0.8) {
      // User scrolled 80% of the content
      controller.loadMoreProducts();
    }
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _measureNavBarHeight());

    final controller = Get.put(CategoryProductsController());
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
                bottom: false,
                child: NotificationListener<ScrollNotification>(
                  onNotification: _onScrollNotification,
                  child: Obx(() {
                    final hasSubcategories =
                        controller.subcategories.isNotEmpty;
                    final searchBlockHeight =
                        SearchAndFiltersSection.kPreferredHeight + 16.h;
                    final subcategoriesHeight = hasSubcategories
                        ? MinimalSubcategoriesSection.kPreferredHeight
                        : 0.0;
                    final totalHeaderHeight =
                        searchBlockHeight + subcategoriesHeight;
                    final selectedSubcategoryId =
                        controller.selectedSubcategory.value?.id ?? 'none';

                    return CustomScrollView(
                      physics: const ClampingScrollPhysics(),
                      controller: _scroll,
                      slivers: [
                        SliverToBoxAdapter(
                          child: CommonAppBar(
                            title: controller.categoryTitle.value,
                            showNotification: false,
                            showProfile: false,
                            onBackTap: () => Get.back(),
                            addressWidget: AddressWidget(),
                          ),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _CategoryHeaderDelegate(
                            searchSection: SizedBox(
                              height: searchBlockHeight,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                child: SearchAndFiltersSection(
                                  searchController: searchController,
                                  onSearchChanged: controller.onSearchChanged,
                                  onVoiceTap: controller.onVoiceSearchPressed,
                                  dynamicHint: controller.currentPlaceholder,
                                ),
                              ),
                            ),
                            subcategoriesSection:
                                hasSubcategories ||
                                    controller.isLoadingSubcategories.value
                                ? SizedBox(
                                    height: subcategoriesHeight,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
                                      child:
                                          controller
                                              .isLoadingSubcategories
                                              .value
                                          ? const MinimalSubcategoriesShimmer()
                                          : MinimalSubcategoriesSection(
                                              categoryIconPath: controller
                                                  .currentCategory
                                                  .iconPath,
                                              subcategories:
                                                  controller.subcategories,
                                              selectedSubcategory: controller
                                                  .selectedSubcategory
                                                  .value,
                                              onSubcategoryTap:
                                                  controller.onSubcategoryTap,
                                              controller: controller,
                                            ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            totalHeight: totalHeaderHeight,
                            rebuildToken: [
                              hasSubcategories,
                              selectedSubcategoryId,
                              controller.currentPlaceholder.value,
                            ].join('|'),
                          ),
                        ),
                        if (controller.isLoading.value)
                          const ProductGridShimmer(itemCount: 9)
                        else if (controller.displayProducts.isEmpty)
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Text(
                                  'No products available',
                                  style: TextStyle(
                                    color: AppColors.featherGrey,
                                    fontSize: 16.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        else
                          SliverPadding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            sliver: SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 8.w,
                                    mainAxisSpacing: 8.h,
                                    childAspectRatio: 0.70,
                                  ),
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final product =
                                    controller.displayProducts[index];
                                final shop = controller.getShopForProduct(
                                  product,
                                );

                                return CategoryProductItem(
                                  product: product,
                                  onTap: () => controller.onProductTap(product),
                                  onAddToCart: () =>
                                      controller.onAddToCart(product),
                                  onFavoriteToggle: () =>
                                      controller.onFavoriteToggle(product),
                                  isGroceryCategory:
                                      controller.isGroceryCategory,
                                  shop: shop,
                                );
                              }, childCount: controller.displayProducts.length),
                            ),
                          ),
                        // Loading more indicator
                        if (controller.isLoadingMore.value)
                          const SliverToBoxAdapter(
                            child: LoadMoreProductsShimmer(itemCount: 3),
                          ),
                        // Bottom padding for scrollability
                        SliverToBoxAdapter(child: SizedBox(height: 100.h)),
                      ],
                    );
                  }),
                ),
              ),

              if (!isKeyboardOpen)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedSlide(
                    // When keyboard is open we don't render the navbar at all,
                    // so offset can be fixed to zero here.
                    duration: const Duration(milliseconds: 180),
                    offset: const Offset(0, 0),
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
              if (!isKeyboardOpen)
                AnimatedBuilder(
                  animation: _navController,
                  builder: (context, _) {
                    final inset = (_navController.value * _navBarHeight);
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
              if (!isKeyboardOpen)
                AnimatedBuilder(
                  animation: _navController,
                  builder: (context, _) {
                    final inset = (_navController.value * _navBarHeight);
                    return LiveOrderIndicator(bottomInset: inset);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget searchSection;
  final Widget subcategoriesSection;
  final double totalHeight;
  final Object? rebuildToken;

  _CategoryHeaderDelegate({
    required this.searchSection,
    required this.subcategoriesSection,
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
        children: [searchSection, subcategoriesSection],
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
  bool shouldRebuild(covariant _CategoryHeaderDelegate oldDelegate) {
    return totalHeight != oldDelegate.totalHeight ||
        rebuildToken != oldDelegate.rebuildToken;
  }
}
