import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';
import 'package:quikle_user/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/routes/app_routes.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      body: SafeArea(
        child: Column(
          children: [
            const UnifiedProfileAppBar(title: 'About Us', showBackButton: true),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quikle — Ranchi’s multi-category delivery app',
                        style: getTextStyle(
                          font: CustomFonts.obviously,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      Text(
                        'Quikle is Ranchi\'s first multi-category delivery platform bringing food, groceries, and medicines to your doorstep in minutes. Our app is changing the way customers approach their daily essentials with our unique 30-minute medicine delivery promise.',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      Text(
                        'You can now order food from your favourite restaurants, fresh groceries sourced daily, and essential medicines from licensed pharmacies—all in one app, one order, one delivery.',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      Text(
                        'Imagine getting everything you need in minutes. Your favourite meal. Fresh groceries for dinner. Medicine when you need it most. All through one app.',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      Text(
                        'Our superfast delivery service aims to help people in Ranchi save time and fulfil their needs in a way that is frictionless. We make quality products and services available to everyone instantly so that people can have time for the things that matter to them.',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      Text(
                        'Quikle connects customers with licensed pharmacies. Medicines are dispensed by partner pharmacies as per applicable laws. We operate in compliance with all Indian regulations including the Drugs and Cosmetics Act, 1940.',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      Text(
                        '\'Quikle\' is owned & managed by \'Quikle\' (a partnership firm) and is not related, linked or interconnected in whatsoever manner or nature to any other business entity.',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      Divider(color: AppColors.primary.withOpacity(0.12)),
                      SizedBox(height: 12.h),

                      // Bottom links as ProfileMenuItem rows
                      ProfileMenuItem(
                        assetIcon: ImagePath.termsIcon,
                        title: 'Terms & Conditions',
                        onTap: () => Get.toNamed(AppRoute.getTermsConditions()),
                      ),
                      SizedBox(height: 8.h),
                      ProfileMenuItem(
                        assetIcon: ImagePath.privacyIcon,
                        title: 'Privacy Policy',
                        onTap: () => Get.toNamed(AppRoute.getPrivacyPolicy()),
                      ),
                      SizedBox(height: 8.h),
                      ProfileMenuItem(
                        assetIcon: ImagePath.termsIcon,
                        title: 'License',
                        onTap: () => Get.toNamed(AppRoute.getLicense()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
