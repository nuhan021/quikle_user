import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:video_player/video_player.dart';
import '../../controllers/splash_controller.dart';
import '../widgets/box_skeleton.dart';
import '../../../auth/presentation/screens/login_screen.dart';

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
        backgroundColor: Colors.white,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 81.w,
              top: 295.5.h,
              child: Obx(() {
                if (!controller.isReady.value) {
                  return BoxSkeleton(width: 230.w, height: 221.h, radius: 48.r);
                }
                final vc = controller.video;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(48.r),
                  child: SizedBox(
                    width: 230.w,
                    height: 221.h,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: vc.value.size.width,
                        height: vc.value.size.height,
                        child: VideoPlayer(vc),
                      ),
                    ),
                  ),
                );
              }),
            ),
            Obx(() {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeInOut,
                left: _ellipseLeft.w,
                top: controller.ellipseTop.value.h,
                child: ClipOval(
                  child: SizedBox(
                    width: 708.w,
                    height: 331.h,
                    child: Container(color: Colors.black),
                  ),
                ),
              );
            }),
            Obx(() {
              final double textTop =
                  (controller.ellipseTop.value + _textOffsetFromEllipseTop).h;
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeInOut,
                left: _textLeft.w,
                top: textTop,
                child: SizedBox(
                  width: _textWidth.w,
                  height: _textHeight.h,
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Fresh Food, ',
                            style: TextStyle(
                              fontFamily: 'Obviously',
                              fontWeight: FontWeight.w500,
                              fontSize: 18.sp,
                              height: 1.3,
                              color: AppColors.eggshellWhite,
                            ),
                          ),
                          TextSpan(
                            text: 'Delivered Fast',
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
              );
            }),
            // Animated Login Screen
            Obx(() {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                left: 0,
                right: 0,
                bottom: controller.showLogin.value ? 0 : -1.sh,
                height: 1.sh,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: const LoginScreen(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
