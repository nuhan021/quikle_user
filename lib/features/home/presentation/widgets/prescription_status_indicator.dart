import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/prescription/controllers/prescription_controller.dart';
import 'package:quikle_user/features/prescription/data/models/prescription_model.dart';

class PrescriptionStatusIndicator extends StatelessWidget {
  const PrescriptionStatusIndicator({super.key});

  static double get kPreferredHeight => 80.h;

  static PrescriptionModel? latestActive(List<PrescriptionModel> list) {
    if (list.isEmpty) return null;
    final filtered = list.toList()
      ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    return filtered.isEmpty ? null : filtered.first;
  }

  static bool hasVisibleStatus(List<PrescriptionModel> list) {
    return latestActive(list) != null;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PrescriptionController>();

    return Obx(() {
      final latest = latestActive(controller.prescriptions);
      if (latest == null) return const SizedBox.shrink();

      final meta = _metaFor(latest.status);
      final isRefreshing = controller.isRefreshing.value;

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: meta.color.withValues(alpha: .08), // light tint background
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: meta.color.withValues(alpha: .25), // stronger shadow
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: meta.color,
            width: 1.5,
          ), // solid highlight border
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => _openDetails(latest),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              children: [
                Row(
                  children: [
                    // Left icon
                    Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color: meta.color.withValues(alpha: .20),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: isRefreshing
                          ? SizedBox(
                              width: 20.sp,
                              height: 20.sp,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  meta.color,
                                ),
                              ),
                            )
                          : Icon(meta.icon, color: meta.color, size: 20.sp),
                    ),
                    SizedBox(width: 12.w),

                    // Header and sub-header message
                    Expanded(
                      child: isRefreshing
                          ? Text(
                              'Updating status...',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ebonyBlack,
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  meta.header,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: getTextStyle(
                                    font: CustomFonts.inter,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ebonyBlack,
                                  ),
                                ),
                                if (meta.subHeader.isNotEmpty) ...[
                                  SizedBox(height: 2.h),
                                  Text(
                                    meta.subHeader,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: getTextStyle(
                                      font: CustomFonts.inter,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.ebonyBlack.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                    ),

                    // View action
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: meta.color,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.chevron_right,
                          color: meta.color,
                          size: 18.sp,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  _StatusMeta _metaFor(PrescriptionStatus status) {
    switch (status) {
      case PrescriptionStatus.uploaded:
        return _StatusMeta(
          header: 'Prescription Uploaded',
          subHeader: '',
          icon: Icons.cloud_upload,
          color: Colors.blue,
        );
      case PrescriptionStatus.underReview:
        return _StatusMeta(
          header: 'Prescription Uploaded',
          subHeader: 'Under Review',
          icon: Icons.schedule,
          color: Colors.orange,
        );
      case PrescriptionStatus.valid:
        return _StatusMeta(
          header: 'Prescription Valid',
          subHeader: 'Checking medicines',
          icon: Icons.check_circle_outline,
          color: Colors.green,
        );
      case PrescriptionStatus.invalid:
        return _StatusMeta(
          header: 'Prescription Invalid',
          subHeader: 'Tap to view details',
          icon: Icons.error_outline,
          color: Colors.red,
        );
      case PrescriptionStatus.medicinesReady:
        return _StatusMeta(
          header: 'Medicines Ready',
          subHeader: 'View List',
          icon: Icons.local_pharmacy,
          color: Colors.green,
        );
    }
  }

  void _openDetails(PrescriptionModel p) {
    final controller = Get.find<PrescriptionController>();
    controller.viewPrescriptionDetails(p);
  }
}

class _StatusMeta {
  final String header;
  final String subHeader;
  final IconData icon;
  final Color color;
  const _StatusMeta({
    required this.header,
    required this.subHeader,
    required this.icon,
    required this.color,
  });
}




//If need shimmer effect in future

/*

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/prescription/controllers/prescription_controller.dart';
import 'package:quikle_user/features/prescription/data/models/prescription_model.dart';
import 'package:shimmer/shimmer.dart';

class PrescriptionStatusIndicator extends StatelessWidget {
  const PrescriptionStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PrescriptionController>();

    return Obx(() {
      final latest = _latestActive(controller.prescriptions);
      if (latest == null) return const SizedBox.shrink();

      final meta = _metaFor(latest.status);
      final isRefreshing = controller.isRefreshing.value;

      if (isRefreshing) {
        return _buildShimmerSkeleton();
      }

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: meta.color.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: meta.color.withValues(alpha: .25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: meta.color, width: 1.5),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => _openDetails(latest),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                // Left icon
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: meta.color.withValues(alpha: .20),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(meta.icon, color: meta.color, size: 20.sp),
                ),
                SizedBox(width: 12.w),

                // Header and sub-header
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        meta.header,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ebonyBlack,
                        ),
                      ),
                      if (meta.subHeader.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        Text(
                          meta.subHeader,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.ebonyBlack.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // View action
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: meta.color,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.chevron_right, color: meta.color, size: 18.sp),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  /// ✨ Shimmer skeleton that mimics layout (icon + 2 text lines)
  Widget _buildShimmerSkeleton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Shimmer box for icon
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Title + subtitle shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 12.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 10.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // "View" small shimmer bar
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 10.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PrescriptionModel? _latestActive(List<PrescriptionModel> list) {
    if (list.isEmpty) return null;
    final filtered = list.toList()
      ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    return filtered.isEmpty ? null : filtered.first;
  }

  _StatusMeta _metaFor(PrescriptionStatus status) {
    switch (status) {
      case PrescriptionStatus.uploaded:
        return _StatusMeta(
          header: 'Prescription Uploaded',
          subHeader: '',
          icon: Icons.cloud_upload,
          color: Colors.blue,
        );
      case PrescriptionStatus.underReview:
        return _StatusMeta(
          header: 'Prescription Uploaded',
          subHeader: 'Under Review',
          icon: Icons.schedule,
          color: Colors.orange,
        );
      case PrescriptionStatus.valid:
        return _StatusMeta(
          header: 'Prescription Valid',
          subHeader: 'Checking medicines',
          icon: Icons.check_circle_outline,
          color: Colors.green,
        );
      case PrescriptionStatus.invalid:
        return _StatusMeta(
          header: 'Prescription Invalid',
          subHeader: 'Expired date/Incomplete/Unclear/etc',
          icon: Icons.error_outline,
          color: Colors.red,
        );
      case PrescriptionStatus.medicinesReady:
        return _StatusMeta(
          header: 'Medicines Ready',
          subHeader: 'View List',
          icon: Icons.local_pharmacy,
          color: Colors.green,
        );
    }
  }

  void _openDetails(PrescriptionModel p) {
    final controller = Get.find<PrescriptionController>();
    controller.viewPrescriptionDetails(p);
  }
}

class _StatusMeta {
  final String header;
  final String subHeader;
  final IconData icon;
  final Color color;
  const _StatusMeta({
    required this.header,
    required this.subHeader,
    required this.icon,
    required this.color,
  });
}



*/ 
