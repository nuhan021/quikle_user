import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';

class CommonWidgets {
  static Widget appLogo() {
    return Container(
      width: 64.w,
      height: 64.w,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePath.logo),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  static Widget customTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      width: double.infinity,
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF7C7C7C)),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: getTextStyle(
          font: CustomFonts.inter,
          color: AppColors.eggshellWhite,
        ),
        cursorColor: const Color(0xFFF8F8F8),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: getTextStyle(
            font: CustomFonts.inter,
            color: AppColors.featherGrey,
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  static Widget primaryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        decoration: ShapeDecoration(
          color: const Color(0xFFFFC200),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  font: CustomFonts.manrope,
                  color: AppColors.ebonyBlack,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget secondaryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.w, color: const Color(0xFFF8F8F8)),
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: getTextStyle(
                font: CustomFonts.inter,
                color: const Color(0xFFFFC200),
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
