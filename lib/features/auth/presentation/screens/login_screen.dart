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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 64.h),
                  CommonWidgets.appLogo(),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: 209.w,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Welcome ',
                            style: getTextStyle(
                              font: CustomFonts.obviously,
                              color: AppColors.beakYellow,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w500,
                              lineHeight: 1.20,
                            ),
                          ),
                          TextSpan(
                            text: 'Back!',
                            style: getTextStyle(
                              font: CustomFonts.obviously,
                              color: AppColors.eggshellWhite,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 56.h),
                ],
              ),
            ),

            IconRowMarquee(
              images: ProductIcons.asProviders(),
              speed: 60,
              offsetSlots: 0.0,
            ),
            SizedBox(height: 12.h),
            IconRowMarquee(
              images: ProductIcons.asProviders(),
              speed: 60,
              offsetSlots: 0.5,
              reverse: true,
            ),
            SizedBox(height: 76.h),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
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
                      hintText: 'Enter Your Phone Number',
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 24.h),
                    CommonWidgets.primaryButton(
                      text: 'Log In',
                      onTap: controller.onTapLogin,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 352.w,
                      child: Text(
                        "Don't have an account?",
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          color: AppColors.eggshellWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    CommonWidgets.secondaryButton(
                      text: 'Create An Account',
                      onTap: controller.onTapCreateAccount,
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
