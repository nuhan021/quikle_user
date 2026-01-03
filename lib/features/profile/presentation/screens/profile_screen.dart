import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/profile/controllers/profile_controller.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';
import 'package:quikle_user/features/profile/presentation/widgets/profile_card.dart';
import 'package:quikle_user/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:quikle_user/features/profile/presentation/widgets/profile_section_header.dart';
import 'package:quikle_user/features/profile/presentation/widgets/profile_grid_item.dart';
import 'package:quikle_user/routes/app_routes.dart';
import 'package:quikle_user/features/profile/presentation/screens/my_profile_screen.dart';
import 'package:quikle_user/features/main/presentation/screens/main_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final ProfileController controller = Get.put(ProfileController());

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 14.h),

                  // Profile Card
                  Obx(() {
                    final user = controller.userService.currentUser;
                    return ProfileCard(
                      name: user?.name ?? controller.nameController.text,
                      email: user?.phone ?? controller.phoneController.text,
                    );
                  }),
                  SizedBox(height: 16.h),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 0.95,
                    children: [
                      ProfileGridItem(
                        assetIcon: ImagePath.addressIcon,
                        title: 'Address Book',
                        onTap: () => _navigateToAddressBook(context),
                      ),
                      ProfileGridItem(
                        assetIcon: ImagePath.paymentIcon,
                        title: 'Payment Method',
                        onTap: () => _navigateToPaymentMethod(context),
                      ),
                      ProfileGridItem(
                        assetIcon: ImagePath.helpIcon,
                        title: 'Help & Support',
                        onTap: () => _navigateToHelpSupport(context),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Your Information Section
                  const ProfileSectionHeader(title: 'Your Information'),

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
                    assetIcon: ImagePath.prescriptionIcon,
                    title: 'Prescription',
                    onTap: () => _navigateToPrescriptionPage(context),
                  ),
                  SizedBox(height: 16.h),

                  // Other Information section
                  const ProfileSectionHeader(title: 'Other Information'),
                  SizedBox(height: 8.h),

                  ProfileMenuItem(
                    assetIcon: ImagePath.aboutUsIcon,
                    title: 'About Us',
                    onTap: () => _navigateToAboutUs(context),
                  ),
                  SizedBox(height: 8.h),

                  ProfileMenuItem(
                    assetIcon: ImagePath.signOutIcon,
                    title: 'Sign Out',
                    onTap: () => _showSignOutDialog(context),
                  ),
                  SizedBox(height: 8.h),

                  ProfileMenuItem(
                    assetIcon: ImagePath.deleteAccountIcon,
                    title: 'Delete Account',
                    onTap: () => _showDeleteAccountDialog(context),
                  ),

                  // SizedBox(height: 24.h),

                  // Hallmark / brand mark at bottom
                  Center(
                    child: Image.asset(
                      ImagePath.hallmark,
                      width: 150.w,
                      height: 150.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 40.h),
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
      MaterialPageRoute(builder: (context) => MyProfileScreen()),
    );
  }

  void _navigateToOrders(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainScreen(initialIndex: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child,
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

  void _navigateToPrescriptionPage(BuildContext context) {
    Get.toNamed(AppRoute.getPrescription());
  }

  void _navigateToHelpSupport(BuildContext context) {
    Get.toNamed(AppRoute.getHelpSupport());
  }

  void _navigateToAboutUs(BuildContext context) {
    Get.toNamed(AppRoute.getAboutUs());
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
                controller.logout();
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

  void _showDeleteAccountDialog(BuildContext context) {
    // Clear any previous delete error before showing the dialog
    controller.deleteError.value = '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Account',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.error,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This action is permanent.\n\n'
                'All your data, orders, and profile information will be deleted and cannot be recovered.\n\n'
                'Are you sure you want to continue?',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 12.h),
              Obx(() {
                if (controller.deleteError.value.isEmpty)
                  return const SizedBox.shrink();
                return Text(
                  controller.deleteError.value,
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.error,
                  ),
                );
              }),
            ],
          ),
          actions: [
            Obx(
              () => TextButton(
                onPressed: controller.isDeleting.value
                    ? null
                    : () {
                        // Clear any displayed error when user cancels
                        controller.deleteError.value = '';
                        Navigator.of(context).pop();
                      },
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
            ),

            Obx(
              () => TextButton(
                onPressed: controller.isDeleting.value
                    ? null
                    : () {
                        // Keep the dialog open while deletion is in progress.
                        controller.deleteAccount();
                      },
                child: controller.isDeleting.value
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      )
                    : Text(
                        'Delete',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.error,
                        ),
                      ),
              ),
            ),
          ],
          // Show inline error inside the dialog when deletion fails
          contentPadding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 8.h),
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
          // Add a bottom widget to display any delete error
          actionsPadding: EdgeInsets.only(right: 8.w, bottom: 12.h),
        );
      },
    );
  }
}
