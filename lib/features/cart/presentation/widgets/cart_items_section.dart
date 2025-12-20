import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';

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
          // Padding(
          //   padding: EdgeInsets.all(16.w),
          //   child: Text(
          //     'Delivery in 16 minutes',
          //     style: getTextStyle(
          //       font: CustomFonts.obviously,
          //       fontSize: 16.sp,
          //       fontWeight: FontWeight.w500,
          //       color: AppColors.ebonyBlack,
          //     ),
          //   ),
          // ),
          Obx(() {
            return ListView.builder(
              padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cartController.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartController.cartItems[index];
                final isLast = index == cartController.cartItems.length - 1;
                bool isMedicine = cartItem.isUrgent;
                return Container(
                  margin: EdgeInsets.only(
                    left: 8.w,
                    right: 8.w,
                    bottom: isLast ? 0 : 8.h,
                  ),
                  padding: EdgeInsets.only(right: 8.w),
                  decoration: BoxDecoration(
                    color: AppColors.homeGrey,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 70.w,
                        height: 70.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child:
                              (cartItem.product.imagePath != null &&
                                  cartItem.product.imagePath.isNotEmpty &&
                                  (cartItem.product.imagePath.startsWith(
                                        'http',
                                      ) ||
                                      cartItem.product.imagePath.startsWith(
                                        'https',
                                      )))
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.network(
                                    cartItem.product.imagePath,
                                    fit: BoxFit.contain,
                                    width: 65.w,
                                    height: 65.h,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        ImagePath.logo,
                                        fit: BoxFit.contain,
                                        // color: Colors.grey,
                                      );
                                    },
                                  ),
                                )
                              : Image.asset(
                                  ImagePath.logo,
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ),
                      // SizedBox(width: 4.w),
                      Container(
                        width: 1.w,
                        height: 80.h,
                        color: Colors.grey[400],
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    cartItem.product.title,
                                    style: getTextStyle(
                                      font: CustomFonts.inter,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.ebonyBlack,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                if (isMedicine)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6.w,
                                      vertical: 3.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.red.withValues(alpha: 0.15),
                                          Colors.red.withValues(alpha: 0.08),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(6.r),
                                      border: Border.all(
                                        color: Colors.red.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 12.sp,
                                          color: Colors.red[700],
                                        ),
                                        SizedBox(width: 3.w),
                                        Text(
                                          'URGENT',
                                          style: getTextStyle(
                                            font: CustomFonts.inter,
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.red[700]!,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      '${cartItem.product.price} x ${cartItem.quantity} = ${cartItem.totalPrice.toStringAsFixed(2)}',
                                      style: getTextStyle(
                                        font: CustomFonts.inter,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ebonyBlack,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),

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
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.ebonyBlack.withOpacity(0.15),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildControlButton(icon: Icons.remove, onTap: onDecrease),
          Container(
            constraints: BoxConstraints(minWidth: 32.w),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Center(
              child: Text(
                '$quantity',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.beakYellow,
                ),
              ),
            ),
          ),
          _buildControlButton(icon: Icons.add, onTap: onIncrease),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, size: 12.sp, color: AppColors.beakYellow),
      ),
    );
  }
}
