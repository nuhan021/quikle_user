import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/prescription/data/models/prescription_model.dart';

class VendorResponseStatusBadge extends StatelessWidget {
  final VendorResponseStatus status;
  final double? fontSize;
  final bool showIcon;

  const VendorResponseStatusBadge({
    super.key,
    required this.status,
    this.fontSize,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: _getStatusColor(status).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              _getStatusIcon(status),
              color: _getStatusColor(status),
              size: (fontSize ?? 12.sp) + 2,
            ),
            SizedBox(width: 6.w),
          ],
          Text(
            _getStatusText(status),
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: fontSize ?? 12.sp,
              fontWeight: FontWeight.w600,
              color: _getStatusColor(status),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(VendorResponseStatus status) {
    switch (status) {
      case VendorResponseStatus.pending:
        return Colors.orange;
      case VendorResponseStatus.approved:
        return Colors.green;
      case VendorResponseStatus.partiallyApproved:
        return Colors.amber;
      case VendorResponseStatus.rejected:
        return Colors.red;
      case VendorResponseStatus.expired:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(VendorResponseStatus status) {
    switch (status) {
      case VendorResponseStatus.pending:
        return Icons.schedule;
      case VendorResponseStatus.approved:
        return Icons.check_circle;
      case VendorResponseStatus.partiallyApproved:
        return Icons.check_circle_outline;
      case VendorResponseStatus.rejected:
        return Icons.cancel;
      case VendorResponseStatus.expired:
        return Icons.schedule;
    }
  }

  String _getStatusText(VendorResponseStatus status) {
    switch (status) {
      case VendorResponseStatus.pending:
        return 'Pending';
      case VendorResponseStatus.approved:
        return 'Approved';
      case VendorResponseStatus.partiallyApproved:
        return 'Partially Approved';
      case VendorResponseStatus.rejected:
        return 'Rejected';
      case VendorResponseStatus.expired:
        return 'Expired';
    }
  }
}
