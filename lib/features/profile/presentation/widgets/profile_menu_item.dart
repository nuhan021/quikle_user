import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';

class ProfileMenuItem extends StatelessWidget {
  final String assetIcon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.assetIcon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
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
        child: Row(
          children: [
            Image.asset(assetIcon, width: 24.sp, height: 24.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
            // Icon(
            //   Icons.arrow_forward_ios,
            //   size: 16.sp,
            //   color: AppColors.textSecondary,
            // ),
          ],
        ),
      ),
    );
  }
}
