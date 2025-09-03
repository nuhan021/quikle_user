import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import 'package:quikle_user/features/auth/controllers/register_controller.dart';
import 'package:quikle_user/features/auth/presentation/widgets/common_widgets.dart';
import 'package:quikle_user/routes/app_routes.dart'; // Import reusable widgets

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 48.h),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CommonWidgets.appLogo(),
                            SizedBox(height: 16.h),
                            SizedBox(
                              width: 230.w,
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Join',
                                      style: getTextStyle(
                                        font: CustomFonts.obviously,
                                        color: AppColors.eggshellWhite,
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' Quikle',
                                      style: getTextStyle(
                                        font: CustomFonts.obviously,
                                        color: AppColors.beakYellow,
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Create your account to get started',
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                color: const Color(0xFF9B9B9B),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 148.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Full Name',
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                color: AppColors.eggshellWhite,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            CommonWidgets.customTextField(
                              controller: controller.nameController,
                              hintText: 'John Doe',
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'Phone Number',
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                color: AppColors.eggshellWhite,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            CommonWidgets.customTextField(
                              controller: controller.phoneController,
                              hintText: '(555) 123-4567',
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9+\s-]'),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            CommonWidgets.primaryButton(
                              text: 'Create Account',
                              onTap: () {
                                final phone = controller.phoneController.text
                                    .trim();
                                Get.toNamed(
                                  AppRoute.getVerify(),
                                  arguments: {'phone': phone},
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 360.w,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'By creating an account, you agree to our ',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            color: AppColors.featherGrey,
                          ),
                        ),
                        const TextSpan(
                          text: 'Terms of Services',
                          style: TextStyle(color: AppColors.beakYellow),
                        ),
                        TextSpan(
                          text: ' and ',
                          style: TextStyle(color: AppColors.featherGrey),
                        ),
                        const TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(color: AppColors.beakYellow),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
