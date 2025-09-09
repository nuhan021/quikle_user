import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/enums/font_enum.dart';

class OrderItemWidget extends StatelessWidget {
  final dynamic item;

  const OrderItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                item.product.imagePath,

                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return SizedBox(
                    width: 60.w,
                    height: 60.h,
                    //color: const Color(0xFFC23737),
                    child: Icon(Icons.image, color: Colors.white, size: 24.r),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product?.title ?? 'Product Name',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ebonyBlack,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${item.product.title} x ${item.quantity ?? 1}',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF919191),
                        ),
                      ),
                      TextSpan(
                        text: ' - ',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w200,
                          color: AppColors.ebonyBlack,
                        ),
                      ),
                      TextSpan(
                        text: '${item.product?.price ?? '0.00'}',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF929292),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
