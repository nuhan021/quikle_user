import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/search/controllers/search_controller.dart';

class SearchBar extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback? onVoiceTap;

  const SearchBar({super.key, required this.onTap, this.onVoiceTap});

  static double get kPreferredHeight => 52.h;

  @override
  Widget build(BuildContext context) {
    final ProductSearchController controller =
        ProductSearchController.currentInstance ??
        Get.put(ProductSearchController());

    return SizedBox(
      height: kPreferredHeight,
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 4.h),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() {
                  final hint = controller.currentPlaceholder.value;
                  return Row(
                    children: [
                      Text(
                        "Search for '",
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        _extractKeyword(hint),
                        key: ValueKey(hint),
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        "'",
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  );
                }),
                Row(
                  children: [
                    Container(
                      width: 1.w,
                      height: 24.h,
                      color: Colors.grey.withValues(alpha: 0.3),
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                    ),
                    Obx(() {
                      final isListening = controller.isListening;
                      return GestureDetector(
                        onTap: onVoiceTap ?? controller.toggleVoiceRecognition,
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: isListening
                                ? AppColors.primary.withValues(alpha: 0.10)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Image.asset(
                            ImagePath.voiceIcon,
                            height: 16.w,
                            width: 16.w,
                            color: isListening
                                ? AppColors.primary
                                : Colors.grey,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _extractKeyword(String hint) {
    final start = hint.indexOf("'");
    final end = hint.lastIndexOf("'");
    if (start != -1 && end != -1 && end > start) {
      return hint.substring(start + 1, end);
    }
    return hint;
  }
}
