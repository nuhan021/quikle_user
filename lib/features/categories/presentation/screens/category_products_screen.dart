import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/widgets/address_widget.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/core/common/widgets/custom_navbar.dart';
import 'package:quikle_user/core/common/widgets/floating_cart_button.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/navigation/navbar_navigation_helper.dart';
import 'package:quikle_user/features/categories/controllers/category_products_controller.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';
import 'package:quikle_user/features/categories/presentation/widgets/search_and_filters_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/category_product_item.dart';
import 'package:quikle_user/features/categories/presentation/widgets/minimal_subcategories_section.dart';

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

  @override
  void initState() {
    super.initState();
    _navController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      value: 1.0,
    );
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
    if (index == 2) {
      return;
    }
    NavbarNavigationHelper.navigateToTab(index);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureNavBarHeight());
    const double cartMargin = 16.0;

    final controller = Get.put(CategoryProductsController());
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
                      showNotification: false,
                      showProfile: false,
                      onBackTap: () => Get.back(),
                      addressWidget: AddressWidget(),
                    ),
                  ),

                  Expanded(
                    child: AnimatedBuilder(
                      animation: _navController,
                      builder: (context, _) {
                        final inset = _navController.value * _navBarHeight;
                        return Padding(
                          padding: EdgeInsets.only(bottom: inset),
                          child: Obx(() {
                            if (controller.isLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return Column(
                              children: [
                                // Search section
                                SearchAndFiltersSection(
                                  searchController: searchController,
                                  onSearchChanged: controller.onSearchChanged,
                                  onVoiceTap: () {},
                                  dynamicHint: controller.currentPlaceholder,
                                ),

                                // Minimal subcategories section
                                MinimalSubcategoriesSection(
                                  subcategories: controller.subcategories,
                                  selectedSubcategory:
                                      controller.selectedSubcategory.value,
                                  onSubcategoryTap: controller.onSubcategoryTap,
                                ),

                                // Products grid
                                Expanded(child: _buildProductsGrid(controller)),
                              ],
                            );
                          }),
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
                    currentIndex: 2, // Categories tab index
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

  Widget _buildProductsGrid(CategoryProductsController controller) {
    if (controller.displayProducts.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Text(
            'No products available',
            style: TextStyle(color: AppColors.featherGrey, fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(8.w), // Reduced padding for more product space
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // More items per row for compact layout
          crossAxisSpacing: 6.w,
          mainAxisSpacing: 6.h,
          childAspectRatio: 0.7, // Slightly taller for better product display
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
