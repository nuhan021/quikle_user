import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/features/auth/presentation/screens/verification_scree.dart';
import 'package:video_player/video_player.dart';
import '../../controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  static const double _ellipseLeft = -158.0;
  static const double _textLeft = 59.0;
  static const double _textWidth = 274.0;
  static const double _textHeight = 23.0;
  static const double _textOffsetFromEllipseTop = 63.0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            /// Base white background
            Container(color: Colors.white),

            /// Video with white background, starts full screen then shrinks smoothly after 2 seconds
            Obx(() {
              final isReady = controller.isReady.value;
              final shouldShrink = controller.shouldShrink.value;
              final vc = controller.video;

              if (!isReady) {
                // Return empty container while video is loading
                return const SizedBox.shrink();
              }

              return AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOutCubic,
                left: shouldShrink ? 81.w : 0,
                top: shouldShrink ? 295.5.h : 0,
                width: shouldShrink ? 250.w : 1.sw,
                height: shouldShrink ? 240.h : 1.sh,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutCubic,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      shouldShrink ? 48.r : 0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      shouldShrink ? 48.r : 0,
                    ),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: vc.value.size.width,
                        height: vc.value.size.height,
                        child: VideoPlayer(vc),
                      ),
                    ),
                  ),
                ),
              );
            }),

            /// Black ellipse animation
            Obx(() {
              final bottomInset = MediaQuery.of(
                context,
              ).padding.bottom; // safe bottom padding
              final showEllipse = controller.showEllipse.value;

              return AnimatedPositioned(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeInOut,
                left: _ellipseLeft.w,
                // add the safe area offset here
                top: controller.ellipseTop.value.h - bottomInset,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  opacity: showEllipse ? 1 : 0,
                  child: ClipOval(
                    child: SizedBox(
                      width: 708.w,
                      height: 331.h,
                      child: Container(color: Colors.black),
                    ),
                  ),
                ),
              );
            }),

            /// Text on ellipse
            Obx(() {
              final double textTop =
                  (controller.ellipseTop.value + _textOffsetFromEllipseTop).h;
              final showEllipse = controller.showEllipse.value;
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeInOut,
                left: _textLeft.w,
                top: textTop,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  opacity: showEllipse ? 1 : 0,
                  child: SizedBox(
                    width: _textWidth.w,
                    height: _textHeight.h,
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Things delivered ',
                              style: TextStyle(
                                fontFamily: 'Obviously',
                                fontWeight: FontWeight.w500,
                                fontSize: 18.sp,
                                height: 1.3,
                                color: AppColors.eggshellWhite,
                              ),
                            ),
                            TextSpan(
                              text: 'Quickly',
                              style: TextStyle(
                                fontFamily: 'Obviously',
                                fontWeight: FontWeight.w500,
                                fontSize: 18.sp,
                                height: 1.3,
                                color: AppColors.beakYellow,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),

            /// Login slide-up
            Obx(() {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                left: 0,
                right: 0,
                bottom: controller.showLogin.value ? 0 : -1.sh,
                height: 1.sh,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: controller.showLogin.value
                        ? BorderRadius.zero
                        : const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                  ),
                  child: const VerificationScreen(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
