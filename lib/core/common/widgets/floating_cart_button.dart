import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/cart/presentation/screens/cart_screen.dart';

class FloatingCartButton extends StatelessWidget {
  const FloatingCartButton({super.key, this.bottomInset = 16.0});
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Obx(() {
      if (!cartController.hasItems) {
        return const SizedBox.shrink();
      }

      return Positioned(
        bottom: MediaQuery.of(context).padding.bottom + 80.h,
        right: 16.w,
        child: GestureDetector(
          onTap: () => Get.to(() => const CartScreen()),
          child: SizedBox(
            width: 56.w,
            height: 56.w,
            child: Stack(
              children: [
                // Cart Icon
                Center(
                  child: Image.asset(ImagePath.cartImage, fit: BoxFit.cover),
                ),
                // Badge
                Positioned(
                  right: 8.w,
                  top: 8.h,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16.w,
                      minHeight: 16.h,
                    ),
                    child: Text(
                      '${cartController.totalItems}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
