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

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PrescriptionController>();

    return Obx(() {
      final latest = _latestActive(controller.prescriptions);
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
                      width: 36.w,
                      height: 36.w,
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

                    // Single concise message
                    Expanded(
                      child: Text(
                        isRefreshing ? 'Updating status...' : meta.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700, // bolder
                          color: AppColors.ebonyBlack,
                        ),
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

  /// Pick the most recent, non-expired prescription.
  PrescriptionModel? _latestActive(List<PrescriptionModel> list) {
    if (list.isEmpty) return null;
    final filtered =
        list.where((p) => p.status != PrescriptionStatus.expired).toList()
          ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    return filtered.isEmpty ? null : filtered.first;
  }

  _StatusMeta _metaFor(PrescriptionStatus status) {
    switch (status) {
      case PrescriptionStatus.uploaded:
        return _StatusMeta(
          message: 'Prescription uploaded - In review',
          icon: Icons.cloud_upload,
          color: Colors.blue,
        );
      case PrescriptionStatus.processing:
        return _StatusMeta(
          message: 'Your request is processing — verifying medicines',
          icon: Icons.hourglass_empty,
          color: Colors.orange,
        );
      case PrescriptionStatus.responded:
        return _StatusMeta(
          message: 'Request approved - Awaiting actions',
          icon: Icons.check_circle,
          color: Colors.green,
        );
      case PrescriptionStatus.rejected:
        return _StatusMeta(
          message: 'Request rejected — See details',
          icon: Icons.cancel,
          color: Colors.red,
        );
      case PrescriptionStatus.expired:
        // Not shown (filtered out)
        return _StatusMeta(
          message: 'Expired',
          icon: Icons.access_time,
          color: Colors.grey,
        );
    }
  }

  void _openDetails(PrescriptionModel p) {
    final controller = Get.find<PrescriptionController>();
    controller.viewPrescriptionDetails(p);
  }
}

class _StatusMeta {
  final String message;
  final IconData icon;
  final Color color;
  const _StatusMeta({
    required this.message,
    required this.icon,
    required this.color,
  });
}
