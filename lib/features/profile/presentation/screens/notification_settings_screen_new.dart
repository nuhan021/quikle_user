import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      body: SafeArea(
        child: Column(
          children: [
            
            const UnifiedProfileAppBar(
              title: 'Notification Settings',
              showActionButton: false,
            ),

            
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Iconsax.notification,
                          size: 48.sp,
                          color: AppColors.beakYellow,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      Text(
                        'Notification Settings',
                        style: getTextStyle(
                          font: CustomFonts.obviously,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.ebonyBlack,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        'Customize your notification preferences\nto stay updated on your orders',
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.featherGrey,
                        ),
                      ),

                      SizedBox(height: 32.h),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x0A616161),
                              blurRadius: 8.r,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                        ),
                        child: Text(
                          'Coming Soon...\n\nNotification preferences will be available soon. You\'ll be able to customize alerts for orders, offers, and app updates.',
                          textAlign: TextAlign.center,
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
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
