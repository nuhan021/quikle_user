import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bottomInset = media.padding.bottom;

    return Container(
      padding: EdgeInsets.only(
        top: 8.h,
        left: 8.w,
        right: 8.w,
        bottom: bottomInset > 0 ? bottomInset : 8.h,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
        border: Border(
          top: BorderSide(width: 2.w, color: AppColors.gradientColor),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _NavItem(
            iconAsset: ImagePath.homeNav,
            label: 'Home',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            iconAsset: ImagePath.orderIcon,
            label: 'All Orders',
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavItem(
            iconAsset: ImagePath.categoryIcon,
            label: 'Categories',
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavItem(
            iconAsset: ImagePath.profile,
            label: 'Profile',
            isSelected: currentIndex == 3,
            onTap: () => onTap(3),
            isProfile: true,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData? icon;
  final String? iconAsset;
  final IconData? fallbackIcon;
  final String label;
  final bool isSelected;
  final Function() onTap;
  final bool isProfile;

  const _NavItem({
    this.icon,
    this.iconAsset,
    this.fallbackIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isProfile = false,
  }) : assert(
         icon != null || iconAsset != null || fallbackIcon != null,
         'Either icon, iconAsset, or fallbackIcon must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final iconSize = 22.w;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconAsset != null)
                isProfile
                    ? ClipOval(
                        child: Container(
                          width: iconSize,
                          height: iconSize,
                          child: Image.asset(iconAsset!, fit: BoxFit.cover),
                        ),
                      )
                    : Image.asset(
                        iconAsset!,
                        width: iconSize,
                        height: iconSize,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          fallbackIcon ?? Iconsax.user,
                          size: iconSize,
                          color: isSelected
                              ? AppColors.beakYellow
                              : AppColors.eggshellWhite,
                        ),
                      )
              else
                Icon(
                  icon!,
                  size: iconSize,
                  color: isSelected
                      ? AppColors.beakYellow
                      : AppColors.eggshellWhite,
                ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: getTextStyle(
                  font: CustomFonts.inter,
                  color: isSelected
                      ? AppColors.beakYellow
                      : AppColors.eggshellWhite,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
