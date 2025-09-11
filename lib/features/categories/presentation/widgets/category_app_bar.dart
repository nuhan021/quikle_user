import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';

class CategoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onBackTap;
  final bool showBackButton;

  const CategoryAppBar({
    super.key,
    required this.title,
    this.onNotificationTap,
    this.onProfileTap,
    this.onBackTap,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        border: Border(
          bottom: BorderSide(color: AppColors.gradientColor, width: 2),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: showBackButton ? 8.w : 16.w,
          ),
          child: Row(
            children: [
              if (showBackButton)
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 24.sp,
                  ),
                  onPressed: onBackTap ?? () => Navigator.pop(context),
                ),
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
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Iconsax.notification,
                      color: Colors.black,
                      size: 24.sp,
                    ),
                    onPressed: onNotificationTap,
                  ),
                  IconButton(
                    icon: Icon(
                      Iconsax.profile_circle,
                      color: Colors.black,
                      size: 24.sp,
                    ),
                    onPressed: onProfileTap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
