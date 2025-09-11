import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/profile/controllers/help_support_controller.dart';
import 'package:quikle_user/features/profile/data/models/support_ticket_model.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HelpSupportController controller = Get.find<HelpSupportController>();

    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      body: Column(
        children: [
          const UnifiedProfileAppBar(
            title: 'Help & Support',
            showActionButton: false,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  _buildReportIssueSection(controller),

                  SizedBox(height: 24.h),

                  _buildFaqSection(controller),

                  SizedBox(height: 24.h),
                  _buildRecentSupportHistorySection(controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportIssueSection(HelpSupportController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A616161),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Report an Issue',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.ebonyBlack,
            ),
          ),

          SizedBox(height: 12.h),
          Container(height: 1.h, color: const Color(0xFFEEEEEE)),

          SizedBox(height: 16.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Subject',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ebonyBlack,
                ),
              ),

              SizedBox(height: 8.h),

              Obx(
                () => Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: const Color(0xFFB8B8B8).withValues(alpha: .5),
                      width: 0.5,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<SupportIssueType>(
                      dropdownColor: Colors.white,
                      isExpanded: true,
                      value: controller.selectedIssueType.value,
                      hint: Text(
                        'Select an issue type',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.featherGrey,
                        ),
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.featherGrey,
                        size: 18,
                      ),
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.ebonyBlack,
                      ),
                      items: controller.issueTypeOptions,
                      onChanged: (value) {
                        if (value != null) {
                          controller.selectIssueType(value);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ebonyBlack,
                ),
              ),

              SizedBox(height: 8.h),

              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: const Color(0xFFB8B8B8).withValues(alpha: .5),
                    width: 0.5,
                  ),
                ),
                child: TextField(
                  controller: controller.descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Please describe your issue in detail...',
                    hintStyle: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.featherGrey,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.ebonyBlack,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Attachment Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Attachment (Optional)',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ebonyBlack,
                ),
              ),

              SizedBox(height: 8.h),

              Obx(
                () => GestureDetector(
                  onTap: controller.attachmentPath.isEmpty
                      ? controller.showImagePickerOptions
                      : null,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 24.h,
                      horizontal: 16.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: const Color(0xFFB8B8B8).withValues(alpha: .5),
                        width: 0.5,
                      ),
                    ),
                    child: controller.attachmentPath.isEmpty
                        ? Column(
                            children: [
                              const Icon(
                                Iconsax.cloud_add,
                                size: 24,
                                color: AppColors.featherGrey,
                              ),

                              SizedBox(height: 8.h),

                              Text(
                                'Upload a screenshot or photo',
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.featherGrey,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              const Icon(
                                Iconsax.gallery,
                                size: 20,
                                color: AppColors.beakYellow,
                              ),

                              SizedBox(width: 8.w),

                              Expanded(
                                child: Text(
                                  controller.attachmentFile.value?.name ??
                                      'Image uploaded',
                                  style: getTextStyle(
                                    font: CustomFonts.inter,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.ebonyBlack,
                                  ),
                                ),
                              ),

                              GestureDetector(
                                onTap: controller.removeAttachment,
                                child: const Icon(
                                  Icons.close,
                                  size: 20,
                                  color: AppColors.featherGrey,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Submit Button
          Obx(
            () => GestureDetector(
              onTap: controller.isSubmitting.value
                  ? null
                  : controller.submitSupportTicket,
              child: Container(
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  color: controller.isSubmitting.value
                      ? AppColors.featherGrey
                      : const Color(0xFF211F1F),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: controller.isSubmitting.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : Text(
                          'Submit Issue',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqSection(HelpSupportController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A616161),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.ebonyBlack,
            ),
          ),

          SizedBox(height: 12.h),
          Container(height: 1.h, color: const Color(0xFFEEEEEE)),
          SizedBox(height: 12.h),

          // FAQ Items
          Obx(
            () => Column(
              children: controller.faqs.asMap().entries.map((entry) {
                final index = entry.key;
                final faq = entry.value;

                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: const Color(0xFFB8B8B8).withValues(alpha: .5),
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x0A000000),
                        blurRadius: 16.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => controller.toggleFaqExpansion(index),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                faq.question,
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.ebonyBlack,
                                ),
                              ),
                            ),

                            Icon(
                              faq.isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 18,
                              color: AppColors.featherGrey,
                            ),
                          ],
                        ),
                      ),

                      if (faq.isExpanded) ...[
                        SizedBox(height: 8.h),

                        Text(
                          faq.answer,
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.featherGrey,
                          ),
                        ),
                      ] else ...[
                        SizedBox(height: 8.h),

                        Text(
                          '${faq.answer.length > 50 ? '${faq.answer.substring(0, 47)}...' : faq.answer}',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.featherGrey,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSupportHistorySection(HelpSupportController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Recent Support History',
          style: getTextStyle(
            font: CustomFonts.obviously,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.ebonyBlack,
          ),
        ),

        SizedBox(height: 8.h),

        Obx(
          () => Column(
            children: controller.recentTickets.map((ticket) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x0A616161),
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ticket.title,
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.ebonyBlack,
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(ticket.status),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            ticket.status.label,
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      ticket.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.featherGrey,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Row(
                      children: [
                        Text(
                          'Submitted on ${_formatDate(ticket.submittedAt)}',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.featherGrey,
                          ),
                        ),

                        if (ticket.attachmentPath != null) ...[
                          SizedBox(width: 8.w),
                          const Icon(
                            Iconsax.gallery,
                            size: 14,
                            color: AppColors.beakYellow,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Color _getStatusColor(SupportTicketStatus status) {
    switch (status) {
      case SupportTicketStatus.pending:
        return Colors.orange;
      case SupportTicketStatus.inProgress:
        return Colors.blue;
      case SupportTicketStatus.resolved:
        return Colors.green;
      case SupportTicketStatus.closed:
        return Colors.grey;
    }
  }
}
