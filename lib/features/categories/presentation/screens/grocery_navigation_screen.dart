import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/core/common/widgets/floating_cart_button.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/categories/controllers/grocery_navigation_controller.dart';
import 'package:quikle_user/features/categories/presentation/widgets/popular_items_section.dart';

class GroceryNavigationScreen extends StatelessWidget {
  const GroceryNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GroceryNavigationController());

    return CartAnimationWrapper(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: [
                AppBar(
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
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16.h),

                          
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

                          
                          if (controller.popularSubcategories.isNotEmpty) ...[
                            PopularItemsSection(
                              subcategories: controller.popularSubcategories,
                              onSubcategoryTap: controller.onSubcategoryTap,
                            ),
                            SizedBox(height: 24.h),
                          ],

                          
                          if (controller.currentSubcategories.isNotEmpty) ...[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.currentLevel.value == 0
                                        ? 'Shop by Category'
                                        : 'Browse ${controller.currentTitle.value}',
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 12.w,
                                          mainAxisSpacing: 12.h,
                                          childAspectRatio: 2.5,
                                        ),
                                    itemCount:
                                        controller.currentSubcategories.length,
                                    itemBuilder: (context, index) {
                                      final subcategory = controller
                                          .currentSubcategories[index];
                                      return GestureDetector(
                                        onTap: () => controller
                                            .onSubcategoryTap(subcategory),
                                        child: Container(
                                          padding: EdgeInsets.all(12.w),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withValues(
                                                  alpha: 0.1,
                                                ),
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
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12.w,
                                    mainAxisSpacing: 12.h,
                                    childAspectRatio: 0.75,
                                  ),
                              itemCount: controller.currentProducts.length,
                              itemBuilder: (context, index) {
                                final product =
                                    controller.currentProducts[index];
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                filterQuality:
                                                    FilterQuality.high,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: EdgeInsets.all(12.w),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const Spacer(),
                                                Row(
                                                  children: [
                                                    Text(
                                                      product.price,
                                                      style: getTextStyle(
                                                        font: CustomFonts.inter,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppColors
                                                            .ebonyBlack,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    GestureDetector(
                                                      onTap: () => controller
                                                          .onAddToCart(product),
                                                      child: Container(
                                                        width: 30.w,
                                                        height: 30.h,
                                                        decoration: BoxDecoration(
                                                          color: AppColors
                                                              .beakYellow,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                6.r,
                                                              ),
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
                ),
              ],
            ),
            
            const FloatingCartButton(),
          ],
        ),
      ),
    );
  }
}
