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
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/navigation/navbar_navigation_helper.dart';
import 'package:quikle_user/features/categories/controllers/unified_category_controller.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';
import 'package:quikle_user/features/categories/presentation/widgets/search_and_filters_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/popular_items_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/product_grid_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/category_product_item.dart';
import 'package:quikle_user/features/orders/presentation/widgets/live_order_indicator.dart';
import 'package:quikle_user/features/restaurants/presentation/widgets/top_restaurants_section.dart';
import 'package:quikle_user/features/home/presentation/widgets/banners/offer_banner.dart';
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

  late final AnimationController _barAnim;
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();

    _navController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      value: 1.0,
    );

    _barAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: 1.0,
    );

    _scroll.addListener(() {
      if (_scroll.offset > 8 && _barAnim.value == 1.0) {
        _barAnim.reverse();
      } else if (_scroll.offset <= 8 && _barAnim.value == 0.0) {
        _barAnim.forward();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _barAnim.dispose();
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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureNavBarHeight());
    const double cartMargin = 16.0;

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
                child: Column(
                  children: [
                    ClipRect(
                      child: SizeTransition(
                        axisAlignment: -1,
                        sizeFactor: _barAnim,
                        child: Obx(
                          () => CommonAppBar(
                            title: controller.categoryTitle.value,
                            showNotification: false,
                            showProfile: false,
                            onBackTap: () => Get.back(),
                            addressWidget: AddressWidget(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          SizedBox(height: 8.h),
                          SearchAndFiltersSection(
                            searchController: searchController,
                            onSearchChanged: controller.onSearchChanged,
                            onVoiceTap: controller.onVoiceSearchPressed,
                            dynamicHint: controller.currentPlaceholder,
                          ),
                          Obx(
                            () => PopularItemsSection(
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
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return AnimatedBuilder(
                          animation: _navController,
                          builder: (context, _) {
                            final bottomInset = isKeyboardOpen
                                ? 0.0
                                : _navController.value * _navBarHeight;
                            return NotificationListener<ScrollNotification>(
                              onNotification: (notification) {
                                if (notification is UserScrollNotification) {
                                  if (notification.direction ==
                                          ScrollDirection.reverse &&
                                      _navController.value != 0.0 &&
                                      _navController.status !=
                                          AnimationStatus.reverse) {
                                    _navController.reverse();
                                  } else if (notification.direction ==
                                          ScrollDirection.forward &&
                                      _navController.value != 1.0 &&
                                      _navController.status !=
                                          AnimationStatus.forward) {
                                    _navController.forward();
                                  } else if (notification.direction ==
                                      ScrollDirection.idle) {
                                    if (_navController.value != 1.0) {
                                      _navController.forward();
                                    }
                                  }
                                }
                                if (notification is ScrollEndNotification) {
                                  if (_navController.value != 1.0) {
                                    _navController.forward();
                                  }
                                }
                                return false;
                              },
                              child: ListView(
                                controller: _scroll,
                                padding: EdgeInsets.only(
                                  top: 12.h,
                                  left: 16.w,
                                  right: 8.w,
                                  bottom: bottomInset + 24.h,
                                ),
                                children: [
                                  if (controller.isFoodCategory &&
                                      controller.showRestaurants.value &&
                                      controller.topRestaurants.isNotEmpty) ...[
                                    SizedBox(height: 8.h),
                                    TopRestaurantsSection(
                                      restaurants: controller.topRestaurants,
                                      onRestaurantTap:
                                          controller.onRestaurantTap,
                                      title: 'Top 25 Restaurants',
                                    ),
                                  ],
                                  if (controller.isGroceryCategory &&
                                      controller.selectedMainCategory.value !=
                                          null &&
                                      controller
                                          .filterSubcategories
                                          .isNotEmpty) ...[
                                    SizedBox(height: 20.h),
                                    PopularItemsSection(
                                      subcategories:
                                          controller.filterSubcategories,
                                      onSubcategoryTap:
                                          controller.onSubcategoryTap,
                                      title:
                                          'Select ${controller.selectedMainCategory.value!.title}',
                                      selectedSubcategory:
                                          controller.selectedSubcategory.value,
                                    ),
                                  ],
                                  if (controller.isMedicineCategory) ...[
                                    const PrescriptionUploadSection(),
                                  ],
                                  SizedBox(height: 16.h),
                                  OfferBanner(),
                                  SizedBox(height: 16.h),
                                  _buildContent(controller),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
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
                    child: SafeArea(
                      top: false,
                      bottom: false,
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
              ),
              AnimatedBuilder(
                animation: _navController,
                builder: (context, _) {
                  final navSpace = isKeyboardOpen
                      ? 0.0
                      : (_navController.value * _navBarHeight);
                  final inset =
                      (isKeyboardOpen ? keyboard : navSpace) + cartMargin;
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
              const LiveOrderIndicator(),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (controller.displayProducts.isNotEmpty)
          ProductGridSection(
            title: controller.productsTitle.value,
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
        if (!controller.isGroceryCategory &&
            controller.recommendedProducts.isNotEmpty)
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.70.h,
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
}
