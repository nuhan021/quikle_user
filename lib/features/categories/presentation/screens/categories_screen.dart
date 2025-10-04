import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/features/home/controllers/home_controller.dart';
import 'package:quikle_user/features/home/presentation/widgets/categories/categories_section.dart';
import 'package:quikle_user/features/home/presentation/widgets/products/product_section.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';

import '../../../home/presentation/widgets/search/search_bar.dart'
    as custom_search;

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  final HomeController controller = Get.find<HomeController>();
  final ScrollController _scroll = ScrollController();
  late final AnimationController _barAnim;

  @override
  void initState() {
    super.initState();

    _barAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: 1,
    );

    _scroll.addListener(() {
      if (_scroll.offset > 8 && _barAnim.value == 1) {
        _barAnim.reverse();
      } else if (_scroll.offset <= 8 && _barAnim.value == 0) {
        _barAnim.forward();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _barAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRect(
              child: SizeTransition(
                axisAlignment: -1,
                sizeFactor: _barAnim,
                child: const UnifiedProfileAppBar(
                  title: 'All Categories',
                  showBackButton: false,
                ),
              ),
            ),
            custom_search.SearchBar(
              onTap: controller.onSearchPressed,
              onVoiceTap: controller.onVoiceSearchPressed,
            ),
            Obx(
              () => CategoriesSection(
                categories: controller.categories,
                onCategoryTap: controller.onCategoryPressed,
                selectedCategoryId: controller.selectedCategoryId,
                showTitle: true,
              ),
            ),
            SizedBox(height: 4.h),
            Expanded(
              child: Obx(
                () {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final listChildren = <Widget>[];

                  if (controller.isShowingAllCategories) {
                    listChildren.addAll(
                      controller.productSections.map(
                        (section) => ProductSection(
                          section: section,
                          onProductTap: controller.onProductPressed,
                          onAddToCart: controller.onAddToCartPressed,
                          onViewAllTap: () =>
                              controller.onViewAllPressed(section.categoryId),
                          categoryIconPath: controller
                              .getCategoryIconPath(section.categoryId),
                          categoryTitle: controller
                              .getCategoryTitle(section.categoryId),
                          onFavoriteToggle: controller.onFavoriteToggle,
                        ),
                      ),
                    );
                  } else {
                    listChildren.add(
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.filteredProducts.isNotEmpty) ...[
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
                              ),
                            ] else ...[
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
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView(
                    controller: _scroll,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 24.h),
                    children: listChildren,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
