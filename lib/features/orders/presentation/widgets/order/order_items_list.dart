import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';

class OrderItemsList extends StatelessWidget {
  final OrderModel order;

  const OrderItemsList({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Items',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.ebonyBlack,
            ),
          ),
          SizedBox(height: 12.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (context, index) =>
                Divider(height: 24.h, color: const Color(0xFFEEEEEE)),
            itemBuilder: (context, index) {
              final item = order.items[index];
              final unitPrice = double.parse(
                item.product.price.replaceAll('₹', '').trim(),
              );
              final lineTotal = unitPrice * item.quantity;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        item.product.imagePath,
                        fit: BoxFit.cover,
                        width: 60.w,
                        height: 60.w,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFF5F5F5),
                            child: Image.asset(
                              ImagePath.logo,
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;

                          return Center(
                            child: SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  AppColors.beakYellow,
                                ),
                              ),
                            ),
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
                          item.product.title,
                          style: getTextStyle(
                            font: CustomFonts.obviously,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.ebonyBlack,
                          ),
                        ),
                        if (item.product.description.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Text(
                            item.product.description,
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF7C7C7C),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Qty: ${item.quantity}',
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.ebonyBlack,
                              ),
                            ),
                            Text(
                              '₹${lineTotal.toStringAsFixed(2)}',
                              style: getTextStyle(
                                font: CustomFonts.obviously,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ebonyBlack,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
