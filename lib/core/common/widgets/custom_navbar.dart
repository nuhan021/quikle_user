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
    return Container(
      height: 86.h,
      padding: EdgeInsets.only(top: 14.h, left: 12.w, right: 12.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.80),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        border: Border(
          top: BorderSide(width: 1.w, color: AppColors.gradientColor),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A000000),
            blurRadius: 20.r,
            offset: Offset(0, -2.h),
            spreadRadius: 0.r,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Home button
                _NavItem(
                  icon: Iconsax.home_2,
                  label: 'Home',
                  isSelected: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                // All Orders button
                _NavItem(
                  icon: Iconsax.bag_2,
                  label: 'All Orders',
                  isSelected: currentIndex == 1,
                  onTap: () => onTap(1),
                ),
                // Categories button
                _NavItem(
                  iconAsset: ImagePath.categoryIcon,
                  label: 'Categories',
                  isSelected: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
                _NavItem(
                  icon: Iconsax.user,
                  label: 'Ananya',
                  isSelected: currentIndex == 3,
                  onTap: () => onTap(3),
                ),
              ],
            ),
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
  final double iconSize;
  final bool showText;

  const _NavItem({
    this.icon,
    this.iconAsset,
    this.fallbackIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.iconSize = 24.0,
    this.showText = true,
  }) : assert(
         icon != null || iconAsset != null || fallbackIcon != null,
         'Either icon, iconAsset, or fallbackIcon must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              iconAsset != null
                  ? Image.asset(
                      iconAsset!,
                      width: iconSize,
                      height: iconSize,
                      color: isSelected
                          ? AppColors.beakYellow
                          : AppColors.eggshellWhite,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        fallbackIcon ?? Iconsax.user,
                        size: iconSize,
                        color: isSelected
                            ? AppColors.beakYellow
                            : AppColors.eggshellWhite,
                      ),
                    )
                  : Icon(
                      icon!,
                      size: iconSize,
                      color: isSelected
                          ? AppColors.beakYellow
                          : AppColors.eggshellWhite,
                    ),
              if (showText) SizedBox(height: 8.h),
              // Label
              if (showText)
                Text(
                  label,
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    color: isSelected
                        ? AppColors.beakYellow
                        : AppColors.eggshellWhite,
                    fontSize: 14.sp,
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
