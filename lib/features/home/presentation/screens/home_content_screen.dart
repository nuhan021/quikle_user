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

    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      appBar: HomeAppBar(onNotificationTap: controller.onNotificationPressed),
      body: Obx(
        () => controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Fixed header with search bar and categories
                  Container(
                    color: AppColors.homeGrey,
                    child: Column(
                      children: [
                        custom_search.SearchBar(
                          onTap: controller.onSearchPressed,
                          onVoiceTap: controller.onVoiceSearchPressed,
                        ),
                        CategoriesSection(
                          categories: controller.categories,
                          onCategoryTap: controller.onCategoryPressed,
                          selectedCategoryId: controller.selectedCategoryId,
                          showTitle: true,
                        ),
                      ],
                    ),
                  ),
                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Center(child: OfferBanner()),
                          const SizedBox(height: 24),
                          if (controller.isShowingAllCategories) ...[
                            Column(
                              children: controller.productSections
                                  .map(
                                    (section) => ProductSection(
                                      section: section,
                                      onProductTap: controller.onProductPressed,
                                      onAddToCart:
                                          controller.onAddToCartPressed,
                                      onViewAllTap: () => controller
                                          .onViewAllPressed(section.categoryId),
                                      categoryIconPath: controller
                                          .getCategoryIconPath(
                                            section.categoryId,
                                          ),
                                      categoryTitle: controller
                                          .getCategoryTitle(section.categoryId),
                                      onFavoriteToggle:
                                          controller.onFavoriteToggle,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ] else ...[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (controller
                                      .filteredProducts
                                      .isNotEmpty) ...[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          controller.categories
                                              .firstWhere(
                                                (cat) =>
                                                    cat.id ==
                                                    controller
                                                        .selectedCategoryId,
                                              )
                                              .title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              controller.onViewAllPressed(
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
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
