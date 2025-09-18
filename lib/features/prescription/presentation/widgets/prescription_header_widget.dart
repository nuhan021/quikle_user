
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/prescription/data/models/prescription_model.dart';

class PrescriptionHeaderWidget extends StatelessWidget {
  final PrescriptionModel prescription;
  final VoidCallback onDelete;
  final VoidCallback onViewDetails;

  const PrescriptionHeaderWidget({
    super.key,
    required this.prescription,
    required this.onDelete,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: _getStatusColor(prescription.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              _getStatusIcon(prescription.status),
              color: _getStatusColor(prescription.status),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prescription.fileName.split('.').first,
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  _formatDate(prescription.uploadedAt),
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getStatusColor(prescription.status).withOpacity(0.8),
                      _getStatusColor(prescription.status),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: _getStatusColor(
                        prescription.status,
                      ).withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(prescription.status),
                      color: Colors.white,
                      size: 12.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      prescription.status.displayName,
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6.w),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: Colors.grey.shade600,
                    size: 18.sp,
                  ),
                  onSelected: (String value) {
                    if (value == 'view') {
                      onViewDetails();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          Icon(
                            Icons.visibility_rounded,
                            size: 16,
                            color: Colors.blue.shade600,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'View Details',
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_rounded,
                            size: 16,
                            color: Colors.red.shade600,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.red.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
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
