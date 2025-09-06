import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import 'package:quikle_user/features/home/data/models/shop_model.dart';

class StoreInfoWidget extends StatelessWidget {
  final ShopModel shop;

  const StoreInfoWidget({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 20.r, backgroundImage: AssetImage(shop.image)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop.name,
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ebonyBlack,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  shop.deliveryTime,
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    color: AppColors.featherGrey,
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          //   decoration: BoxDecoration(
          //     color: shop.isOpen ? Colors.green : Colors.red,
          //     borderRadius: BorderRadius.circular(6.r),
          //   ),
          //   child: Text(
          //     shop.isOpen ? 'Open' : 'Closed',
          //     style: TextStyle(
          //       fontSize: 10.sp,
          //       fontWeight: FontWeight.w500,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
