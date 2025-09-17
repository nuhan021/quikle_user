import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
                        onTap: Get.back,
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            6,
                            (index) => Obx(() {
                              final isFilled =
                                  controller.otpDigits[index].isNotEmpty;
                              final color = isFilled
                                  ? const Color(0xFFFFC200)
                                  : const Color(0xFF7C7C7C);
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: index == 5 ? 0 : 12.w,
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 48.67.w,
                                  height: 52.h,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: color),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: _OtpCell(index: index, color: color),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
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
                        return GestureDetector(
                          onTap: canResend ? controller.onTapResend : null,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Resend code in ',
                                  style: getTextStyle(
                                    font: CustomFonts.inter,
                                    color: AppColors.featherGrey,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
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

class _OtpCell extends StatelessWidget {
  const _OtpCell({required this.index, required this.color});

  final int index;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VerificationController>();
    return TextField(
      controller: controller.digits[index],
      focusNode: controller.focuses[index],
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      maxLength: 1,
      style: TextStyle(
        color: AppColors.eggshellWhite,
        fontSize: 18.sp,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
      ),
      cursorColor: const Color(0xFFF8F8F8),
      decoration: const InputDecoration(
        counterText: '',
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        isCollapsed: true,
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value) => controller.onDigitChanged(index, value),
    );
  }
}
