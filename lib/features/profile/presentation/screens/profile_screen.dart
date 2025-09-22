import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/profile/presentation/screens/language_settings_screen.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';
import 'package:quikle_user/features/profile/presentation/widgets/profile_card.dart';
import 'package:quikle_user/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:quikle_user/routes/app_routes.dart';
import 'package:quikle_user/features/profile/presentation/screens/my_profile_screen.dart';
import 'package:quikle_user/features/main/presentation/screens/main_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      body: SafeArea(
        child: ListView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            const UnifiedProfileAppBar(title: 'Profile', showBackButton: false),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 14.h),
                  const ProfileCard(
                    name: 'Aanya Desai',
                    email: 'anyadesai@gmail.com',
                  ),
                  SizedBox(height: 16.h),

                  ProfileMenuItem(
                    assetIcon: ImagePath.myProfileIcon,
                    title: 'My Profile',
                    onTap: () => _navigateToMyProfile(context),
                  ),
                  SizedBox(height: 8.h),

                  ProfileMenuItem(
                    assetIcon: ImagePath.myOrdersIcon,
                    title: 'My Orders',
                    onTap: () => _navigateToOrders(context),
                  ),
                  SizedBox(height: 8.h),

                  ProfileMenuItem(
                    assetIcon: ImagePath.favoriteFilledIcon,
                    title: 'My Favorites',
                    onTap: () => _navigateToFavorites(context),
                  ),
                  SizedBox(height: 8.h),

                  ProfileMenuItem(
                    assetIcon: ImagePath.addressIcon,
                    title: 'Address Book',
                    onTap: () => _navigateToAddressBook(context),
                  ),
                  SizedBox(height: 8.h),

                  ProfileMenuItem(
                    assetIcon: ImagePath.paymentIcon,
                    title: 'Payment Method',
                    onTap: () => _navigateToPaymentMethod(context),
                  ),
                  SizedBox(height: 8.h),

                  ProfileMenuItem(
                    assetIcon: ImagePath.notificationIcon,
                    title: 'Notification Settings',
                    onTap: () => _navigateToNotificationSettings(context),
                  ),
                  SizedBox(height: 8.h),

                  ProfileMenuItem(
                    assetIcon: ImagePath.languageIcon,
                    title: 'Language Settings',
                    onTap: () => _navigateToLanguageSettings(context),
                  ),
                  SizedBox(height: 8.h),

                  ProfileMenuItem(
                    assetIcon: ImagePath.helpIcon,
                    title: 'Help & Support',
                    onTap: () => _navigateToHelpSupport(context),
                  ),
                  SizedBox(height: 8.h),

                  ProfileMenuItem(
                    assetIcon: ImagePath.signOutIcon,
                    title: 'Sign out',
                    onTap: () => _showSignOutDialog(context),
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMyProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyProfileScreen()),
    );
  }

  void _navigateToOrders(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MainScreen(initialIndex: 1),
      ),
      (route) => false,
    );
  }

  void _navigateToFavorites(BuildContext context) {
    Get.toNamed('/favorites');
  }

  void _navigateToAddressBook(BuildContext context) {
    Get.toNamed('/address-book');
  }

  void _navigateToPaymentMethod(BuildContext context) {
    Get.toNamed(AppRoute.getPaymentMethods());
  }

  void _navigateToNotificationSettings(BuildContext context) {
    Get.toNamed(AppRoute.getNotificationSettings());
  }

  void _navigateToLanguageSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const LanguageSettingsSheet(),
    );
  }

  void _navigateToHelpSupport(BuildContext context) {
    Get.toNamed(AppRoute.getHelpSupport());
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sign Out',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.snackbar(
                  'Signed Out',
                  'You have been successfully signed out',
                  backgroundColor: AppColors.success,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
              },
              child: Text(
                'Sign Out',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
