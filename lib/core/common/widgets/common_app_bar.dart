import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  // ─────────────────── New field ───────────────────
  final String? subtitle;

  final String title;
  final Widget? titleWidget;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onBackTap;
  final bool showBackButton;
  final List<Widget>? actions;
  final bool showNotification;
  final bool showProfile;
  final Color backgroundColor;
  final Widget? addressWidget;
  final bool isFromHome;

  const CommonAppBar({
    super.key,
    required this.title,
    this.subtitle, // ← added
    this.titleWidget,
    this.onNotificationTap,
    this.onProfileTap,
    this.onBackTap,
    this.showBackButton = true,
    this.actions,
    this.showNotification = true,
    this.showProfile = true,
    this.backgroundColor = Colors.white,
    this.addressWidget,
    this.isFromHome = false,
  });

  bool get _useCustomActions => actions != null && actions!.isNotEmpty;

  Color get _iconColor =>
      backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  SystemUiOverlayStyle get _overlay => SystemUiOverlayStyle(
    statusBarColor: backgroundColor,
    statusBarIconBrightness: backgroundColor.computeLuminance() > 0.5
        ? Brightness.dark
        : Brightness.light,
    statusBarBrightness: backgroundColor.computeLuminance() > 0.5
        ? Brightness.light
        : Brightness.dark,
  );

  Widget _buildTrailing() {
    if (_useCustomActions) {
      return Row(mainAxisSize: MainAxisSize.min, children: actions!);
    }

    final items = <Widget>[];
    if (showNotification) {
      items.add(
        IconButton(
          icon: Icon(Iconsax.notification, color: _iconColor, size: 24.sp),
          onPressed: onNotificationTap,
        ),
      );
    }
    if (showProfile) {
      items.add(
        IconButton(
          icon: Icon(Iconsax.profile_circle, color: _iconColor, size: 24.sp),
          onPressed: onProfileTap,
        ),
      );
    }

    if (addressWidget != null && !isFromHome) {
      items.add(addressWidget!);
    }

    if (items.isEmpty) {
      return const SizedBox(width: kMinInteractiveDimension);
    }
    return Row(mainAxisSize: MainAxisSize.min, children: items);
  }

  // ─────────────────── Helper to build title / subtitle ───────────────────
  Widget _buildTitleArea(Color txtColor) {
    if (titleWidget != null) return titleWidget!;

    if (subtitle != null && subtitle!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: txtColor,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: txtColor.withValues(alpha: .70),
            ),
          ),
        ],
      );
    }

    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: getTextStyle(
        font: CustomFonts.obviously,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: txtColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlay,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          border: Border(
            bottom: BorderSide(color: AppColors.gradientColor, width: 2),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              children: [
                if (showBackButton)
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: _iconColor,
                      size: 22.sp,
                    ),
                    onPressed: onBackTap ?? () => Navigator.pop(context),
                  )
                else
                  SizedBox(width: 12.w),

                // Title area
                Expanded(child: _buildTitleArea(_iconColor)),

                // Actions / trailing icons
                _buildTrailing(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
