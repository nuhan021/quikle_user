import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import 'package:quikle_user/features/categories/controllers/grocery_navigation_controller.dart';
import 'package:quikle_user/features/categories/presentation/widgets/popular_items_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/subcategory_grid_section.dart';

class GroceryNavigationScreen extends StatelessWidget {
  const GroceryNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GroceryNavigationController());

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
            controller.currentTitle.value,
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.ebonyBlack,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(() {
            if (controller.canGoBack.value) {
              return IconButton(
                icon: Icon(Icons.home, color: AppColors.ebonyBlack),
                onPressed: controller.goToMainCategories,
              );
            }
            return const SizedBox();
          }),
        ],
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

              // Breadcrumb
              if (controller.breadcrumb.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.homeGrey,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    controller.breadcrumb.value,
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.featherGrey,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],

              // Popular Items Section (only show for main categories)
              if (controller.popularSubcategories.isNotEmpty) ...[
                PopularItemsSection(
                  subcategories: controller.popularSubcategories,
                  onSubcategoryTap: controller.onSubcategoryTap,
                ),
                SizedBox(height: 24.h),
              ],

              // Subcategories Grid
              if (controller.currentSubcategories.isNotEmpty) ...[
                SubcategoryGridSection(
                  title: controller.currentLevel.value == 0
                      ? 'Shop by Category'
                      : 'Browse ${controller.currentTitle.value}',
                  subcategories: controller.currentSubcategories,
                  onSubcategoryTap: controller.onSubcategoryTap,
                ),
                SizedBox(height: 24.h),
              ],

              // Products Grid (when at final level)
              if (controller.currentProducts.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'Products',
                    style: getTextStyle(
                      font: CustomFonts.obviously,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ebonyBlack,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: controller.currentProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.currentProducts[index];
                    return GestureDetector(
                      onTap: () => controller.onProductTap(product),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.cardColor,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.homeGrey,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.r),
                                    topRight: Radius.circular(12.r),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.r),
                                    topRight: Radius.circular(12.r),
                                  ),
                                  child: Image.asset(
                                    product.imagePath,
                                    fit: BoxFit.scaleDown,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.all(12.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: getTextStyle(
                                        font: CustomFonts.inter,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.ebonyBlack,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        Text(
                                          product.price,
                                          style: getTextStyle(
                                            font: CustomFonts.inter,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.ebonyBlack,
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () =>
                                              controller.onAddToCart(product),
                                          child: Container(
                                            width: 30.w,
                                            height: 30.h,
                                            decoration: BoxDecoration(
                                              color: AppColors.beakYellow,
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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

              SizedBox(height: 24.h),
            ],
          ),
        );
      }),
    );
  }
}
