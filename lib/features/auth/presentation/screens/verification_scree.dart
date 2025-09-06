import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
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
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SizedBox(
              width: 392.w,
              height: 852.h,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 392.w,
                      height: 852.h,
                      alignment: Alignment.center,
                      child: Container(
                        width: 708.w,
                        height: 1047.h,
                        decoration: const ShapeDecoration(
                          color: Colors.black,
                          shape: OvalBorder(),
                        ),
                      ),
                    ),
                  ),

                  // ===== Top bar: back icon space – title – invisible right icon =====
                  // ===== Top bar: back button + title =====
                  Positioned(
                    left: 16.w,
                    top: 24.5.h,
                    child: SizedBox(
                      width: 360.w,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Back button
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              width: 24.w,
                              height: 24.w,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                size: 18.sp,
                                color: const Color(0xFFF8F8F8),
                              ),
                            ),
                          ),
                          SizedBox(width: 135.w),
                          // Title
                          Text(
                            'Verification',
                            style: getTextStyle(
                              font: CustomFonts.obviously,
                              color: const Color(0xFFF8F8F8),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ===== Header block (logo + texts) =====
                  Positioned(
                    left: 20.w,
                    top: 202.h,
                    child: SizedBox(
                      width: 352.w,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 63,
                            height: 64,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFFC200),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 8,
                                  top: 8,
                                  child: Container(
                                    width: 47,
                                    height: 48,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(ImagePath.verifyIcon),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Stack(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // Enter Code
                          SizedBox(
                            width: 352.w,
                            child: Text(
                              'Enter Code',
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                font: CustomFonts.obviously,
                                color: AppColors.eggshellWhite,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          SizedBox(height: 8.h),

                          SizedBox(
                            width: 352.w,
                            child: Text(
                              "We've sent a 6-digit code to",
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                color: AppColors.featherGrey,
                              ),
                            ),
                          ),

                          SizedBox(height: 8.h),

                          SizedBox(
                            width: 352.w,
                            child: Text(
                              controller.phone,
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                color: AppColors.beakYellow,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ===== OTP + Verify + Resend block =====
                  Positioned(
                    left: 20.w,
                    top: 495.h,
                    child: SizedBox(
                      width: 352.w,
                      height: 155.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // OTP row (6 boxes) – first 2 yellow per Figma, others grey
                          SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(6, (i) {
                                  return Obx(() {
                                    final isFilled =
                                        controller.otpDigits[i].isNotEmpty;
                                    final color = isFilled
                                        ? const Color(0xFFFFC200)
                                        : const Color(0xFF7C7C7C);
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        right: i == 5 ? 0 : 12.w,
                                      ),
                                      child: Container(
                                        width: 48.67.w,
                                        height: 52.h,
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 1,
                                              color: color,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: _OtpCell(index: i, color: color),
                                      ),
                                    );
                                  });
                                }),
                              ),
                            ),
                          ),

                          SizedBox(height: 16.h),
                          GestureDetector(
                            onTap: controller.onTapVerify,
                            child: Container(
                              width: double.infinity,
                              height: 48.h,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 14.h,
                              ),
                              decoration: ShapeDecoration(
                                color: AppColors.beakYellow,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 304.w,
                                    child: Obx(() {
                                      return Text(
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
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // Resend text (Container -> RichText)
                          SizedBox(
                            width: 352.w,
                            child: Obx(() {
                              final canResend = controller.canResend;
                              final seconds = controller.secondsLeft.value;
                              return GestureDetector(
                                onTap: canResend
                                    ? controller.onTapResend
                                    : null,
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
                                          height: 1.50,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
    final c = Get.find<VerificationController>();
    return TextField(
      controller: c.digits[index],
      focusNode: c.focuses[index],
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      maxLength: 1,
      style: TextStyle(
        color: AppColors.eggshellWhite,
        fontSize: 18.sp,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      cursorColor: const Color(0xFFF8F8F8),
      decoration: const InputDecoration(
        counterText: '',
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        isCollapsed: true,
        contentPadding: EdgeInsets.zero,
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (v) => c.onDigitChanged(index, v),
    );
  }
}
