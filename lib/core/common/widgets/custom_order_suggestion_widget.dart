import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';

class CustomOrderSuggestionWidget extends StatelessWidget {
  final String searchQuery;
  final VoidCallback onRequestCustomOrder;

  const CustomOrderSuggestionWidget({
    super.key,
    required this.searchQuery,
    required this.onRequestCustomOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 40.sp,
              color: AppColors.primary,
            ),
          ),

          SizedBox(height: 20.h),
          Text(
            'Can\'t find "$searchQuery"?',
            textAlign: TextAlign.center,
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.ebonyBlack,
            ),
          ),

          SizedBox(height: 12.h),
          Text(
            'No worries! We can help you get exactly what you\'re looking for through our custom order service.',
            textAlign: TextAlign.center,
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 14.sp,
              color: Colors.grey[600] ?? Colors.grey,
            ),
          ),
          SizedBox(height: 24.h),
          _buildFeatureItem(
            icon: Icons.message,
            text: 'Direct chat with our team',
          ),

          SizedBox(height: 12.h),

          _buildFeatureItem(
            icon: Icons.schedule,
            text: 'Quick response within minutes',
          ),

          SizedBox(height: 12.h),

          _buildFeatureItem(
            icon: Icons.local_shipping,
            text: 'Same delivery service',
          ),

          SizedBox(height: 32.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onRequestCustomOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat, size: 20.sp, color: Colors.white),
                  SizedBox(width: 8.w),
                  Text(
                    'Request via WhatsApp',
                    style: getTextStyle(
                      font: CustomFonts.obviously,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16.h),

          Text(
            'Our custom orders team will get back to you with availability and pricing',
            textAlign: TextAlign.center,
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 12.sp,
              color: Colors.grey[500] ?? Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.primary),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 14.sp,
              color: AppColors.ebonyBlack,
            ),
          ),
        ),
      ],
    );
  }
}
