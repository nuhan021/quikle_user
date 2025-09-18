
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

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                      'Upload your prescription to get quotes from vendors',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.ebonyBlack.withOpacity(0.6),
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
                icon: Icon(Icons.upload_file, size: 18.sp, color: Colors.white),
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

          
          Obx(() {
            if (controller.prescriptions.isEmpty) {
              return const SizedBox.shrink();
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
                ...controller.prescriptions.take(1).map((prescription) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              prescription.status,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Icon(
                            _getStatusIcon(prescription.status),
                            color: _getStatusColor(prescription.status),
                            size: 16.sp,
                          ),
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
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.ebonyBlack,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                prescription.status.displayName,
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w400,
                                  color: _getStatusColor(prescription.status),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (prescription.vendorResponses.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              '${prescription.vendorResponses.length} offer${prescription.vendorResponses.length > 1 ? 's' : ''}',
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            );
          }),

          
          Obx(() {
            
            final recentPrescription = controller.prescriptions.isNotEmpty
                ? controller.prescriptions.first
                : null;

            if (recentPrescription == null) {
              return const SizedBox.shrink();
            }

            
            if (recentPrescription.status == PrescriptionStatus.uploaded ||
                recentPrescription.status == PrescriptionStatus.processing) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Icon(
                            Icons.hourglass_empty,
                            color: Colors.orange.shade600,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recentPrescription.status ==
                                        PrescriptionStatus.uploaded
                                    ? 'Prescription Uploaded'
                                    : 'Processing',
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Vendors are reviewing your prescription...',
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.ebonyBlack.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            
            if (controller.recentPrescriptionMedicines.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green.shade600,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vendor Accepted',
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '${controller.recentPrescriptionMedicines.length} medicine${controller.recentPrescriptionMedicines.length > 1 ? 's' : ''} available to add to cart',
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.ebonyBlack.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed('/prescription-list'),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade600,
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
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Color _getStatusColor(PrescriptionStatus status) {
    switch (status) {
      case PrescriptionStatus.uploaded:
        return Colors.blue;
      case PrescriptionStatus.processing:
        return Colors.orange;
      case PrescriptionStatus.responded:
        return Colors.green;
      case PrescriptionStatus.expired:
        return Colors.red;
      case PrescriptionStatus.rejected:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(PrescriptionStatus status) {
    switch (status) {
      case PrescriptionStatus.uploaded:
        return Icons.cloud_upload;
      case PrescriptionStatus.processing:
        return Icons.hourglass_empty;
      case PrescriptionStatus.responded:
        return Icons.check_circle;
      case PrescriptionStatus.expired:
        return Icons.access_time;
      case PrescriptionStatus.rejected:
        return Icons.cancel;
    }
  }
}
