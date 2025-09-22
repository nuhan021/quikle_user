import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/restaurants/data/models/restaurant_model.dart';
import 'package:quikle_user/features/restaurants/presentation/widgets/restaurant_card.dart';

class TopRestaurantsSection extends StatelessWidget {
  final List<RestaurantModel> restaurants;
  final Function(RestaurantModel) onRestaurantTap;
  final String title;

  const TopRestaurantsSection({
    super.key,
    required this.restaurants,
    required this.onRestaurantTap,
    this.title = 'Top Restaurants',
  });

  @override
  Widget build(BuildContext context) {
    if (restaurants.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getTextStyle(
            font: CustomFonts.obviously,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.ebonyBlack,
          ),
        ),
        SizedBox(height: 16.h),

        SizedBox(
          height: 300.h, // enough height for 2 rows
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 rows
              mainAxisSpacing: 8.w,
              crossAxisSpacing: 8.h,
              childAspectRatio: 0.8, // adjust width/height ratio
            ),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return RestaurantCard(
                restaurant: restaurant,
                onTap: () => onRestaurantTap(restaurant),
              );
            },
          ),
        ),
      ],
    );
  }
}
