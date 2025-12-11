import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/prescription/controllers/prescription_controller.dart';
import 'package:quikle_user/features/prescription/data/models/prescription_model.dart';

class PrescriptionUploadSection extends StatelessWidget {
  const PrescriptionUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PrescriptionController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12).w,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.medical_services,
                    color: Colors.blue.shade600,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Need Prescription Medicines?',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ebonyBlack,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Upload your prescription to check medicine availability',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.ebonyBlack.withValues(alpha: .6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            Obx(() {
              if (controller.isUploading.value) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.cloud_upload,
                          color: Colors.blue.shade600,
                          size: 16.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Uploading prescription...',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    LinearProgressIndicator(
                      value: controller.uploadProgress.value,
                      backgroundColor: Colors.blue.shade100,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue.shade600,
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),

            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.isUploading.value
                      ? null
                      : controller.showUploadOptions,
                  icon: Icon(
                    Icons.upload_file,
                    size: 18.sp,
                    color: Colors.white,
                  ),
                  label: Text(
                    controller.isUploading.value
                        ? 'Uploading...'
                        : 'Upload Prescription',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                ),
              );
            }),

            SizedBox(height: 12.h),

            // View All Prescriptions Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Get.toNamed('/prescription-list'),
                icon: Icon(
                  Icons.list_alt,
                  size: 18.sp,
                  color: Colors.blue.shade600,
                ),
                label: Text(
                  'View All Prescriptions',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  side: BorderSide(color: Colors.blue.shade600, width: 1.5),
                ),
              ),
            ),

            SizedBox(height: 12.h),

            Obx(() {
              if (controller.prescriptions.isEmpty)
                return const SizedBox.shrink();

              final prescription = controller.prescriptions.first;

              String _normalize(String p) =>
                  p.startsWith('file://') ? p.replaceFirst('file://', '') : p;

              Widget _thumbPlaceholder() {
                return Container(
                  width: 56.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Icon(
                    Icons.image_outlined,
                    color: Colors.grey.shade500,
                    size: 24.sp,
                  ),
                );
              }

              Widget _buildThumb(String path) {
                final normalized = _normalize(path);
                if (normalized.startsWith('http://') ||
                    normalized.startsWith('https://')) {
                  return Image.network(
                    normalized,
                    fit: BoxFit.cover,
                    width: 56.w,
                    height: 56.h,
                    errorBuilder: (c, e, s) => _thumbPlaceholder(),
                  );
                }
                try {
                  return Image.file(
                    File(normalized),
                    fit: BoxFit.cover,
                    width: 56.w,
                    height: 56.h,
                    errorBuilder: (c, e, s) => _thumbPlaceholder(),
                  );
                } catch (_) {
                  return _thumbPlaceholder();
                }
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Prescription',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ebonyBlack,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed('/prescription-list'),
                        child: Text(
                          'View All',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: _buildThumb(prescription.imagePath),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prescription.fileName,
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ebonyBlack,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              // Compact status chip: icon + status text
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                    prescription.status,
                                  ).withValues(alpha: .12),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: _getStatusColor(
                                      prescription.status,
                                    ).withValues(alpha: .18),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      prescription.status ==
                                              PrescriptionStatus.uploaded
                                          ? Icons.cloud_upload
                                          : prescription.status ==
                                                PrescriptionStatus.underReview
                                          ? Icons.schedule
                                          : prescription.status ==
                                                PrescriptionStatus.valid
                                          ? Icons.check_circle_outline
                                          : prescription.status ==
                                                PrescriptionStatus.invalid
                                          ? Icons.error_outline
                                          : Icons.local_pharmacy,
                                      size: 14.sp,
                                      color: _getStatusColor(
                                        prescription.status,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      prescription.status.displayName,
                                      style: getTextStyle(
                                        font: CustomFonts.inter,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: _getStatusColor(
                                          prescription.status,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () => controller.viewPrescriptionDetails(
                                prescription,
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade600,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  'View Details',
                                  style: getTextStyle(
                                    font: CustomFonts.inter,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
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
