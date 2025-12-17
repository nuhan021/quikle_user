import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      body: SafeArea(
        child: Column(
          children: [
            const UnifiedProfileAppBar(
              title: 'Privacy Policy',
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
                      _buildTitle('Privacy Policy'),
                      SizedBox(height: 8.h),
                      _buildUpdateDate('Last Updated: December 17, 2025'),
                      SizedBox(height: 24.h),

                      _buildIntroduction(),
                      SizedBox(height: 24.h),

                      _buildSection('1. Information We Collect', [
                        _buildSubSection(
                          '1.1 Personal Information',
                          'When you use Quikle, we collect the following personal information:\n'
                              '• Name and contact details (phone number, email address)\n'
                              '• Delivery addresses\n'
                              '• Payment information (processed securely through our payment partners)\n'
                              '• Profile information and preferences',
                        ),
                        _buildSubSection(
                          '1.2 Location Information',
                          'We collect and process your location data to:\n'
                              '• Show nearby restaurants and stores\n'
                              '• Enable delivery to your address\n'
                              '• Provide accurate delivery tracking\n'
                              '• Calculate delivery fees and estimated times\n\n'
                              'Location data is collected only when you use the app and grant location permissions.',
                        ),
                        _buildSubSection(
                          '1.3 Device Information',
                          'We automatically collect certain device information including:\n'
                              '• Device type and model\n'
                              '• Operating system version\n'
                              '• Unique device identifiers\n'
                              '• IP address\n'
                              '• Mobile network information',
                        ),
                        _buildSubSection(
                          '1.4 Usage Information',
                          'We collect information about how you use our app:\n'
                              '• Orders placed and order history\n'
                              '• Products viewed and searched\n'
                              '• App features accessed\n'
                              '• Interaction with notifications\n'
                              '• Time spent on different screens',
                        ),
                        _buildSubSection(
                          '1.5 Camera and Media',
                          'With your permission, we access:\n'
                              '• Camera for uploading prescription images\n'
                              '• Photo library for selecting product images\n'
                              '• Media files for uploading documents',
                        ),
                      ]),

                      _buildSection('2. How We Use Your Information', [
                        _buildBulletPoint('Process and fulfill your orders'),
                        _buildBulletPoint(
                          'Communicate order status and updates',
                        ),
                        _buildBulletPoint('Process payments securely'),
                        _buildBulletPoint('Provide customer support'),
                        _buildBulletPoint(
                          'Send promotional offers and notifications (with your consent)',
                        ),
                        _buildBulletPoint(
                          'Improve our services and user experience',
                        ),
                        _buildBulletPoint('Prevent fraud and ensure security'),
                        _buildBulletPoint('Comply with legal obligations'),
                        _buildBulletPoint('Analyze app usage and performance'),
                      ]),

                      _buildSection('3. Third-Party Services', [
                        _buildSubSection(
                          '3.1 Firebase (Google)',
                          'We use Firebase services for:\n'
                              '• Push notifications (Firebase Cloud Messaging)\n'
                              '• Analytics and crash reporting\n'
                              '• Authentication services\n\n'
                              'Firebase Privacy Policy: https://firebase.google.com/support/privacy',
                        ),
                        _buildSubSection(
                          '3.2 Google Maps',
                          'We use Google Maps Platform to:\n'
                              '• Display restaurant and store locations\n'
                              '• Enable address search and geocoding\n'
                              '• Track delivery in real-time\n\n'
                              'Google Maps Privacy Policy: https://policies.google.com/privacy',
                        ),
                        _buildSubSection(
                          '3.3 Payment Processing (Cashfree)',
                          'Payments are processed securely through Cashfree Payments. We do not store complete payment card information. Cashfree handles payment data in compliance with PCI-DSS standards.\n\n'
                              'Cashfree Privacy Policy: https://www.cashfree.com/privacy-policy',
                        ),
                        _buildSubSection(
                          '3.4 Customer Support (Freshchat)',
                          'We use Freshchat by Freshworks for customer support chat. Conversations may be stored to improve service quality.\n\n'
                              'Freshworks Privacy Policy: https://www.freshworks.com/privacy/',
                        ),
                      ]),

                      _buildSection('4. Data Sharing and Disclosure', [
                        _buildParagraph('We may share your information with:'),
                        _buildBulletPoint(
                          'Restaurant and store partners to fulfill orders',
                        ),
                        _buildBulletPoint(
                          'Delivery partners for order delivery',
                        ),
                        _buildBulletPoint(
                          'Payment processors for transaction processing',
                        ),
                        _buildBulletPoint(
                          'Service providers who assist our operations',
                        ),
                        _buildBulletPoint(
                          'Law enforcement when required by law',
                        ),
                        SizedBox(height: 8.h),
                        _buildParagraph(
                          'We never sell your personal information to third parties.',
                        ),
                      ]),

                      _buildSection('5. Data Storage and Security', [
                        _buildParagraph(
                          'We implement industry-standard security measures to protect your data:',
                        ),
                        _buildBulletPoint(
                          'Encrypted data transmission (HTTPS/SSL)',
                        ),
                        _buildBulletPoint(
                          'Secure data storage with access controls',
                        ),
                        _buildBulletPoint('Regular security assessments'),
                        _buildBulletPoint(
                          'Limited employee access to personal data',
                        ),
                        SizedBox(height: 8.h),
                        _buildParagraph(
                          'Data is stored on secure servers and retained only as long as necessary for providing services or as required by law.',
                        ),
                      ]),

                      _buildSection('6. Permissions', [
                        _buildParagraph(
                          'The app requests the following permissions:',
                        ),
                        _buildBulletPoint(
                          'Location: For delivery address and nearby stores',
                        ),
                        _buildBulletPoint('Camera: For prescription uploads'),
                        _buildBulletPoint(
                          'Storage: For saving images and documents',
                        ),
                        _buildBulletPoint('Phone: For customer support calls'),
                        _buildBulletPoint('Notifications: For order updates'),
                        _buildBulletPoint(
                          'Microphone: For voice search (optional)',
                        ),
                        SizedBox(height: 8.h),
                        _buildParagraph(
                          'You can manage permissions in your device settings at any time.',
                        ),
                      ]),

                      _buildSection('7. Cookies and Tracking', [
                        _buildParagraph(
                          'We use cookies and similar technologies to:\n'
                          '• Remember your preferences\n'
                          '• Analyze app usage\n'
                          '• Improve app performance\n'
                          '• Provide personalized content',
                        ),
                      ]),

                      _buildSection('8. Your Rights and Choices', [
                        _buildParagraph('You have the right to:'),
                        _buildBulletPoint('Access your personal data'),
                        _buildBulletPoint('Correct inaccurate information'),
                        _buildBulletPoint('Request deletion of your data'),
                        _buildBulletPoint(
                          'Opt-out of promotional communications',
                        ),
                        _buildBulletPoint('Disable location services'),
                        _buildBulletPoint(
                          'Withdraw consent for data processing',
                        ),
                        SizedBox(height: 8.h),
                        _buildParagraph(
                          'To exercise these rights, please contact us through the app\'s Help & Support section.',
                        ),
                      ]),

                      _buildSection('9. Children\'s Privacy', [
                        _buildParagraph(
                          'Our services are not intended for users under the age of 13 (or 16 in some jurisdictions). We do not knowingly collect personal information from children. If you believe we have collected information from a child, please contact us immediately.',
                        ),
                      ]),

                      _buildSection('10. International Data Transfers', [
                        _buildParagraph(
                          'Your information may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place to protect your data in accordance with this privacy policy.',
                        ),
                      ]),

                      _buildSection('11. Changes to Privacy Policy', [
                        _buildParagraph(
                          'We may update this Privacy Policy periodically. We will notify you of significant changes through the app or via email. Continued use of the app after changes constitutes acceptance of the updated policy.',
                        ),
                      ]),

                      _buildSection('12. Contact Us', [
                        _buildParagraph(
                          'If you have questions or concerns about this Privacy Policy or our data practices, please contact us:',
                        ),
                        SizedBox(height: 8.h),
                        _buildContactInfo('Email', 'support@quikle.com'),
                        _buildContactInfo('In-App', 'Help & Support section'),
                        _buildContactInfo(
                          'Address',
                          'Quikle Customer Support\n[Your Company Address]',
                        ),
                      ]),

                      SizedBox(height: 24.h),

                      _buildSection('13. Legal Compliance', [
                        _buildParagraph(
                          'We comply with applicable data protection laws including:\n'
                          '• General Data Protection Regulation (GDPR)\n'
                          '• California Consumer Privacy Act (CCPA)\n'
                          '• Information Technology Act, 2000 (India)\n'
                          '• Other applicable local privacy laws',
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
          'Welcome to Quikle! This Privacy Policy explains how we collect, use, disclose, and protect your information when you use our mobile application for food delivery, grocery ordering, and pharmacy services.',
        ),
        SizedBox(height: 12.h),
        _buildParagraph(
          'By using Quikle, you agree to the collection and use of information in accordance with this policy. If you do not agree with our policies and practices, please do not use our app.',
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
            'By using Quikle, you acknowledge that you have read and understood this Privacy Policy and agree to its terms.',
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
