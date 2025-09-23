import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';

class QuantitySelector extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(borderRadius ?? 14.r),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Minus button
            GestureDetector(
              onTap: onDecrease,
              child: Container(
                //width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.remove,
                  color: iconColor ?? Colors.white,
                  size: iconSize ?? 16.sp,
                ),
              ),
            ),

            // Quantity display
            Text(
              quantity.toString(),
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: fontSize ?? 14.sp,
                fontWeight: FontWeight.w500,
                color: textColor ?? Colors.white,
              ),
            ),

            // Plus button
            GestureDetector(
              onTap: onIncrease,
              child: Container(
                width: 24.w,
                // height: 24.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.add,
                  color: iconColor ?? Colors.white,
                  size: iconSize ?? 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
