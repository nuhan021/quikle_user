import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/orders/data/models/refund/refund_info_model.dart';

/// Widget displaying refund status information with timeline
class RefundStatusCard extends StatelessWidget {
  final RefundInfo refundInfo;
  final String? fallbackRefundReference;

  const RefundStatusCard({
    super.key,
    required this.refundInfo,
    this.fallbackRefundReference,
  });

  @override
  Widget build(BuildContext context) {
    final refundReference =
        refundInfo.refundReference ?? fallbackRefundReference;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Refund Information',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.ebonyBlack,
            ),
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(
            'Refund Amount',
            '₹${refundInfo.refundAmount.toStringAsFixed(2)}',
          ),
          SizedBox(height: 12.h),
          _buildInfoRow(
            'Refund Status',
            _formatStatus(refundInfo.statusString),
          ),
          SizedBox(height: 12.h),
          _buildInfoRow(
            'Refund Destination',
            refundInfo.destination.displayName,
          ),
          if (refundReference != null) ...[
            SizedBox(height: 12.h),
            _buildInfoRow(
              'Refund Reference (RRN)',
              refundReference,
              copyable: true,
            ),
          ],
          SizedBox(height: 20.h),
          _buildRefundTimeline(),
          SizedBox(height: 16.h),
          _buildExpectedCompletion(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool copyable = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getTextStyle(
            font: CustomFonts.inter,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF7C7C7C),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ebonyBlack,
                  ),
                ),
              ),
              if (copyable) ...[
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    Get.snackbar(
                      'Copied',
                      '$label copied to clipboard',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  child: Icon(
                    Icons.copy,
                    size: 16.sp,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRefundTimeline() {
    final statusStr = refundInfo.statusString.toLowerCase();
    final isCompleted =
        statusStr == 'completed' || refundInfo.completedAt != null;
    final isProcessing = statusStr == 'processing' || statusStr == 'pending';

    final steps = [
      {
        'title': 'Refund initiated',
        'completed': true,
        'time': refundInfo.initiatedAt,
      },
      {
        'title': 'Refund processing',
        'completed': isProcessing || isCompleted,
        'time': refundInfo.processedAt,
      },
      {
        'title': 'Refund completed',
        'completed': isCompleted,
        'time': refundInfo.completedAt,
        'expected': refundInfo.expectedCompletionDate,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Refund Timeline',
          style: getTextStyle(
            font: CustomFonts.inter,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.ebonyBlack,
          ),
        ),
        SizedBox(height: 12.h),
        ...steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isLast = index == steps.length - 1;
          final completed = step['completed'] as bool;
          final time = step['time'] as DateTime?;
          final expected = step['expected'] as DateTime?;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: completed
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: completed
                        ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                        : null,
                  ),
                  if (!isLast)
                    Container(
                      width: 2.w,
                      height: 40.h,
                      color: completed
                          ? AppColors.primary
                          : Colors.grey.shade300,
                    ),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title'] as String,
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: completed
                            ? AppColors.ebonyBlack
                            : Colors.grey.shade600,
                      ),
                    ),
                    if (time != null)
                      Text(
                        DateFormat('dd MMM yyyy, hh:mm a').format(time),
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600,
                        ),
                      )
                    else if (!completed && expected != null)
                      Text(
                        'Expected: ${DateFormat('dd MMM yyyy').format(expected)}',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    SizedBox(height: isLast ? 0 : 12.h),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildExpectedCompletion() {
    final message = refundInfo.getExpectedTimelineMessage();

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18.sp, color: AppColors.primary),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.ebonyBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatStatus(String status) {
    if (status.isEmpty) return status;
    return status[0].toUpperCase() + status.substring(1);
  }
}
