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
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final double? fontSize;
  final double? iconSize;
  final double? borderRadius;
  final bool enableCartAnimation;
  final String? productImagePath;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.fontSize,
    this.iconSize,
    this.borderRadius,
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
    } catch (_) {}
  }

  void _handleIncrease() {
    // Perform increase first so that any UI (floating cart) updates are applied,
    // then trigger the animation in a post-frame callback to ensure the
    // cart position is available.
    widget.onIncrease();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _triggerCartAnimation(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22.w,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? const Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildButton(icon: Icons.remove, onTap: widget.onDecrease),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              widget.quantity.toString(),
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: widget.fontSize ?? 10.sp,
                fontWeight: FontWeight.w600,
                color: widget.textColor ?? Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _buildButton(
            key: _plusButtonKey,
            icon: Icons.add,
            onTap: _handleIncrease,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    Key? key,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      key: key,
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 18.w,
        height: double.infinity,
        child: Center(
          child: Icon(
            icon,
            color: widget.iconColor ?? Colors.white,
            size: widget.iconSize ?? 12.sp,
          ),
        ),
      ),
    );
  }
}
