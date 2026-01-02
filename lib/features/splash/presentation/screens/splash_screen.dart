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

  // TWEAK: change these to adjust the text box size over the ellipse
  static const double _textWidthFraction = 0.8; // wider box so 'Quickly' fits
  static const double _textHeightFraction = 0.04;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.ellipseTop.value == 0) {
        final double bottomInset = MediaQuery.of(context).padding.bottom;
        final double ellipseHeight = Get.height * 0.30;
        final double marginFromNav = 16.0;
        final double visiblePortion = 0.32;
        final double visibleHeight = ellipseHeight * visiblePortion;
        final double desiredTop =
            Get.height - bottomInset - visibleHeight - marginFromNav;
        controller.setEllipseTop(desiredTop);
      }
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(color: Colors.white),

            Obx(() {
              final isReady = controller.isReady.value;
              final shouldShrink = controller.shouldShrink.value;
              final vc = controller.video;

              if (!isReady) return const SizedBox.shrink();

              return AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOutCubic,
                left: shouldShrink ? Get.width * 0.21 : 0,
                top: shouldShrink ? Get.height * 0.35 : 0,
                width: shouldShrink ? Get.width * 0.64 : Get.width,
                height: shouldShrink ? Get.height * 0.32 : Get.height,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutCubic,
                  decoration: BoxDecoration(
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

            Obx(() {
              final showEllipse = controller.showEllipse.value;
              // TWEAK: adjust ellipseWidth and ellipseHeight to change how
              // flat or tall the arc looks
              final double ellipseWidth = Get.width * 1.4; // width multiplier
              final double ellipseHeight =
                  Get.height * 0.30; // height multiplier
              final double left = (Get.width - ellipseWidth) / 2;

              return AnimatedPositioned(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeInOut,
                left: left,
                top: controller.ellipseTop.value,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  opacity: showEllipse ? 1 : 0,
                  child: ClipOval(
                    child: SizedBox(
                      width: ellipseWidth,
                      height: ellipseHeight,
                      child: Container(color: Colors.black),
                    ),
                  ),
                ),
              );
            }),

            Obx(() {
              final showEllipse = controller.showEllipse.value;
              final double ellipseWidth = Get.width * 1.4;
              final double ellipseHeight = Get.height * 0.30;
              final double ellipseLeft = (Get.width - ellipseWidth) / 2;

              final double textWidth = Get.width * _textWidthFraction;
              final double textHeight = Get.height * _textHeightFraction;
              final double textLeft =
                  ellipseLeft + (ellipseWidth - textWidth) / 2;
              final double textTop =
                  controller.ellipseTop.value + (ellipseHeight * 0.22);

              return AnimatedPositioned(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeInOut,
                left: textLeft,
                top: textTop,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  opacity: showEllipse ? 1 : 0,
                  child: SizedBox(
                    width: textWidth,
                    height: textHeight,
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

            Obx(() {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                left: 0,
                right: 0,
                bottom: controller.showLogin.value ? 0 : -Get.height,
                height: Get.height,
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
