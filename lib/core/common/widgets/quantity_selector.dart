import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';

class QuantitySelector extends StatefulWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final double? fontSize;
  final double? iconSize;
  final bool enableCartAnimation;
  final String? productImagePath;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.fontSize,
    this.iconSize,
    this.enableCartAnimation = false,
    this.productImagePath,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  final GlobalKey _plusButtonKey = GlobalKey();

  void _triggerCartAnimation() {
    if (!widget.enableCartAnimation || widget.productImagePath == null) return;

    try {
      final controller = Get.find<CartAnimationController>();
      final sourceBox =
          _plusButtonKey.currentContext?.findRenderObject() as RenderBox?;
      if (sourceBox == null) return;

      final topLeft = sourceBox.localToGlobal(Offset.zero);
      final center = Offset(
        topLeft.dx + sourceBox.size.width / 2,
        topLeft.dy + sourceBox.size.height / 2,
      );

      final startSize = sourceBox.size.shortestSide.clamp(24.0, 40.0);

      controller.addCartAnimation(
        imagePath: widget.productImagePath!,
        startPosition: center,
        startSize: startSize,
        fallbackTarget: Offset(
          MediaQuery.of(context).size.width - 48.w,
          MediaQuery.of(context).size.height - 120.h,
        ),
      );
    } catch (e) {
      // Animation failed, continue with normal operation
    }
  }

  void _handleIncrease() {
    _triggerCartAnimation();
    widget.onIncrease();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? const Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 14.r),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Minus button
            GestureDetector(
              onTap: widget.onDecrease,
              child: Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.remove,
                  color: widget.iconColor ?? Colors.white,
                  size: widget.iconSize ?? 16.sp,
                ),
              ),
            ),

            // Quantity display
            Text(
              widget.quantity.toString(),
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: widget.fontSize ?? 14.sp,
                fontWeight: FontWeight.w500,
                color: widget.textColor ?? Colors.white,
              ),
            ),

            // Plus button
            GestureDetector(
              key: _plusButtonKey,
              onTap: _handleIncrease,
              child: Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.add,
                  color: widget.iconColor ?? Colors.white,
                  size: widget.iconSize ?? 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
