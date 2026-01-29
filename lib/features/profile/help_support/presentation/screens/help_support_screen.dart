import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/common/widgets/customer_support_fab.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/profile/help_support/controllers/help_support_controller.dart';
import 'package:quikle_user/features/profile/user_profile/presentation/widgets/unified_profile_app_bar.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HelpSupportController controller = Get.find<HelpSupportController>();

    return Scaffold(
      backgroundColor: AppColors.homeGrey,

      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const UnifiedProfileAppBar(
                  title: 'Help & Support',
                  showActionButton: false,
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(children: [_buildFaqSection(controller)]),
                  ),
                ),
              ],
            ),
            // Customer Support FAB
            const CustomerSupportFAB(),
          ],
        ),
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
}
