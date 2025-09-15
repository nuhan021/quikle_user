import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/core/common/widgets/custom_navbar.dart';
import 'package:quikle_user/core/common/widgets/floating_cart_button.dart';
import 'package:quikle_user/core/common/widgets/unified_product_card.dart';
import 'package:quikle_user/core/data/services/product_data_service.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';
import 'package:quikle_user/core/utils/navigation/navbar_navigation_helper.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/profile/controllers/favorites_controller.dart';
import 'package:quikle_user/features/restaurants/data/models/restaurant_model.dart';
import 'package:quikle_user/routes/app_routes.dart';

class RestaurantPageScreen extends StatefulWidget {
  const RestaurantPageScreen({super.key});

  @override
  State<RestaurantPageScreen> createState() => _RestaurantPageScreenState();
}

class _RestaurantPageScreenState extends State<RestaurantPageScreen>
    with TickerProviderStateMixin {
  // Animation controller for navbar
  late AnimationController _navController;
  final GlobalKey _navKey = GlobalKey();
  double _navBarHeight = 0.0;

  final ProductDataService _productService = ProductDataService();
  List<ProductModel> _restaurantProducts = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  late RestaurantModel restaurant;
  late String categoryId;
  late String categoryName;

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
      duration: const Duration(milliseconds: 260),
      value: 1.0,
    );
    _initializeData();
  }

  @override
  void dispose() {
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
    NavbarNavigationHelper.navigateToTab(index);
  }

  void _initializeData() {
    final arguments = Get.arguments as Map<String, dynamic>;
    restaurant = arguments['restaurant'];
    categoryId = arguments['categoryId'] ?? '';
    categoryName = arguments['categoryName'] ?? '';

    _loadProducts();
  }

  void _loadProducts() {
    setState(() => _isLoading = true);

    _restaurantProducts = _productService.allProducts
        .where((product) => product.shopId == restaurant.id)
        .toList();

    _filterProducts(_selectedCategory);

    setState(() => _isLoading = false);
  }

  void _filterProducts(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'All') {
        _filteredProducts = _restaurantProducts;
      } else if (category == 'Appetizers') {
        _filteredProducts = _restaurantProducts
            .where((product) => product.productType == 'appetizer')
            .toList();
      } else if (category == 'Biryani') {
        _filteredProducts = _restaurantProducts
            .where((product) => product.subcategoryId == 'food_biryani')
            .toList();
      } else if (category == 'Main Course') {
        _filteredProducts = _restaurantProducts
            .where((product) => product.productType == 'main_course')
            .toList();
      } else if (category == 'Breads') {
        _filteredProducts = _restaurantProducts
            .where((product) => product.productType == 'bread')
            .toList();
      } else if (category == 'Desserts') {
        _filteredProducts = _restaurantProducts
            .where((product) => product.productType == 'dessert')
            .toList();
      } else if (category == 'Beverages') {
        _filteredProducts = _restaurantProducts
            .where((product) => product.productType == 'beverage')
            .toList();
      } else {
        _filteredProducts = _restaurantProducts;
      }
    });
  }

  void _onFavoriteToggle(ProductModel product) {
    if (FavoritesController.isProductFavorite(product.id)) {
      FavoritesController.removeFromGlobalFavorites(product.id);
    } else {
      FavoritesController.addToGlobalFavorites(product.id);
    }

    final isFavorite = FavoritesController.isProductFavorite(product.id);
    final updatedProduct = product.copyWith(isFavorite: isFavorite);

    final restaurantIndex = _restaurantProducts.indexWhere(
      (p) => p.id == product.id,
    );
    if (restaurantIndex != -1) {
      setState(() {
        _restaurantProducts[restaurantIndex] = updatedProduct;
      });
    }

    final filteredIndex = _filteredProducts.indexWhere(
      (p) => p.id == product.id,
    );
    if (filteredIndex != -1) {
      setState(() {
        _filteredProducts[filteredIndex] = updatedProduct;
      });
    }

    Get.snackbar(
      isFavorite ? 'Added to Favorites' : 'Removed from Favorites',
      '${updatedProduct.title} ${isFavorite ? 'added to' : 'removed from'} favorites',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _onAddToCart(ProductModel product) {
    try {
      final cartController = Get.find<CartController>();
      cartController.addToCart(product);

      Get.snackbar(
        'Added to Cart',
        '${product.title} added to your cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Added to Cart',
        '${product.title} added to your cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _onProductTap(ProductModel product) {
    Get.toNamed(AppRoute.getProductDetails(), arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureNavBarHeight());
    const double cartMargin = 16.0;

    return CartAnimationWrapper(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Stack(
            children: [
              Column(
                children: [
                  CommonAppBar(
                    title: restaurant.name,
                    showBackButton: true,
                    showNotification: false,
                    showProfile: false,
                    onBackTap: () => Get.back(),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 64.w,
                          height: 64.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B0F0F),
                            borderRadius: BorderRadius.circular(32.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32.r),
                            child: Image.asset(
                              restaurant.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.restaurant,
                                  color: Colors.white,
                                  size: 32,
                                );
                              },
                            ),
                          ),
                        ),

                        SizedBox(width: 16.w),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                restaurant.name,
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF211F1F),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${restaurant.cuisines.join(', ')}. ${restaurant.address}',
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF929292),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        Container(
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
                                    hintText: 'Search for "Biryani"',
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

                        SizedBox(height: 16.h),

                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.sort,
                                    size: 18.sp,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'Sort',
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

                            SizedBox(width: 8.w),

                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.filter_list,
                                    size: 18.sp,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'Filter',
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
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  SizedBox(
                    height: 30.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = category == _selectedCategory;

                        return GestureDetector(
                          onTap: () => _filterProducts(category),
                          child: Container(
                            margin: EdgeInsets.only(right: 8.w),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.beakYellow
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(4.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              category,
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

                  SizedBox(height: 24.h),

                  Expanded(
                    child: AnimatedBuilder(
                      animation: _navController,
                      builder: (context, _) {
                        final inset = _navController.value * _navBarHeight;
                        return Padding(
                          padding: EdgeInsets.only(bottom: inset),
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _filteredProducts.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.restaurant_menu,
                                        size: 64.sp,
                                        color: const Color(0xFFB8B8B8),
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        'No items found',
                                        style: getTextStyle(
                                          font: CustomFonts.obviously,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFFB8B8B8),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.only(bottom: 8.h),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Color(0xFFEDEDED),
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Popular Foods From This Restaurant',
                                          style: getTextStyle(
                                            font: CustomFonts.obviously,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF211F1F),
                                          ),
                                        ),
                                      ),
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 12.w,
                                              mainAxisSpacing: 12.h,
                                              childAspectRatio: 0.78,
                                            ),
                                        itemCount: _filteredProducts.length,
                                        itemBuilder: (context, index) {
                                          final product =
                                              _filteredProducts[index];
                                          return UnifiedProductCard(
                                            product: product,
                                            onTap: () => _onProductTap(product),
                                            onAddToCart: () =>
                                                _onAddToCart(product),
                                            onFavoriteToggle: () =>
                                                _onFavoriteToggle(product),
                                            variant:
                                                ProductCardVariant.category,
                                            isGroceryCategory: false,
                                          );
                                        },
                                      ),

                                      SizedBox(height: 120.h),
                                    ],
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Navigation bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: KeyedSubtree(
                  key: _navKey,
                  child: CustomNavBar(
                    currentIndex: -1, // No active tab for restaurant details
                    onTap: _onNavItemTapped,
                  ),
                ),
              ),

              // Floating cart button
              AnimatedBuilder(
                animation: _navController,
                builder: (context, _) {
                  final inset =
                      (_navController.value * _navBarHeight) + cartMargin;
                  return FloatingCartButton(bottomInset: inset);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
