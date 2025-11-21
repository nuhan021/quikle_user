import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
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
          // Shop Logo
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: shop.image.startsWith('http')
                ? Image.network(
                    shop.image,
                    width: 48.w,
                    height: 48.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/shopImage.png',
                        width: 48.w,
                        height: 48.h,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    shop.image,
                    width: 48.w,
                    height: 48.h,
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(width: 12.w),
          // Shop Name
          Expanded(
            child: Text(
              shop.name,
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.ebonyBlack,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
