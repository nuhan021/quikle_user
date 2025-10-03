import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/prescription/data/models/prescription_model.dart';

class PrescriptionTimelineWidget extends StatelessWidget {
  final PrescriptionModel prescription;

  const PrescriptionTimelineWidget({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline, color: Colors.blue.shade600, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Prescription Status',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          _buildTimelineStep(
            icon: Icons.cloud_upload,
            title: 'Uploaded',
            description: 'Prescription uploaded successfully',
            isCompleted: true,
            isActive: prescription.status == PrescriptionStatus.uploaded,
            color: Colors.blue,
          ),

          _buildTimelineStep(
            icon: Icons.schedule,
            title: 'Under Review',
            description: 'A pharmacy is reviewing your prescription',
            isCompleted:
                prescription.status.index >=
                PrescriptionStatus.underReview.index,
            isActive: prescription.status == PrescriptionStatus.underReview,
            color: Colors.orange,
          ),

          _buildTimelineStep(
            icon: Icons.check_circle_outline,
            title: 'Validation',
            description: 'Checking prescription validity',
            isCompleted:
                prescription.status.index >= PrescriptionStatus.valid.index ||
                prescription.status == PrescriptionStatus.invalid,
            isActive:
                prescription.status == PrescriptionStatus.valid ||
                prescription.status == PrescriptionStatus.invalid,
            color: prescription.status == PrescriptionStatus.invalid
                ? Colors.red
                : Colors.green,
          ),

          if (prescription.status == PrescriptionStatus.medicinesReady)
            _buildTimelineStep(
              icon: Icons.local_pharmacy,
              title: 'Medicines Ready',
              description: 'Medicines are ready for order',
              isCompleted: true,
              isActive: true,
              color: Colors.green,
              isLast: true,
            ),

          if (prescription.status == PrescriptionStatus.invalid) ...[
            SizedBox(height: 8.h),
            _buildStatusAlert(
              icon: Icons.error_outline,
              message:
                  'Prescription is invalid. Please check and upload a valid one.',
              color: Colors.red,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required IconData icon,
    required String title,
    required String description,
    required bool isCompleted,
    required bool isActive,
    required Color color,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: isCompleted || isActive ? color : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isCompleted || isActive
                    ? Colors.white
                    : Colors.grey.shade600,
                size: 16.sp,
              ),
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 24.h,
                color: isCompleted ? color : Colors.grey.shade300,
              ),
          ],
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isCompleted || isActive
                        ? color
                        : Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusAlert({
    required IconData icon,
    required String message,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: .3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: color.withValues(alpha: .8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
