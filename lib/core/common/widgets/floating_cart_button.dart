import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/cart/presentation/screens/cart_screen.dart';
import 'package:quikle_user/core/services/cart_position_service.dart';

class FloatingCartButton extends StatefulWidget {
  const FloatingCartButton({super.key, this.bottomInset = 16.0});
  final double bottomInset;

  @override
  State<FloatingCartButton> createState() => _FloatingCartButtonState();
}

class _FloatingCartButtonState extends State<FloatingCartButton> {
  final GlobalKey _cartButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final positionService = Get.find<CartPositionService>();
        positionService.setCartButtonKey(_cartButtonKey);
      } catch (e) {
        Get.put(CartPositionService()).setCartButtonKey(_cartButtonKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final double systemBottomInset = MediaQuery.of(context).viewPadding.bottom;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final positionService = Get.find<CartPositionService>();
        positionService.setCartButtonKey(_cartButtonKey);
      } catch (e) {}
    });

    return Obx(() {
      if (!cartController.hasItems) {
        return const SizedBox.shrink();
      }

      final double bottomPadding = widget.bottomInset + systemBottomInset + 4.h;

      return Padding(
        padding: EdgeInsets.only(bottom: bottomPadding, right: 16.w),
        child: Align(
          alignment: Alignment.bottomRight,
          child: GestureDetector(
            key: _cartButtonKey,
            onTap: () => Get.to(() => const CartScreen()),
            child: SizedBox(
              width: 64.w,
              height: 64.w,
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(ImagePath.cartImage, fit: BoxFit.cover),
                  ),
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
        ),
      );
    });
  }
}
