import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/auth/controllers/login_controller.dart';

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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 64.h),
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImagePath.logo),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
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
                            lineHeight: 1.20,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 64.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Phone Number',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      color: AppColors.eggshellWhite,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      lineHeight: 1.50,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                Container(
                  width: double.infinity,
                  height: 52,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFF7C7C7C),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: TextField(
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      color: AppColors.eggshellWhite,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      lineHeight: 1.50,
                    ),
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      hintText: 'Enter Your Phone Number',
                      hintStyle: getTextStyle(
                        font: CustomFonts.inter,
                        color: const Color(0xFF9B9B9B),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        lineHeight: 1.50,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),

                SizedBox(height: 24.h),
                GestureDetector(
                  onTap: controller.onTapLogin,
                  child: Container(
                    width: double.infinity,
                    height: 48.h,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFFC200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 10,
                      children: [
                        SizedBox(
                          width: 304,
                          child: Text(
                            'Log In',
                            textAlign: TextAlign.center,
                            style: getTextStyle(
                              font: CustomFonts.manrope,
                              color: AppColors.ebonyBlack,
                              fontSize: 18,
                              //fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),
                SizedBox(
                  width: 352.w,
                  child: Text(
                    "Don't have an account?",
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      color: const Color(0xFFF8F8F8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: controller.onTapCreateAccount,
                  child: Container(
                    width: double.infinity,
                    height: 50.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 14.h,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1.w,
                          color: const Color(0xFFF8F8F8),
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10.w,
                      children: [
                        SizedBox(
                          child: Text(
                            'Create An Account',
                            textAlign: TextAlign.center,
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              color: const Color(0xFFFFC200),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
