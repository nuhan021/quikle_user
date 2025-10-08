import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/common/widgets/custom_navbar.dart';
import 'package:quikle_user/core/common/widgets/floating_cart_button.dart';
import 'package:quikle_user/core/common/widgets/unified_product_card.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/core/data/services/product_data_service.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';
import 'package:quikle_user/core/utils/navigation/navbar_navigation_helper.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/orders/presentation/widgets/live_order_indicator.dart';
import 'package:quikle_user/features/profile/controllers/favorites_controller.dart';
import 'package:quikle_user/features/restaurants/data/models/restaurant_model.dart';
import 'package:quikle_user/routes/app_routes.dart';
import 'package:quikle_user/core/common/widgets/slivers/fixed_widget_header_delegate.dart';

class RestaurantPageScreen extends StatefulWidget {
  const RestaurantPageScreen({super.key});

  @override
  State<RestaurantPageScreen> createState() => _RestaurantPageScreenState();
}

class _RestaurantPageScreenState extends State<RestaurantPageScreen>
    with TickerProviderStateMixin {
  late AnimationController _navController;
  final ScrollController _scroll = ScrollController();
  final GlobalKey _navKey = GlobalKey();
  double _navBarHeight = 0.0;

  final ProductDataService _productService = ProductDataService();
  List<ProductModel> _restaurantProducts = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  late RestaurantModel restaurant;

  final List<String> _categories = [
    'All',
    'Appetizers',
    'Biryani',
    'Main Course',
    'Breads',
    'Desserts',
    'Beverages',
  ];

  @override
  void initState() {
    super.initState();

    _navController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: 1,
    );

    _initializeData();
  }

  @override
  void dispose() {
    _navController.dispose();
    _scroll.dispose();
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
    NavbarNavigationHelper.navigateToTab(index);
  }

  void _initializeData() {
    final args = Get.arguments as Map<String, dynamic>;
    restaurant = args['restaurant'];
    _loadProducts();
  }

  void _loadProducts() {
    setState(() => _isLoading = true);
    _restaurantProducts = _productService.allProducts
        .where((p) => p.shopId == restaurant.id)
        .toList();
    _filterProducts(_selectedCategory);
    setState(() => _isLoading = false);
  }

  void _filterProducts(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'All') {
        _filteredProducts = _restaurantProducts;
      } else {
        _filteredProducts = _restaurantProducts
            .where(
              (p) =>
                  p.productType?.toLowerCase() == category.toLowerCase() ||
                  p.subcategoryId?.toLowerCase() == category.toLowerCase(),
            )
            .toList();
      }
    });
  }

  bool _onScrollNotification(ScrollNotification n) {
    if (n is UserScrollNotification) {
      if (n.direction == ScrollDirection.reverse &&
          _navController.value != 0.0 &&
          _navController.status != AnimationStatus.reverse) {
        _navController.reverse();
      } else if (n.direction == ScrollDirection.forward &&
          _navController.value != 1.0 &&
          _navController.status != AnimationStatus.forward) {
        _navController.forward();
      } else if (n.direction == ScrollDirection.idle) {
        if (_navController.value != 1.0) {
          _navController.forward();
        }
      }
    }
    if (n is ScrollEndNotification) {
      if (_navController.value != 1.0) {
        _navController.forward();
      }
    }
    return false;
  }

  void _onFavoriteToggle(ProductModel product) {
    if (FavoritesController.isProductFavorite(product.id)) {
      FavoritesController.removeFromGlobalFavorites(product.id);
    } else {
      FavoritesController.addToGlobalFavorites(product.id);
    }

    final isFav = FavoritesController.isProductFavorite(product.id);
    final updated = product.copyWith(isFavorite: isFav);

    final idx = _restaurantProducts.indexWhere((p) => p.id == product.id);
    if (idx != -1) _restaurantProducts[idx] = updated;

    final fIdx = _filteredProducts.indexWhere((p) => p.id == product.id);
    if (fIdx != -1) _filteredProducts[fIdx] = updated;

    setState(() {});
  }

  void _onAddToCart(ProductModel product) {
    try {
      Get.find<CartController>().addToCart(product);
    } catch (_) {}
  }

  void _onProductTap(ProductModel product) {
    Get.toNamed(AppRoute.getProductDetails(), arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureNavBarHeight());
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardInset > 0;
    const double cartMargin = 16.0;
    final double bottomPadding =
        isKeyboardOpen ? keyboardInset : _navBarHeight + cartMargin;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return CartAnimationWrapper(
      child: Scaffold(
        backgroundColor: AppColors.homeGrey,
        body: NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,
          child: Stack(
            children: [
              SafeArea(
                child: CustomScrollView(
                  controller: _scroll,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(
                      child: CommonAppBar(
                        title: restaurant.name,
                        subtitle: restaurant.address,
                        showBackButton: true,
                        showNotification: false,
                        showProfile: false,
                        onBackTap: () => Get.back(),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: FixedWidgetHeaderDelegate(
                        minExtent: _headerExtent,
                        maxExtent: _headerExtent,
                        backgroundColor: AppColors.homeGrey,
                        shouldAddElevation: true,
                        builder: (context, shrink, overlaps) {
                          return Container(
                            color: AppColors.homeGrey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  child: Container(
                                    height: 48.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Search',
                                              hintStyle: getTextStyle(
                                                font: CustomFonts.manrope,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFFB8B8B8),
                                              ),
                                              border: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              contentPadding: EdgeInsets.symmetric(
                                                horizontal: 16.w,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 14.w),
                                          child: Icon(
                                            Icons.mic_outlined,
                                            size: 20.sp,
                                            color: const Color(0xFFB8B8B8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.h,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    itemCount: _categories.length,
                                    itemBuilder: (_, idx) {
                                      final cat = _categories[idx];
                                      final sel = cat == _selectedCategory;
                                      return GestureDetector(
                                        onTap: () => _filterProducts(cat),
                                        child: Container(
                                          margin: EdgeInsets.only(right: 8.w),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 8.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: sel
                                                ? AppColors.beakYellow
                                                : Colors.white,
                                            borderRadius: BorderRadius.circular(4.r),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withValues(alpha: .1),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            cat,
                                            style: getTextStyle(
                                              font: CustomFonts.inter,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 4.h),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(child: 16.verticalSpace),
                    if (_isLoading)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (_filteredProducts.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _emptyState(),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          bottom: bottomPadding,
                        ),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8.w,
                            mainAxisSpacing: 8.h,
                            childAspectRatio: 0.70,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, idx) {
                              final prod = _filteredProducts[idx];
                              return UnifiedProductCard(
                                product: prod,
                                onTap: () => _onProductTap(prod),
                                onAddToCart: () => _onAddToCart(prod),
                                onFavoriteToggle: () => _onFavoriteToggle(prod),
                                variant: ProductCardVariant.category,
                                isGroceryCategory: false,
                              );
                            },
                            childCount: _filteredProducts.length,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ✅ Navbar (category-style)
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
                      bottom: true,
                      child: KeyedSubtree(
                        key: _navKey,
                        child: CustomNavBar(
                          currentIndex: -1,
                          onTap: _onNavItemTapped,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              AnimatedBuilder(
                animation: _navController,
                builder: (_, __) {
                  final inset =
                      (isKeyboardOpen
                          ? keyboardInset
                          : _navController.value * _navBarHeight) +
                      cartMargin;
                  return FloatingCartButton(bottomInset: inset);
                },
              ),

              AnimatedBuilder(
                animation: _navController,
                builder: (_, __) {
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

  Widget _emptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'No items found',
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );

  double get _headerExtent => (48.h + 24.h) + 30.h + 4.h;
}
