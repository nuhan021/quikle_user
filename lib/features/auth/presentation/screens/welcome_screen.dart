// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:quikle_user/core/common/styles/global_text_style.dart';
// import 'package:quikle_user/core/utils/constants/colors.dart';
// import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
// import 'package:quikle_user/core/utils/constants/image_path.dart';
// import 'package:quikle_user/features/auth/controllers/welcome_controller.dart';

// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.find<WelcomeController>();
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//       ),
//       child: Scaffold(
//         backgroundColor: AppColors.ebonyBlack,
//         body: Center(
//           child: SizedBox(
//             width: 392.w,
//             height: 852.h,
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: Center(
//                     child: Container(
//                       width: 708.w,
//                       height: 1047.h,
//                       decoration: const ShapeDecoration(
//                         color: Colors.black,
//                         shape: OvalBorder(),
//                       ),
//                     ),
//                   ),
//                 ),

//                 Positioned(
//                   left: 69.w,
//                   top: 315.h,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: 64.w,
//                         height: 64.w,
//                         decoration: const BoxDecoration(
//                           image: DecorationImage(
//                             image: AssetImage(ImagePath.logo),
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20.h),
//                       Text.rich(
//                         TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Welcome To ',
//                               style: getTextStyle(
//                                 font: CustomFonts.obviously,
//                                 color: AppColors.eggshellWhite,
//                                 fontSize: 24.sp,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             TextSpan(
//                               text: 'Quikle',
//                               style: getTextStyle(
//                                 font: CustomFonts.obviously,
//                                 color: AppColors.beakYellow,
//                                 fontSize: 24.sp,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:quikle_user/core/common/styles/global_text_style.dart';
// import 'package:quikle_user/core/utils/constants/colors.dart';
// import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
// import 'package:quikle_user/features/auth/controllers/welcome_controller.dart';
// import 'package:video_player/video_player.dart';

// class WelcomeScreen extends StatefulWidget {
//   const WelcomeScreen({super.key});

//   @override
//   State<WelcomeScreen> createState() => _WelcomeScreenState();
// }

// class _WelcomeScreenState extends State<WelcomeScreen> {
//   late VideoPlayerController _controller;
//   final WelcomeController welcomeController = Get.find<WelcomeController>();

//   @override
//   void initState() {
//     super.initState();
//     _controller =
//         VideoPlayerController.asset("assets/videos/welcome_screen.mp4")
//           ..initialize().then((_) {
//             setState(() {});
//             _controller.play();

//             // when video finishes → navigate
//             _controller.addListener(() {
//               if (_controller.value.position >= _controller.value.duration &&
//                   !_controller.value.isPlaying) {
//                 welcomeController.goToHome();
//               }
//             });
//           });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//       ),
//       child: Scaffold(
//         backgroundColor: AppColors.ebonyBlack,
//         body: Center(
//           child: SizedBox(
//             width: 392.w,
//             height: 852.h,
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: Center(
//                     child: Container(
//                       width: 708.w,
//                       height: 1047.h,
//                       decoration: const ShapeDecoration(
//                         color: Colors.black,
//                         shape: OvalBorder(),
//                       ),
//                     ),
//                   ),
//                 ),

//                 /// 👇 Video plays until end
//                 Positioned(
//                   left: 69.w,
//                   top: 315.h,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         width: 120.w,
//                         height: 120.w,
//                         child: _controller.value.isInitialized
//                             ? AspectRatio(
//                                 aspectRatio: _controller.value.aspectRatio,
//                                 child: VideoPlayer(_controller),
//                               )
//                             : const CircularProgressIndicator(),
//                       ),
//                       SizedBox(height: 20.h),
//                       Text.rich(
//                         TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Welcome To ',
//                               style: getTextStyle(
//                                 font: CustomFonts.obviously,
//                                 color: AppColors.eggshellWhite,
//                                 fontSize: 24.sp,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             TextSpan(
//                               text: 'Quikle',
//                               style: getTextStyle(
//                                 font: CustomFonts.obviously,
//                                 color: AppColors.beakYellow,
//                                 fontSize: 24.sp,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/auth/controllers/welcome_controller.dart';
import 'package:video_player/video_player.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late VideoPlayerController _controller;
  final WelcomeController welcomeController = Get.find<WelcomeController>();

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset("assets/videos/welcome_screen.mp4")
          ..initialize().then((_) {
            setState(() {});
            _controller.play();

            /// 👇 Force navigation after 4 seconds
            Future.delayed(const Duration(seconds: 3), () {
              if (mounted) {
                welcomeController.goToHome();
              }
            });
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.ebonyBlack,
        body: Center(
          child: SizedBox(
            width: 392.w,
            height: 852.h,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Center(
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

                /// 👇 Video plays for 4 seconds max
                Positioned(
                  left: 69.w,
                  top: 315.h,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 120.w,
                        height: 120.w,
                        child: _controller.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              )
                            : const CircularProgressIndicator(),
                      ),
                      SizedBox(height: 20.h),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Welcome To ',
                              style: getTextStyle(
                                font: CustomFonts.obviously,
                                color: AppColors.eggshellWhite,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: 'Quikle',
                              style: getTextStyle(
                                font: CustomFonts.obviously,
                                color: AppColors.beakYellow,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
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
