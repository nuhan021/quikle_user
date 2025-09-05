import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/routes/app_routes.dart';

class EmptyCartScreen extends StatelessWidget {
  const EmptyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(AppRoute.getHome());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ebonyBlack,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Start Shopping',
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.beakYellow,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
                border: Border(
                  bottom: BorderSide(color: AppColors.gradientColor, width: 2),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Cart',
                    style: getTextStyle(
                      font: CustomFonts.obviously,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ebonyBlack,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Cart image
                    SizedBox(
                      width: 225.w,
                      height: 120.w,
                      child: Image.asset(
                        ImagePath.emptyCart,
                        width: 80.w,
                        height: 80.w,
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: 32.h),

                    Text(
                      'Your cart is empty !',
                      style: getTextStyle(
                        font: CustomFonts.obviously,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.ebonyBlack,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      'You will get a response within\na few minutes.',
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.emptyCardText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
