import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';

class ProgressStep extends StatelessWidget {
  final Map<String, dynamic> step;

  const ProgressStep({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    final isCompleted = step['isCompleted'] ?? false;
    final isCurrent = step['isCurrent'] ?? false;

    final iconColor = isCompleted
        ? const Color(0xFF06BD4C)
        : isCurrent
        ? const Color(0xFFFFC200)
        : const Color(0xFFE0E0E0);

    final textColor = isCompleted || isCurrent
        ? const Color(0xFF333333)
        : const Color(0xFF9B9B9B);

    final timeColor = isCompleted || isCurrent
        ? const Color(0xFF7C7C7C)
        : const Color(0xFF9B9B9B);

    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepIcon(isCompleted, isCurrent, iconColor),
          SizedBox(width: 16.w),
          _buildStepContent(textColor, timeColor),
          if (isCurrent) _buildCurrentIndicator(),
        ],
      ),
    );
  }

  Widget _buildStepIcon(bool isCompleted, bool isCurrent, Color iconColor) {
    return Container(
      width: 24.w,
      height: 24.h,
      decoration: BoxDecoration(
        color: iconColor,
        shape: BoxShape.circle,
        border: Border.all(color: iconColor, width: 2),
      ),
      child: isCompleted
          ? Icon(Icons.check, color: Colors.white, size: 14.sp)
          : isCurrent
          ? Container(
              margin: EdgeInsets.all(4.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }

  Widget _buildStepContent(Color textColor, Color timeColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step['title'] ?? '',
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          if (step['description'] != null) ...[
            SizedBox(height: 2.h),
            Text(
              step['description'],
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: timeColor,
              ),
            ),
          ],
          if (step['time'] != null) ...[
            SizedBox(height: 4.h),
            Text(
              step['time'] is DateTime
                  ? DateFormat('HH:mm a').format(step['time'])
                  : step['time'].toString(),
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: timeColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentIndicator() {
    return Container(
      width: 8.w,
      height: 8.h,
      decoration: const BoxDecoration(
        color: Color(0xFF06BD4C),
        shape: BoxShape.circle,
      ),
    );
  }
}
