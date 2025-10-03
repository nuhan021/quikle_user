import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/prescription/data/models/prescription_model.dart';

class PrescriptionStatusWidget extends StatelessWidget {
  final String notes;
  final PrescriptionStatus status;

  const PrescriptionStatusWidget({
    super.key,
    required this.notes,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withValues(alpha: .1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: _getStatusColor(status),
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    notes,
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: _getStatusColor(status),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Color _getStatusColor(PrescriptionStatus status) {
    switch (status) {
      case PrescriptionStatus.uploaded:
        return Colors.blue;
      case PrescriptionStatus.underReview:
        return Colors.orange;
      case PrescriptionStatus.valid:
        return Colors.green;
      case PrescriptionStatus.invalid:
        return Colors.red;
      case PrescriptionStatus.medicinesReady:
        return Colors.green;
    }
  }
}
