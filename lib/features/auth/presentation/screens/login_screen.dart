// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:quikle_user/core/common/styles/global_text_style.dart';
// import 'package:quikle_user/core/utils/constants/colors.dart';
// import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
// import 'package:quikle_user/features/auth/controllers/login_controller.dart';
// import 'package:quikle_user/features/auth/presentation/screens/icon_carousel.dart';
// import 'package:quikle_user/features/auth/presentation/screens/product_icons.dart';
// import 'package:quikle_user/features/auth/presentation/widgets/common_widgets.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<LoginController>();
//     final base = ProductIcons.asProviders();

//     final rows = _calculateCarouselRows(context);
//     final rowHeight = _calculateRowHeight(context, rows);

//     final gradientHeight =
//         MediaQuery.of(context).size.height * 0.4; // same as gradient overlay
//     final rowSpacing = 12.h;

//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//       ),
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         backgroundColor: Colors.black,
//         body: SafeArea(
//           child: Stack(
//             children: [
//               // 1. Carousel in background
//               Positioned(
//                 top: 10,
//                 left: 0,
//                 right: 0,
//                 child: _buildCarouselSection(
//                   _generateCarouselData(base, rows),
//                   rowHeight,
//                   rowSpacing,
//                 ),
//               ),

//               // 2. Gradient and solid black overlay
//               Positioned.fill(
//                 child: Builder(
//                   builder: (context) {
//                     final logoTopOffset =
//                         MediaQuery.of(context).size.height * 0.35;
//                     final logoHeight = 40.w;
//                     final gradientEndOffset = logoTopOffset + logoHeight / 2;

//                     return Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           stops: [
//                             gradientEndOffset /
//                                 MediaQuery.of(context).size.height,
//                             (gradientEndOffset + 20) /
//                                 MediaQuery.of(context).size.height,
//                             (gradientEndOffset + 40) /
//                                 MediaQuery.of(context).size.height,

//                             (gradientEndOffset + 60) /
//                                 MediaQuery.of(context).size.height,
//                           ],
//                           colors: [
//                             Colors.transparent,

//                             Colors.black.withOpacity(0.4),
//                             Colors.black.withOpacity(0.7),
//                             Colors.black.withOpacity(0.9),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),

//               // 3. Content
//               Positioned.fill(
//                 top: MediaQuery.of(context).size.height * 0.4,
//                 child: SingleChildScrollView(
//                   child: _buildContentSection(controller),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// Decide number of rows based on screen height
//   int _calculateCarouselRows(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     if (screenHeight < 650) return 2;
//     if (screenHeight < 800) return 3;
//     if (screenHeight < 950) return 4;
//     return 4;
//   }

//   /// Calculate row height dynamically
//   double _calculateRowHeight(BuildContext context, int rows) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final availableForCarousel = screenHeight * 0.45;
//     return availableForCarousel / rows;
//   }

//   /// Prepare shuffled data for carousel rows
//   List<List<ImageProvider>> _generateCarouselData(
//     List<ImageProvider> base,
//     int rows,
//   ) {
//     final carouselData = <List<ImageProvider>>[];
//     for (int i = 0; i < rows; i++) {
//       final shuffledIcons = List<ImageProvider>.from(base)
//         ..shuffle(Random(i + 1));
//       carouselData.add(shuffledIcons);
//     }
//     return carouselData;
//   }

