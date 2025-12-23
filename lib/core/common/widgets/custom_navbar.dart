import 'dart:ui';
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
    // viewPadding.bottom gives the gesture area height (0 for 3-button navigation)
    final bottomInset = media.viewPadding.bottom;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: EdgeInsets.only(
            top: 8.h,
            left: 8.w,
            right: 8.w,
            bottom: bottomInset > 0 ? bottomInset : 0,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
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
                inactiveIcon: ImagePath.homeNav,
                activeIcon: ImagePath.homeActiveNav,
                label: 'Home',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                inactiveIcon: ImagePath.orderIcon,
                activeIcon: ImagePath.orderActiveIcon,
                label: 'All Orders',
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                inactiveIcon: ImagePath.categoryIcon,
                activeIcon: ImagePath.categoryActiveIcon,
                label: 'Categories',
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                inactiveIcon: ImagePath.profile,
                activeIcon: ImagePath.profile,
                label: 'Profile',
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
                isProfile: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String inactiveIcon;
  final String activeIcon;
  final String label;
  final bool isSelected;
  final Function() onTap;
  final bool isProfile;

  const _NavItem({
    required this.inactiveIcon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = 22.w;
    final iconToShow = isSelected ? activeIcon : inactiveIcon;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isProfile)
                ClipOval(
                  child: Container(
                    width: iconSize,
                    height: iconSize,
                    child: Image.asset(iconToShow, fit: BoxFit.cover),
                  ),
                )
              else
                Image.asset(
                  iconToShow,
                  width: iconSize,
                  height: iconSize,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Iconsax.user,
                    size: iconSize,
                    color: isSelected
                        ? AppColors.beakYellow
                        : AppColors.eggshellWhite,
                  ),
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
