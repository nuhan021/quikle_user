import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';

class SearchAndFiltersSection extends StatelessWidget {
  /// Fixed height used for SliverPersistentHeader delegate
  static double kPreferredHeight = 52.0.h;

  final Function(String)? onSearchChanged;
  final VoidCallback? onVoiceTap;
  final String? searchHint;
  final Rx<String>? dynamicHint;
  final TextEditingController? searchController;

  const SearchAndFiltersSection({
    super.key,
    this.onSearchChanged,
    this.onVoiceTap,
    this.searchHint,
    this.dynamicHint,
    this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kPreferredHeight,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 36.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: .1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        if (dynamicHint != null &&
                            (searchController?.text.isEmpty ?? true))
                          Obx(() {
                            final hint = dynamicHint!.value;
                            return Row(
                              children: [
                                Text(
                                  _extractPrefix(hint),
                                  style: getTextStyle(
                                    font: CustomFonts.manrope,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.featherGrey,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                Text(
                                  _extractKeyword(hint),
                                  key: ValueKey(hint),
                                  style: getTextStyle(
                                    font: CustomFonts.manrope,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.featherGrey,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                Text(
                                  _extractSuffix(hint),
                                  style: getTextStyle(
                                    font: CustomFonts.manrope,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.featherGrey,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            );
                          }),
                        TextField(
                          controller: searchController,
                          onChanged: onSearchChanged,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: dynamicHint == null
                                ? (searchHint ?? 'Search products...')
                                : null,
                            hintStyle: getTextStyle(
                              font: CustomFonts.manrope,
                              fontWeight: FontWeight.w400,
                              color: AppColors.featherGrey,
                              fontSize: 12.sp,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isCollapsed: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                          ),
                          style: getTextStyle(
                            font: CustomFonts.manrope,
                            fontWeight: FontWeight.w400,
                            color: AppColors.ebonyBlack,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Image.asset(
                      ImagePath.voiceIcon,
                      width: 20.w,
                      height: 20.h,
                    ),
                    onPressed: onVoiceTap,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _extractPrefix(String hint) {
    final start = hint.indexOf("'");
    if (start != -1) {
      return hint.substring(0, start + 1);
    }
    return "Search for '";
  }

  String _extractKeyword(String hint) {
    final start = hint.indexOf("'");
    final end = hint.lastIndexOf("'");
    if (start != -1 && end != -1 && end > start) {
      return hint.substring(start + 1, end);
    }
    return hint.replaceAll("Search for '", "").replaceAll("'", "");
  }

  String _extractSuffix(String hint) {
    final end = hint.lastIndexOf("'");
    if (end != -1) {
      return hint.substring(end);
    }
    return "'";
  }
}
