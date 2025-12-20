import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';

class ProfileGridItem extends StatelessWidget {
  final String assetIcon;
  final String title;
  final VoidCallback onTap;
  final Color? backgroundColor;

  const ProfileGridItem({
    super.key,
    required this.assetIcon,
    required this.title,
    required this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0x0A606060),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
              spreadRadius: 0,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(assetIcon, width: 32.sp, height: 32.sp),
            SizedBox(height: 8.h),
            Text(
              title,
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