//   /// Build carousel with row spacing
//   Widget _buildCarouselSection(
//     List<List<ImageProvider>> carouselData,
//     double rowHeight,
//     double rowSpacing,
//   ) {
//     return Column(
//       children: carouselData.asMap().entries.map((entry) {
//         final index = entry.key;
//         final icons = entry.value;
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: index == carouselData.length - 1 ? 0 : rowSpacing,
//           ),
//           child: SizedBox(
//             height: rowHeight,
//             child: IconRowMarquee(
//               images: icons,
//               speed: 24,
//               offsetSlots: index * 0.25,
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   /// Build form + content
//   Widget _buildContentSection(LoginController controller) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: Column(
//         children: [
//           CommonWidgets.appLogo(),
//           SizedBox(height: 16.h),
//           Obx(() {
//             return Column(
//               children: [
//                 SizedBox(
//                   //width: 280.w,
//                   child: Text(
//                     controller.isExistingUser.value
//                         ? 'We deliver quickly'
//                         : 'Join Quikle',
//                     style: getTextStyle(
//                       font: CustomFonts.obviously,
//                       color: AppColors.eggshellWhite,
//                       fontSize: 28.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 SizedBox(
//                   width: 280.w,
//                   child: Text(
//                     controller.isExistingUser.value
//                         ? 'Log in or sign up'
//                         : 'Create your account to get started',
//                     style: getTextStyle(
//                       font: CustomFonts.inter,
//                       color: const Color(0xFF9B9B9B),
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             );
//           }),
//           SizedBox(height: 24.h),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               'Phone Number',
//               style: getTextStyle(
//                 font: CustomFonts.inter,
//                 color: AppColors.eggshellWhite,
//                 fontSize: 16.sp,
//               ),
//             ),
//           ),
//           SizedBox(height: 10.h),
//           _styledTextField(
//             controller: controller.phoneController,
//             hintText: 'Enter mobile number',
//             keyboardType: TextInputType.phone,
//           ),
//           Obx(() {
//             return AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               height: controller.showNameField.value ? null : 0,
//               child: controller.showNameField.value
//                   ? Column(
//                       children: [
//                         SizedBox(height: 16.h),
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'Full Name',
//                             style: getTextStyle(
//                               font: CustomFonts.inter,
//                               color: AppColors.eggshellWhite,
//                               fontSize: 16.sp,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 10.h),
//                         _styledTextField(
//                           controller: controller.nameController,
//                           hintText: 'Enter your full name',
//                         ),
//                       ],
//                     )
//                   : const SizedBox.shrink(),
//             );
//           }),
//           SizedBox(height: 24.h),
//           Obx(() {
//             return CommonWidgets.primaryButton(
//               text: controller.isLoading.value ? 'Please wait...' : 'Continue',
//               onTap: controller.isLoading.value
//                   ? () {}
//                   : () => controller.onTapContinue(),
//             );
//           }),
//           SizedBox(height: 16.h),
//           SizedBox(
//             width: 360.w,
//             child: Text.rich(
//               TextSpan(
//                 children: [
//                   TextSpan(
//                     text: 'By continuing, you agree to our ',
//                     style: getTextStyle(
//                       font: CustomFonts.inter,
//                       color: AppColors.featherGrey,
//                       fontSize: 12.sp,
//                     ),
//                   ),
//                   TextSpan(
//                     text: 'Terms of Service',
//                     style: getTextStyle(
//                       font: CustomFonts.inter,
//                       color: AppColors.beakYellow,
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   TextSpan(
//                     text: ' and ',
//                     style: getTextStyle(
//                       font: CustomFonts.inter,
//                       color: AppColors.featherGrey,
//                       fontSize: 12.sp,
//                     ),
//                   ),
//                   TextSpan(
//                     text: 'Privacy Policy',
//                     style: getTextStyle(
//                       font: CustomFonts.inter,
//                       color: AppColors.beakYellow,
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           SizedBox(height: 20.h),
//         ],
//       ),
//     );
//   }

//   Widget _styledTextField({
//     required TextEditingController controller,
//     required String hintText,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Container(
//       width: double.infinity,
//       height: 52.h,
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//       decoration: ShapeDecoration(
//         shape: RoundedRectangleBorder(
//           side: const BorderSide(width: 1, color: Color(0xFF7C7C7C)),
//           borderRadius: BorderRadius.circular(8.r),
//         ),
//       ),
//       alignment: Alignment.centerLeft,
//       child: TextField(
//         controller: controller,
//         keyboardType: keyboardType,
//         enableSuggestions: false,
//         autocorrect: false,
//         style: getTextStyle(
//           font: CustomFonts.inter,
//           color: AppColors.eggshellWhite,
//         ),
//         cursorColor: const Color(0xFFF8F8F8),
//         decoration: InputDecoration(
//           isCollapsed: true,
//           border: InputBorder.none,
//           enabledBorder: InputBorder.none,
//           focusedBorder: InputBorder.none,
//           hintText: hintText,
//           hintStyle: getTextStyle(
//             font: CustomFonts.inter,
//             color: AppColors.featherGrey,
//           ),
//           counterText: "",
//           contentPadding: EdgeInsets.zero,
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';
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
    final base = ProductIcons.asProviders();

    final rowSpacing = 12.h;

    // Decide max number of rows for this screen
    final maxRows = _calculateCarouselRows(context);

    // Gradient height = the visible area for carousel
    final gradientHeight = MediaQuery.of(context).size.height * 0.4;

    // Calculate row height dynamically
    final totalRowSpacing = rowSpacing * (maxRows - 1);
    final rowHeight = (gradientHeight - totalRowSpacing) / maxRows;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              // 1. Carousel behind gradient
              Positioned(
                top: 10,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: SizedBox(
                    height: gradientHeight, // Clip to gradient height
                    child: _buildCarouselSection(
                      _generateCarouselData(base, maxRows),
                      rowHeight,
                      rowSpacing,
                    ),
                  ),
                ),
              ),

              // 2. Gradient overlay
              Positioned.fill(
                child: Builder(
                  builder: (context) {
                    final logoTopOffset =
                        MediaQuery.of(context).size.height * 0.35;
                    final logoHeight = 40.w;
                    final gradientEndOffset = logoTopOffset + logoHeight / 2;

                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [
                            gradientEndOffset /
                                MediaQuery.of(context).size.height,
                            (gradientEndOffset + 20) /
                                MediaQuery.of(context).size.height,
                            (gradientEndOffset + 40) /
                                MediaQuery.of(context).size.height,
                            (gradientEndOffset + 60) /
                                MediaQuery.of(context).size.height,
                          ],
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.9),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 3. Content section (logo, text fields, button)
              Positioned.fill(
                top: MediaQuery.of(context).size.height * 0.4,
                child: SingleChildScrollView(
                  child: _buildContentSection(controller),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Decide number of rows based on screen height
  int _calculateCarouselRows(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight < 650) return 2;
    if (screenHeight < 800) return 3;
    if (screenHeight < 950) return 4;
    return 4;
  }

  /// Prepare shuffled data for carousel rows
  List<List<ImageProvider>> _generateCarouselData(
    List<ImageProvider> base,
    int rows,
  ) {
    final carouselData = <List<ImageProvider>>[];
    for (int i = 0; i < rows; i++) {
      final shuffledIcons = List<ImageProvider>.from(base)
        ..shuffle(Random(i + 1));
      carouselData.add(shuffledIcons);
    }
    return carouselData;
  }

  /// Build carousel rows with spacing
  Widget _buildCarouselSection(
    List<List<ImageProvider>> carouselData,
    double rowHeight,
    double rowSpacing,
  ) {
    return Column(
      children: carouselData.asMap().entries.map((entry) {
        final index = entry.key;
        final icons = entry.value;
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == carouselData.length - 1 ? 0 : rowSpacing,
          ),
          child: SizedBox(
            height: rowHeight,
            child: IconRowMarquee(
              images: icons,
              speed: 24,
              //offsetSlots: index * 0.25,
              offsetSlots: _getOfferSlots(index),
            ),
          ),
        );
      }).toList(),
    );
  }

  double _getOfferSlots(int index) {
    if (index == 0) {
      return 0.90;
    } else if (index == 1) {
      return 0.40;
    } else if (index == 2) {
      return 0.65;
    } else {
      return 0.15;
    }
  }

  /// Build content section (logo, text fields, button)
  Widget _buildContentSection(LoginController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          CommonWidgets.appLogo(),
          SizedBox(height: 16.h),
          Obx(() {
            return Column(
              children: [
                SizedBox(
                  child: Text(
                    'We deliver quickly',
                    style: getTextStyle(
                      font: CustomFonts.obviously,
                      color: AppColors.eggshellWhite,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  width: 280.w,
                  child: Text(
                    controller.isExistingUser.value
                        ? 'Log in or sign up'
                        : 'Create your account to get started',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      color: const Color(0xFF9B9B9B),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          }),
          SizedBox(height: 24.h),
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
          _styledTextField(
            controller: controller.phoneController,
            hintText: 'Enter mobile number',
            keyboardType: TextInputType.phone,
          ),
          Obx(() {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: controller.showNameField.value ? null : 0,
              child: controller.showNameField.value
                  ? Column(
                      children: [
                        SizedBox(height: 16.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Full Name',
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              color: AppColors.eggshellWhite,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        _styledTextField(
                          controller: controller.nameController,
                          hintText: 'Enter your full name',
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            );
          }),
          SizedBox(height: 24.h),
          Obx(() {
            return CommonWidgets.primaryButton(
              text: controller.isLoading.value ? 'Please wait...' : 'Continue',
              onTap: controller.isLoading.value
                  ? () {}
                  : () => controller.onTapContinue(),
            );
          }),
          SizedBox(height: 16.h),
          SizedBox(
            width: 360.w,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'By continuing, you agree to our ',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      color: AppColors.featherGrey,
                      fontSize: 12.sp,
                    ),
                  ),
                  TextSpan(
                    text: 'Terms of Service',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      color: AppColors.beakYellow,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: ' and ',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      color: AppColors.featherGrey,
                      fontSize: 12.sp,
                    ),
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      color: AppColors.beakYellow,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _styledTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      width: double.infinity,
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF7C7C7C)),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        enableSuggestions: false,
        autocorrect: false,
        style: getTextStyle(
          font: CustomFonts.inter,
          color: AppColors.eggshellWhite,
        ),
        cursorColor: const Color(0xFFF8F8F8),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: getTextStyle(
            font: CustomFonts.inter,
            color: AppColors.featherGrey,
          ),
          counterText: "",
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
