import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      body: SafeArea(
        child: Column(
          children: [
            const UnifiedProfileAppBar(
              title: 'Terms & Conditions',
              showBackButton: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle('Terms and Conditions'),
                      SizedBox(height: 8.h),
                      _buildUpdateDate('Last Updated: December 17, 2025'),
                      SizedBox(height: 24.h),

                      _buildIntroduction(),
                      SizedBox(height: 24.h),

                      _buildSection('1. Acceptance of Terms', [
                        _buildParagraph(
                          'By accessing and using the Quikle mobile application, you accept and agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use our services.',
                        ),
                      ]),

                      _buildSection('2. Service Description', [
                        _buildParagraph(
                          'Quikle is a platform that connects users with restaurants, grocery stores, and pharmacies for food delivery, grocery ordering, and medicine delivery services. We facilitate orders but are not directly responsible for the preparation, quality, or delivery of products.',
                        ),
                      ]),

                      _buildSection('3. User Account', [
                        _buildSubSection(
                          '3.1 Registration',
                          'To use our services, you must:\n'
                              '• Provide accurate and complete information\n'
                              '• Be at least 13 years of age (or legal age in your jurisdiction)\n'
                              '• Maintain the security of your account credentials\n'
                              '• Notify us immediately of any unauthorized access',
                        ),
                        _buildSubSection(
                          '3.2 Account Responsibility',
                          'You are responsible for all activities that occur under your account. Quikle is not liable for any loss or damage arising from your failure to maintain account security.',
                        ),
                      ]),

                      _buildSection('4. Orders and Payments', [
                        _buildSubSection(
                          '4.1 Placing Orders',
                          'When placing an order:\n'
                              '• All prices are subject to change without notice\n'
                              '• Orders are subject to acceptance by the merchant\n'
                              '• We reserve the right to refuse or cancel any order\n'
                              '• Minimum order values may apply',
                        ),
                        _buildSubSection(
                          '4.2 Payment',
                          'Payment terms:\n'
                              '• Payment must be made at the time of order placement\n'
                              '• We accept various payment methods as displayed in the app\n'
                              '• All payments are processed securely through our payment partners\n'
                              '• Delivery charges and taxes are additional to product prices',
                        ),
                        _buildSubSection(
                          '4.3 Pricing Errors',
                          'We strive for accuracy in pricing. If a product is listed at an incorrect price due to an error, we reserve the right to cancel the order and provide a full refund.',
                        ),
                      ]),

                      _buildSection('5. Delivery', [
                        _buildBulletPoint(
                          'Delivery times are estimates and not guaranteed',
                        ),
                        _buildBulletPoint(
                          'You must provide accurate delivery address and contact information',
                        ),
                        _buildBulletPoint(
                          'Someone must be available to receive the order',
                        ),
                        _buildBulletPoint(
                          'Delivery charges vary based on location and order value',
                        ),
                        _buildBulletPoint(
                          'We are not responsible for delays caused by weather, traffic, or circumstances beyond our control',
                        ),
                      ]),

                      _buildSection('6. Cancellation and Refunds', [
                        _buildSubSection(
                          '6.1 Cancellation',
                          'Order cancellation:\n'
                              '• You may cancel orders within a limited time after placement\n'
                              '• Once preparation begins, cancellation may not be possible\n'
                              '• Cancellation fees may apply based on order status',
                        ),
                        _buildSubSection(
                          '6.2 Refunds',
                          'Refund policy:\n'
                              '• Refunds are processed based on the reason for cancellation\n'
                              '• Refunds may take 5-7 business days to reflect in your account\n'
                              '• Partial refunds may be issued for partial order issues\n'
                              '• Refund method will be the same as the payment method used',
                        ),
                      ]),

                      _buildSection('7. Prescription Medicines', [
                        _buildParagraph(
                          'For prescription medicine orders:\n'
                          '• Valid prescription is mandatory\n'
                          '• Prescription must be uploaded at the time of ordering\n'
                          '• Pharmacies reserve the right to verify prescriptions\n'
                          '• Orders may be cancelled if prescription is invalid or unclear\n'
                          '• We comply with all applicable pharmaceutical regulations',
                        ),
                      ]),

                      _buildSection('8. User Conduct', [
                        _buildParagraph('You agree not to:'),
                        _buildBulletPoint(
                          'Use the service for any illegal purpose',
                        ),
                        _buildBulletPoint(
                          'Provide false or misleading information',
                        ),
                        _buildBulletPoint(
                          'Interfere with the proper functioning of the service',
                        ),
                        _buildBulletPoint(
                          'Attempt to gain unauthorized access to our systems',
                        ),
                        _buildBulletPoint(
                          'Harass or abuse our staff, delivery partners, or merchants',
                        ),
                        _buildBulletPoint(
                          'Place fraudulent orders or payments',
                        ),
                        _buildBulletPoint(
                          'Use the service for commercial purposes without permission',
                        ),
                      ]),

                      _buildSection('9. Intellectual Property', [
                        _buildParagraph(
                          'All content on the Quikle app, including logos, text, graphics, icons, images, and software, is the property of Quikle or its licensors and is protected by copyright and trademark laws. You may not reproduce, distribute, or create derivative works without written permission.',
                        ),
                      ]),

                      _buildSection('10. Disclaimers', [
                        _buildSubSection(
                          '10.1 Service Availability',
                          'We do not guarantee uninterrupted or error-free service. The app may be unavailable due to maintenance, updates, or technical issues.',
                        ),
                        _buildSubSection(
                          '10.2 Product Quality',
                          'Quikle acts as an intermediary platform. We are not responsible for:\n'
                              '• Quality, safety, or legality of products\n'
                              '• Accuracy of product descriptions\n'
                              '• Food preparation or handling by merchants\n'
                              '• Allergic reactions or health issues from consumed products',
                        ),
                        _buildSubSection(
                          '10.3 Third-Party Services',
                          'We use third-party services (payment gateways, maps, etc.). We are not responsible for failures or issues with these services.',
                        ),
                      ]),

                      _buildSection('11. Limitation of Liability', [
                        _buildParagraph(
                          'To the maximum extent permitted by law, Quikle shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, or other intangible losses resulting from:',
                        ),
                        _buildBulletPoint(
                          'Your use or inability to use the service',
                        ),
                        _buildBulletPoint(
                          'Any unauthorized access to your account',
                        ),
                        _buildBulletPoint(
                          'Any interruption or cessation of the service',
                        ),
                        _buildBulletPoint('Any bugs, viruses, or harmful code'),
                        _buildBulletPoint('Any errors or omissions in content'),
                        _buildBulletPoint('Product quality or delivery issues'),
                      ]),

                      _buildSection('12. Indemnification', [
                        _buildParagraph(
                          'You agree to indemnify and hold harmless Quikle, its affiliates, officers, employees, and partners from any claims, damages, losses, liabilities, and expenses (including legal fees) arising from:',
                        ),
                        _buildBulletPoint(
                          'Your violation of these Terms and Conditions',
                        ),
                        _buildBulletPoint(
                          'Your violation of any rights of another party',
                        ),
                        _buildBulletPoint('Your use of the service'),
                      ]),

                      _buildSection('13. Location Services', [
                        _buildParagraph(
                          'By using location-based features, you consent to the collection and use of your location data as described in our Privacy Policy. You can disable location services at any time through your device settings, though this may limit functionality.',
                        ),
                      ]),

                      _buildSection('14. Promotional Offers', [
                        _buildParagraph(
                          'Promotional offers, discounts, and coupons:\n'
                          '• Are subject to specific terms and conditions\n'
                          '• May have expiration dates and usage limits\n'
                          '• Cannot be combined unless explicitly stated\n'
                          '• May be modified or withdrawn at any time\n'
                          '• Are non-transferable',
                        ),
                      ]),

                      _buildSection('15. Termination', [
                        _buildParagraph(
                          'We reserve the right to suspend or terminate your access to the service at any time, with or without notice, for:\n'
                          '• Violation of these Terms and Conditions\n'
                          '• Fraudulent activity\n'
                          '• Abusive behavior\n'
                          '• Any other reason at our sole discretion',
                        ),
                      ]),

                      _buildSection('16. Modifications to Terms', [
                        _buildParagraph(
                          'We reserve the right to modify these Terms and Conditions at any time. We will notify users of significant changes. Continued use of the service after changes constitutes acceptance of the modified terms.',
                        ),
                      ]),

                      _buildSection('17. Governing Law', [
                        _buildParagraph(
                          'These Terms and Conditions shall be governed by and construed in accordance with the laws of [Your Country/State], without regard to its conflict of law provisions. Any disputes shall be subject to the exclusive jurisdiction of the courts in [Your Jurisdiction].',
                        ),
                      ]),

                      _buildSection('18. Dispute Resolution', [
                        _buildParagraph(
                          'For any disputes arising from these terms or use of the service:\n'
                          '• First contact our customer support to resolve the issue\n'
                          '• If unresolved, disputes may be subject to mediation or arbitration\n'
                          '• You agree to resolve disputes on an individual basis and not as part of a class action',
                        ),
                      ]),

                      _buildSection('19. Severability', [
                        _buildParagraph(
                          'If any provision of these Terms and Conditions is found to be invalid or unenforceable, the remaining provisions shall continue in full force and effect.',
                        ),
                      ]),

                      _buildSection('20. Contact Information', [
                        _buildParagraph(
                          'For questions about these Terms and Conditions, please contact us:',
                        ),
                        SizedBox(height: 8.h),
                        _buildContactInfo('Email', 'support@quikle.com'),
                        _buildContactInfo('In-App', 'Help & Support section'),
                        _buildContactInfo(
                          'Address',
                          'Quikle Customer Support\n[Your Company Address]',
                        ),
                      ]),

                      SizedBox(height: 32.h),

                      _buildAgreement(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: getTextStyle(
        font: CustomFonts.obviously,
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildUpdateDate(String text) {
    return Text(
      text,
      style: getTextStyle(
        font: CustomFonts.inter,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildIntroduction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildParagraph(
          'Welcome to Quikle. These Terms and Conditions govern your use of our mobile application and services. Please read them carefully before using our platform.',
        ),
        SizedBox(height: 12.h),
        _buildParagraph(
          'By creating an account or using our services, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions.',
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getTextStyle(
            font: CustomFonts.obviously,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        ...children,
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildSubSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getTextStyle(
            font: CustomFonts.obviously,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        _buildParagraph(content),
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: getTextStyle(
        font: CustomFonts.inter,
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, left: 8.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            TextSpan(
              text: value,
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgreement() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.homeGrey,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acknowledgment',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'By using Quikle, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions.',
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
