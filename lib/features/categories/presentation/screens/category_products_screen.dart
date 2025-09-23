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
import 'package:quikle_user/features/categories/controllers/category_products_controller.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';
import 'package:quikle_user/features/categories/presentation/widgets/search_and_filters_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/category_product_item.dart';
import 'package:quikle_user/features/categories/presentation/widgets/minimal_subcategories_section.dart';
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _measureNavBarHeight());
    const double cartMargin = 16.0;

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
                top: true,
                bottom: false,
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

                    Expanded(
                      child: AnimatedBuilder(
                        animation: _navController,
                        builder: (context, _) {
                          final bottomInset = isKeyboardOpen
                              ? 0.0
                              : _navController.value * _navBarHeight;

                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: bottomInset,
                              left: 16.w,
                              right: 16.w,
                            ),
                            child: Obx(() {
                              if (controller.isLoading.value) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return Column(
                                children: [
                                  SizedBox(height: 8.h),
                                  SearchAndFiltersSection(
                                    searchController: searchController,
                                    onSearchChanged: controller.onSearchChanged,
                                    onVoiceTap: controller.onVoiceSearchPressed,
                                    dynamicHint: controller.currentPlaceholder,
                                  ),
                                  SizedBox(height: 12.h),

                                  MinimalSubcategoriesSection(
                                    subcategories: controller.subcategories,
                                    selectedSubcategory:
                                        controller.selectedSubcategory.value,
                                    onSubcategoryTap:
                                        controller.onSubcategoryTap,
                                    categoryIconPath:
                                        controller.currentCategory.iconPath,
                                  ),

                                  SizedBox(height: 12.h),

                                  Expanded(
                                    child:
                                        NotificationListener<
                                          ScrollNotification
                                        >(
                                          onNotification: (notification) {
                                            if (notification
                                                is UserScrollNotification) {
                                              if (notification.direction ==
                                                      ScrollDirection.reverse &&
                                                  _navController.value != 0.0 &&
                                                  _navController.status !=
                                                      AnimationStatus.reverse) {
                                                _navController.reverse();
                                              } else if (notification
                                                          .direction ==
                                                      ScrollDirection.forward &&
                                                  _navController.value != 1.0 &&
                                                  _navController.status !=
                                                      AnimationStatus.forward) {
                                                _navController.forward();
                                              } else if (notification
                                                      .direction ==
                                                  ScrollDirection.idle) {
                                                if (_navController.value !=
                                                    1.0) {
                                                  _navController.forward();
                                                }
                                              }
                                            }
                                            if (notification
                                                is ScrollEndNotification) {
                                              if (_navController.value != 1.0) {
                                                _navController.forward();
                                              }
                                            }
                                            return false;
                                          },
                                          child: _buildProductsGrid(controller),
                                        ),
                                  ),
                                ],
                              );
                            }),
                          );
                        },
                      ),
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

  Widget _buildProductsGrid(CategoryProductsController controller) {
    if (controller.displayProducts.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Text(
            'No products available',
            style: TextStyle(color: AppColors.featherGrey, fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: GridView.builder(
        controller: _scroll,
        primary: false,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
          childAspectRatio: 0.75,
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
    );
  }
}
