import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';

class AddressTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final int maxLines;
  final RxString? errorText;
  final TextInputType? keyboardType;
  final bool enabled;

  const AddressTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.maxLines = 1,
    this.errorText,
    this.keyboardType,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: enabled ? AppColors.backgroundLight : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: enabled ? AppColors.cardColor : Colors.grey.shade300,
              width: 1.5.w,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            enabled: enabled,
            readOnly: !enabled,
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
              prefixIcon: icon != null
                  ? Padding(
                      padding: EdgeInsets.only(left: 12.w, right: 8.w),
                      child: Icon(
                        icon,
                        color: enabled
                            ? AppColors.textSecondary
                            : Colors.grey.shade400,
                        size: 22.sp,
                      ),
                    )
                  : null,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: icon != null ? 8.w : 16.w,
                vertical: maxLines > 1 ? 16.h : 14.h,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Obx(
            () => errorText!.value.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: 6.h, left: 4.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 14.sp,
                          color: Colors.red,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          errorText!.value,
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
      ],
    );
  }
}
