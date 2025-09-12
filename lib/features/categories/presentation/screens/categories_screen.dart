import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';
import 'package:quikle_user/features/home/controllers/home_controller.dart';
import 'package:quikle_user/features/home/presentation/widgets/categories/categories_section.dart';
import 'package:quikle_user/features/home/presentation/widgets/products/product_item.dart';
import 'package:quikle_user/features/home/presentation/widgets/products/product_section.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      appBar: CommonAppBar(
        onNotificationTap: controller.onNotificationPressed,
        title: 'All Categories',
        showBackButton: false,
      ),
      body: Obx(
        () => controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    CategoriesSection(
                      categories: controller.categories,
                      onCategoryTap: controller.onCategoryPressed,
                      selectedCategoryId: controller.selectedCategoryId,
                      showTitle: false,
                    ),
                    const SizedBox(height: 20),
                    if (controller.isShowingAllCategories) ...[
                      Column(
                        children: controller.productSections
                            .map(
                              (section) => ProductSection(
                                section: section,
                                onProductTap: controller.onProductPressed,
                                onAddToCart: controller.onAddToCartPressed,
                                onViewAllTap: () => controller.onViewAllPressed(
                                  section.categoryId,
                                ),
                                categoryIconPath: controller
                                    .getCategoryIconPath(section.categoryId),
                                categoryTitle: controller.getCategoryTitle(
                                  section.categoryId,
                                ),
                                onFavoriteToggle: controller.onFavoriteToggle,
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
                              const SizedBox(height: 16),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 0.65.h,
                                      crossAxisSpacing: 12.w,
                                      mainAxisSpacing: 12.w,
                                    ),
                                itemCount: controller.filteredProducts.length,
                                itemBuilder: (context, index) => ProductItem(
                                  product: controller.filteredProducts[index],
                                  onTap: () => controller.onProductPressed(
                                    controller.filteredProducts[index],
                                  ),
                                  onAddToCart: () =>
                                      controller.onAddToCartPressed(
                                        controller.filteredProducts[index],
                                      ),
                                  onFavoriteToggle: () =>
                                      controller.onFavoriteToggle(
                                        controller.filteredProducts[index],
                                      ),
                                ),
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
    );
  }
}
