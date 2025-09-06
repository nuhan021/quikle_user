import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/categories/controllers/unified_category_controller.dart';

class UnifiedCategoryScreen extends StatelessWidget {
  const UnifiedCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UnifiedCategoryController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.ebonyBlack),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Text(
          controller.categoryTitle.value,
          style: getTextStyle(
            font: CustomFonts.obviously,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.ebonyBlack,
          ),
        )),
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

              // Category/Subcategory Selection Section
              if (controller.availableSubcategories.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Obx(() => Text(
                    controller.sectionTitle.value.isNotEmpty 
                        ? controller.sectionTitle.value
                        : (controller.isGroceryCategory 
                            ? (controller.selectedMainCategory.value == null 
                                ? 'Select Category' 
                                : 'Select from ${controller.selectedMainCategory.value!.title}')
                            : 'Popular Items'),
                    style: getTextStyle(
                      font: CustomFonts.obviously,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ebonyBlack,
                    ),
                  )),
                ),
                SizedBox(height: 16.h),
                
                // Horizontal scrolling category/subcategory selection
                SizedBox(
                  height: 120.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: controller.availableSubcategories.length,
                    itemBuilder: (context, index) {
                      final subcategory = controller.availableSubcategories[index];
                      final isSelected = controller.selectedMainCategory.value?.id == subcategory.id ||
                                        controller.selectedSubcategory.value?.id == subcategory.id;
                      
                      return Container(
                        width: 100.w,
                        margin: EdgeInsets.only(right: 16.w),
                        child: GestureDetector(
                          onTap: () => controller.onSubcategoryTap(subcategory),
                          child: Column(
                            children: [
                              Container(
                                width: 80.w,
                                height: 80.h,
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? AppColors.beakYellow.withOpacity(0.2)
                                      : AppColors.homeGrey,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: isSelected 
                                        ? AppColors.beakYellow 
                                        : AppColors.cardColor,
                                    width: 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Image.asset(
                                    subcategory.iconPath,
                                    width: 40.w,
                                    height: 40.h,
                                    fit: BoxFit.scaleDown,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                subcategory.title,
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize: 12.sp,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  color: isSelected ? AppColors.beakYellow : AppColors.ebonyBlack,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 24.h),
              ],

              // Back to main categories button for groceries
              if (controller.isGroceryCategory && controller.selectedMainCategory.value != null) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: GestureDetector(
                    onTap: () => controller.resetToMainCategories(),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: AppColors.homeGrey,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.cardColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back, size: 16.sp, color: AppColors.ebonyBlack),
                          SizedBox(width: 8.w),
                          Text(
                            'Back to All Categories',
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.ebonyBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],

              // Filter chips for subcategories (when main category is selected)
              if (controller.filterSubcategories.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'Filter by:',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ebonyBlack,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  height: 40.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: controller.filterSubcategories.length + 1, // +1 for "All"
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // "All" filter
                        final isSelected = controller.selectedFilter.value == null;
                        return GestureDetector(
                          onTap: () => controller.applyFilter(null),
                          child: Container(
                            margin: EdgeInsets.only(right: 8.w),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.beakYellow : AppColors.homeGrey,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              'All',
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : AppColors.ebonyBlack,
                              ),
                            ),
                          ),
                        );
                      }
                      
                      final subcategory = controller.filterSubcategories[index - 1];
                      final isSelected = controller.selectedFilter.value == subcategory.id;
                      
                      return GestureDetector(
                        onTap: () => controller.applyFilter(subcategory.id),
                        child: Container(
                          margin: EdgeInsets.only(right: 8.w),
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.beakYellow : AppColors.homeGrey,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            subcategory.title,
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : AppColors.ebonyBlack,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 24.h),
              ],

              // Products Section
              if (controller.displayProducts.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.productsTitle.value,
                        style: getTextStyle(
                          font: CustomFonts.obviously,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ebonyBlack,
                        ),
                      ),
                      Text(
                        '${controller.displayProducts.length} items',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.featherGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                
                // Products Grid
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
                  itemCount: controller.displayProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.displayProducts[index];
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
                              child: Stack(
                                children: [
                                  Container(
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
                                  Positioned(
                                    top: 8.h,
                                    right: 8.w,
                                    child: GestureDetector(
                                      onTap: () => controller.onFavoriteToggle(product),
                                      child: Container(
                                        width: 28.w,
                                        height: 28.h,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          product.isFavorite 
                                              ? Icons.favorite 
                                              : Icons.favorite_border,
                                          color: product.isFavorite 
                                              ? Colors.red 
                                              : AppColors.featherGrey,
                                          size: 18.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Rating badge
                                  Positioned(
                                    top: 8.h,
                                    left: 8.w,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.success,
                                        borderRadius: BorderRadius.circular(10.r),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 10.sp,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 2.w),
                                          Text(
                                            product.rating.toString(),
                                            style: getTextStyle(
                                              font: CustomFonts.inter,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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
                                    if (product.weight != null) ...[
                                      SizedBox(height: 4.h),
                                      Text(
                                        product.weight!,
                                        style: getTextStyle(
                                          font: CustomFonts.inter,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.featherGrey,
                                        ),
                                      ),
                                    ],
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
                                          onTap: () => controller.onAddToCart(product),
                                          child: Container(
                                            width: 30.w,
                                            height: 30.h,
                                            decoration: BoxDecoration(
                                              color: AppColors.beakYellow,
                                              borderRadius: BorderRadius.circular(6.r),
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                ImagePath.cartIcon,
                                                width: 18.w,
                                                height: 18.h,
                                                fit: BoxFit.cover,
                                                filterQuality: FilterQuality.high,
                                              ),
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
              ] else if (!controller.isLoading.value && controller.availableSubcategories.isEmpty) ...[
                // Empty state
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 60.h),
                      Icon(
                        Icons.shopping_basket_outlined,
                        size: 80.sp,
                        color: AppColors.featherGrey,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No items found',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.featherGrey,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Select a category to see products',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.featherGrey,
                        ),
                      ),
                    ],
                  ),
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
