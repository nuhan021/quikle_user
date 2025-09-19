import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/auth/controllers/login_controller.dart';
import 'package:quikle_user/features/auth/presentation/screens/icon_carousel.dart';
import 'package:quikle_user/features/auth/presentation/screens/product_icons.dart';
import 'package:quikle_user/features/auth/presentation/widgets/common_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    // Make separate, random orders
    final iconsRow1 = List<ImageProvider>.from(ProductIcons.asProviders())
      ..shuffle();
    final iconsRow2 = List<ImageProvider>.from(ProductIcons.asProviders())
      ..shuffle();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 64.h),
                      CommonWidgets.appLogo(),
                      SizedBox(height: 16.h),
                      Obx(() {
                        return SizedBox(
                          width: 280.w,
                          child: Text(
                            controller.isExistingUser.value
                                ? 'We deliver quickly'
                                : 'Join Quikle',
                            style: getTextStyle(
                              font: CustomFonts.obviously,
                              color: AppColors.eggshellWhite,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                      SizedBox(height: 8.h),
                      Obx(() {
                        return SizedBox(
                          width: 280.w,
                          child: Text(
                            controller.isExistingUser.value
                                ? 'Log in or sign up'
                                : 'Create your account to get started',
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              color: const Color(0xFF9B9B9B),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                      SizedBox(height: 56.h),
                    ],
                  ),
                ),
                IconRowMarquee(images: iconsRow1, speed: 10, offsetSlots: 0.0),
                SizedBox(height: 12.h),
                IconRowMarquee(images: iconsRow2, speed: 10, offsetSlots: 0.5),
                SizedBox(height: 76.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      // Phone Number Field
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Phone Number',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            color: AppColors.eggshellWhite,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      CommonWidgets.customTextField(
                        controller: controller.phoneController,
                        hintText: 'Enter mobile number',
                        keyboardType: TextInputType.phone,
                      ),

                      // Name Field (shown for new users)
                      Obx(() {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: controller.showNameField.value ? null : 0,
                          child: controller.showNameField.value
                              ? Column(
                                  children: [
                                    SizedBox(height: 16.h),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Full Name',
                                        style: getTextStyle(
                                          font: CustomFonts.inter,
                                          color: AppColors.eggshellWhite,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    CommonWidgets.customTextField(
                                      controller: controller.nameController,
                                      hintText: 'Enter your full name',
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        );
                      }),

                      SizedBox(height: 24.h),
                      Obx(() {
                        return CommonWidgets.primaryButton(
                          text: controller.isLoading.value
                              ? 'Please wait...'
                              : 'Continue',
                          onTap: controller.isLoading.value
                              ? () {}
                              : () => controller.onTapContinue(),
                        );
                      }),
                      SizedBox(height: 24.h),

                      // Terms and Conditions
                      SizedBox(
                        width: 360.w,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'By continuing, you agree to our ',
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  color: AppColors.featherGrey,
                                  fontSize: 12.sp,
                                ),
                              ),
                              TextSpan(
                                text: 'Terms of Service',
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  color: AppColors.beakYellow,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: ' and ',
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  color: AppColors.featherGrey,
                                  fontSize: 12.sp,
                                ),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  color: AppColors.beakYellow,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
