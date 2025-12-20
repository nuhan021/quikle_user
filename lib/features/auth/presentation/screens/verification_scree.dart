import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/auth/controllers/verification_controller.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VerificationController>();
    controller.startTimer();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.ebonyBlack,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 24.5.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          try {
                            final controller =
                                Get.find<VerificationController>();
                            controller.clearOtp();
                          } catch (_) {}
                          Get.back();
                        },
                        child: SizedBox(
                          width: 40.w,
                          height: 40.w,
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 18.sp,
                            color: const Color(0xFFF8F8F8),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Verification',
                          textAlign: TextAlign.center,
                          style: getTextStyle(
                            font: CustomFonts.obviously,
                            color: const Color(0xFFF8F8F8),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 40.w),
                    ],
                  ),
                ),
                SizedBox(height: 100.h),
                Container(
                  width: 63.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC200),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Image.asset(ImagePath.verifyIcon, fit: BoxFit.contain),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Enter Code',
                  style: getTextStyle(
                    font: CustomFonts.obviously,
                    color: AppColors.eggshellWhite,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "We've sent a 6-digit code to",
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    color: AppColors.featherGrey,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  controller.phone,
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    color: AppColors.beakYellow,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 100.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: controller.otpController,
                        errorAnimationController: controller.errorController,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.slide,
                        autoDisposeControllers: false,
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: true,

                        textStyle: TextStyle(
                          color: AppColors.eggshellWhite,
                          fontSize: 18.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                        cursorColor: const Color(0xFFF8F8F8),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(8.r),
                          fieldHeight: 52.h,
                          fieldWidth: 48.67.w,
                          activeFillColor: AppColors.ebonyBlack,
                          inactiveFillColor: AppColors.ebonyBlack,
                          selectedFillColor: AppColors.ebonyBlack,
                          activeColor: const Color(0xFFFFC200),
                          inactiveColor: const Color(0xFF7C7C7C),
                          selectedColor: const Color(0xFFFFC200),
                          errorBorderColor: AppColors.error,
                        ),
                        onChanged: (value) {
                          controller.onOtpChanged(value);
                        },
                        onCompleted: (value) {
                          controller.onTapVerify();
                        },
                      ),
                      SizedBox(height: 8.h),
                      Obx(() {
                        if (controller.errorMessage.value.isEmpty)
                          return SizedBox.shrink();
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Text(
                            controller.errorMessage.value,
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              color: AppColors.error,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                      SizedBox(height: 16.h),
                      GestureDetector(
                        onTap: controller.onTapVerify,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.beakYellow,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Obx(
                            () => Text(
                              controller.isVerifying.value
                                  ? 'Verifying…'
                                  : 'Verify Code',
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                font: CustomFonts.manrope,
                                color: AppColors.ebonyBlack,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Obx(() {
                        final canResend = controller.canResend;
                        final seconds = controller.secondsLeft.value;
                        final isResending = controller.isResending.value;

                        return GestureDetector(
                          onTap: canResend && !isResending
                              ? controller.onTapResend
                              : null,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: isResending
                                      ? 'Resending...'
                                      : 'Resend code in ',
                                  style: getTextStyle(
                                    font: CustomFonts.inter,
                                    color: AppColors.featherGrey,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if (!isResending)
                                  TextSpan(
                                    text: canResend
                                        ? 'now'
                                        : '${seconds.toString().padLeft(2, '0')}s',
                                    style: TextStyle(
                                      color: const Color(0xFFFFC200),
                                      fontSize: 14.sp,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
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
