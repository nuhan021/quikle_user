import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import 'package:quikle_user/features/categories/controllers/category_detail_controller.dart';
import 'package:quikle_user/features/categories/presentation/widgets/popular_items_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/product_grid_section.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryDetailController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.ebonyBlack),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Text(
            controller.categoryTitle.value,
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.ebonyBlack,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              if (controller.popularSubcategories.isNotEmpty) ...[
                PopularItemsSection(
                  subcategories: controller.popularSubcategories,
                  onSubcategoryTap: controller.onSubcategoryTap,
                ),
                SizedBox(height: 24.h),
              ],

              if (controller.allSubcategories.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Categories',
                        style: getTextStyle(
                          font: CustomFonts.obviously,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.ebonyBlack,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: controller.allSubcategories.length,
                        itemBuilder: (context, index) {
                          final subcategory =
                              controller.allSubcategories[index];
                          return GestureDetector(
                            onTap: () =>
                                controller.onSubcategoryTap(subcategory),
                            child: Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    subcategory.iconPath,
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      subcategory.title,
                                      style: getTextStyle(
                                        font: CustomFonts.inter,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.ebonyBlack,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
              ],

              // Featured Products Section
              if (controller.featuredProducts.isNotEmpty) ...[
                ProductGridSection(
                  title: 'Featured Products',
                  products: controller.featuredProducts,
                  onProductTap: controller.onProductTap,
                  onAddToCart: controller.onAddToCart,
                  onFavoriteToggle: controller.onFavoriteToggle,
                  maxItems: 6,
                  crossAxisCount: 3,
                ),
                SizedBox(height: 24.h),
              ],

              // Recommended Products Section
              if (controller.recommendedProducts.isNotEmpty) ...[
                ProductGridSection(
                  title: 'Recommended for You',
                  products: controller.recommendedProducts,
                  onProductTap: controller.onProductTap,
                  onAddToCart: controller.onAddToCart,
                  onFavoriteToggle: controller.onFavoriteToggle,
                  maxItems: 8,
                  crossAxisCount: 2,
                ),
              ],

              SizedBox(height: 24.h),
            ],
          ),
        );
      }),
    );
  }
}
