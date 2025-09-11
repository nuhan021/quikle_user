import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';

class UnifiedProfileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final bool showActionButton;
  final bool showBackButton;

  const UnifiedProfileAppBar({
    super.key,
    required this.title,
    this.actionText,
    this.onActionPressed,
    this.showActionButton = false,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
        border: Border(
          bottom: BorderSide(color: AppColors.gradientColor, width: 1.w),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A616161),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.center, // keep everything aligned
            children: [
              if (showBackButton)
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Padding(
                    padding: EdgeInsets.all(4.w), // reduce padding
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.ebonyBlack,
                      size: 20.sp,
                    ),
                  ),
                ),
              if (showBackButton) SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: getTextStyle(
                    font: CustomFonts.obviously,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ebonyBlack,
                  ),
                ),
              ),
              if (showActionButton && actionText != null)
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, // remove default padding
                    minimumSize: Size(0, 0), // shrink wrap
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerRight, // align nicely
                  ),
                  onPressed: onActionPressed,
                  child: Text(
                    actionText!,
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.beakYellow,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
