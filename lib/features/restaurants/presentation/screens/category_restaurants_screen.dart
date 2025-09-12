import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/restaurants/data/models/restaurant_model.dart';
import 'package:quikle_user/features/restaurants/presentation/widgets/restaurant_card.dart';

class CategoryRestaurantsScreen extends StatelessWidget {
  const CategoryRestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final arguments = Get.arguments as Map<String, dynamic>;
    final String categoryName = arguments['categoryName'] ?? 'Restaurants';
    final String categoryId = arguments['categoryId'] ?? '';
    final List<RestaurantModel> restaurants = arguments['restaurants'] ?? [];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.homeGrey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.ebonyBlack,
              size: 24.sp,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            '$categoryName Restaurants',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.ebonyBlack,
            ),
          ),
          centerTitle: true,
        ),
        body: restaurants.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 64.sp,
                      color: AppColors.featherGrey,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No restaurants found',
                      style: getTextStyle(
                        font: CustomFonts.obviously,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.featherGrey,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'for $categoryName',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.featherGrey,
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Text(
                      '${restaurants.length} restaurants serving $categoryName',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.featherGrey,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 0.75, 
                        ),
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = restaurants[index];
                          return RestaurantCard(
                            restaurant: restaurant,
                            onTap: () {
                              
                              Get.toNamed(
                                '/restaurant-menu',
                                arguments: {
                                  'restaurant': restaurant,
                                  'categoryId': categoryId,
                                  'categoryName': categoryName,
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
