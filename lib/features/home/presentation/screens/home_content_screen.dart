import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/features/home/presentation/widgets/app_bar/home_app_bar.dart';
import 'package:quikle_user/features/home/presentation/widgets/banners/offer_banner.dart';
import 'package:quikle_user/features/home/presentation/widgets/categories/categories_section.dart';
import 'package:quikle_user/features/home/presentation/widgets/products/product_section.dart';
import '../widgets/search/search_bar.dart' as custom_search;
import '../../controllers/home_controller.dart';

class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    
    final double headerHeight = 0.20.sh;

    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      body: Obx(
        () => controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: AppColors.homeGrey,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    floating: false,
                    snap: false,
                    pinned: false,
                    toolbarHeight: kToolbarHeight,
                    titleSpacing: 0,
                    title: HomeAppBar(
                      onNotificationTap: controller.onNotificationPressed,
                    ),
                  ),

                  
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _FixedHeaderDelegate(
                      height: headerHeight,
                      child: Column(
                        children: [
                          custom_search.SearchBar(
                            onTap: controller.onSearchPressed,
                            onVoiceTap: controller.onVoiceSearchPressed,
                          ),
                          Expanded(
                            child: CategoriesSection(
                              categories: controller.categories,
                              onCategoryTap: controller.onCategoryPressed,
                              selectedCategoryId: controller.selectedCategoryId,
                              showTitle: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 12),
                      Center(child: OfferBanner()),
                      const SizedBox(height: 12),
                      if (controller.isShowingAllCategories)
                        Column(
                          children: controller.productSections
                              .map(
                                (section) => ProductSection(
                                  section: section,
                                  onProductTap: controller.onProductPressed,
                                  onAddToCart: controller.onAddToCartPressed,
                                  onViewAllTap: () => controller
                                      .onViewAllPressed(section.categoryId),
                                  categoryIconPath: controller
                                      .getCategoryIconPath(section.categoryId),
                                  categoryTitle: controller.getCategoryTitle(
                                    section.categoryId,
                                  ),
                                  onFavoriteToggle: controller.onFavoriteToggle,
                                ),
                              )
                              .toList(),
                        )
                      else
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (controller.filteredProducts.isNotEmpty)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.categories
                                          .firstWhere(
                                            (cat) =>
                                                cat.id ==
                                                controller.selectedCategoryId,
                                          )
                                          .title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => controller.onViewAllPressed(
                                        controller.selectedCategoryId,
                                      ),
                                      child: const Text(
                                        'View all',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFFF6B35),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              else
                                const Center(
                                  child: Text(
                                    'No products found for this category',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ]),
                  ),
                ],
              ),
      ),
    );
  }
}

class _FixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  _FixedHeaderDelegate({required this.child, required this.height}) {
    
    appBarVisibleNotifier = ValueNotifier<bool>(true);
  }

  final Widget child;
  final double height;

  late final ValueNotifier<bool> appBarVisibleNotifier;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final bool appBarVisible = !(overlapsContent || shrinkOffset > 0.0);

    
    if (appBarVisibleNotifier.value != appBarVisible) {
      appBarVisibleNotifier.value = appBarVisible;
    }

    return ValueListenableBuilder<bool>(
      valueListenable: appBarVisibleNotifier,
      builder: (context, isVisible, _) {
        return Container(
          color: AppColors.homeGrey,
          padding: isVisible
              ? EdgeInsets.zero
              : EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: SizedBox.expand(child: child),
        );
      },
    );
  }

  @override
  bool shouldRebuild(_FixedHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
