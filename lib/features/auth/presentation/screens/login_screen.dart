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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTopSection(context),
                        _buildContentSection(controller),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    final base = ProductIcons.asProviders();
    final maxRows = _calculateCarouselRows(context);
    final rowSpacing = 12.h;
    final gradientHeight = MediaQuery.of(context).size.height * 0.4;
    final totalRowSpacing = rowSpacing * (maxRows - 1);
    final rowHeight = (gradientHeight - totalRowSpacing) / maxRows;

    return SizedBox(
      height: gradientHeight,
      child: Stack(
        children: [
          ClipRect(
            child: SizedBox(
              height: gradientHeight,
              child: _buildCarouselSection(
                _generateCarouselData(base, maxRows),
                rowHeight,
                rowSpacing,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.5, 0.7, 0.85, 1],
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.4),
                  Colors.black.withValues(alpha: 0.7),
                  Colors.black.withValues(alpha: 0.9),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateCarouselRows(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight < 650) return 2;
    if (screenHeight < 800) return 3;
    if (screenHeight < 950) return 4;
    return 4;
  }

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
              offsetSlots: _getOfferSlots(index),
            ),
          ),
        );
      }).toList(),
    );
  }

  double _getOfferSlots(int index) {
    if (index == 0) return 0.90;
    if (index == 1) return 0.40;
    if (index == 2) return 0.65;
    return 0.15;
  }

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
                Text(
                  'We deliver quickly',
                  style: getTextStyle(
                    font: CustomFonts.obviously,
                    color: AppColors.eggshellWhite,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
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
          Container(
            width: double.infinity,
            height: 52.h,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFF7C7C7C)),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 45.w,
                  padding: EdgeInsets.only(left: 8.w),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '+91',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      color: AppColors.eggshellWhite,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                Container(
                  width: 1,
                  height: 28.h,
                  color: const Color(0xFF7C7C7C),
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: TextField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      enableSuggestions: false,
                      autocorrect: false,
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        color: AppColors.eggshellWhite,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: const Color(0xFFF8F8F8),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: 'Enter mobile number',
                        hintStyle: getTextStyle(
                          font: CustomFonts.inter,
                          color: AppColors.featherGrey,
                          fontSize: 14.sp,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // SizedBox(height: 12.h),
          Obx(() {
            final msg = controller.errorMessage.value;
            if (msg.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(top: 8.h, bottom: 12.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  msg,
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    color: Colors.redAccent,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }),

          SizedBox(height: 12.h),
          Obx(() {
            return CommonWidgets.primaryButton(
              text: controller.isLoading.value ? 'Please wait...' : 'Continue',
              onTap: controller.isLoading.value
                  ? () {}
                  : () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      controller.onTapContinue();
                    },
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
}
