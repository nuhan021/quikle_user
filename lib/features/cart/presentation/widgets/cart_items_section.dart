import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';

import '../../controllers/cart_controller.dart';

class CartItemsSection extends StatelessWidget {
  const CartItemsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'Delivery in 16 minutes',
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.ebonyBlack,
              ),
            ),
          ),
          Obx(() {
            return ListView.builder(
              padding: EdgeInsets.only(bottom: 8.h),
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cartController.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartController.cartItems[index];
                final isLast = index == cartController.cartItems.length - 1;

                return Container(
                  margin: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    bottom: isLast ? 0 : 8.h,
                  ),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.homeGrey,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Image.asset(
                            cartItem.product.imagePath,
                            width: 40.w,
                            height: 40.w,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.shopping_basket,
                                color: Colors.grey[400],
                                size: 30.sp,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        width: 1.w,
                        height: 80.h,
                        color: Colors.grey[400],
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItem.product.title,
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.ebonyBlack,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              cartItem.product.price,
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ebonyBlack,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              '${cartItem.quantity} unit',
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.ebonyBlack,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                Text(
                                  'Add to favourite',
                                  style: getTextStyle(
                                    font: CustomFonts.inter,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.featherGrey,
                                  ),
                                ),
                                const Spacer(),
                                _buildQuantityControls(
                                  cartItem.quantity,
                                  () =>
                                      cartController.decreaseQuantity(cartItem),
                                  () =>
                                      cartController.increaseQuantity(cartItem),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuantityControls(
    int quantity,
    VoidCallback onDecrease,
    VoidCallback onIncrease,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.ebonyBlack,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onDecrease,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              child: Text(
                '-',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.beakYellow,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            child: Text(
              '$quantity',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.beakYellow,
              ),
            ),
          ),
          GestureDetector(
            onTap: onIncrease,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              child: Text(
                '+',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.beakYellow,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
