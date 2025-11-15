import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/profile/controllers/profile_controller.dart';
import 'package:quikle_user/features/profile/presentation/widgets/profile_card.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';

class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({super.key});
  final ProfileController controller = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isEditing = controller.isEditing.value;
      final isSaving = controller.isSaving.value;
      return Scaffold(
        backgroundColor: AppColors.homeGrey,
        appBar: UnifiedProfileAppBar(
          title: isEditing ? 'Edit Profile' : 'My Profile',
          actionText: isSaving ? 'Saving...' : (isEditing ? 'Save' : 'Edit'),
          onActionPressed: isSaving
              ? null
              : (isEditing ? controller.saveProfile : controller.enableEditing),
          showBackButton: true,
          showActionButton: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 14.h, bottom: 16.h),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    ProfileCard(
                      name: controller.nameController.text,
                      email: controller.emailController.text,
                    ),
                    SizedBox(height: 24.h),
                    _buildProfileSection(isEditing, isSaving),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProfileSection(bool isEditing, bool isSaving) {
    return Container(
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
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isEditing, isSaving),
          SizedBox(height: 24.h),
          _buildEditableField(
            controller: controller.nameController,
            label: 'Full Name',
            enabled: isEditing,
          ),
          SizedBox(height: 20.h),
          _buildEditableField(
            controller: controller.emailController,
            label: 'Email Address',
            enabled: isEditing,
          ),
          SizedBox(height: 20.h),
          _buildEditableField(
            controller: controller.phoneController,
            label: 'Phone Number',
            enabled: isEditing,
          ),
          SizedBox(height: 20.h),
          _buildEditableField(
            controller: controller.address1Controller,
            label: 'Address Line 1',
            enabled: isEditing,
          ),
          SizedBox(height: 20.h),
          _buildEditableField(
            controller: controller.address2Controller,
            label: 'Address Line 2',
            enabled: isEditing,
          ),
          SizedBox(height: 20.h),
          _buildEditableField(
            controller: controller.postalCodeController,
            label: 'Postal Code',
            enabled: isEditing,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isEditing, bool isSaving) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isEditing ? 'Edit Profile' : 'My Profile',
          style: getTextStyle(
            font: CustomFonts.obviously,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: isSaving
              ? null
              : (isEditing ? controller.saveProfile : controller.enableEditing),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSaving ? AppColors.textSecondary : AppColors.textPrimary,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              isSaving ? 'Saving...' : (isEditing ? 'Save' : 'Edit'),
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String label,
    required bool enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getTextStyle(
            font: CustomFonts.inter,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.cardColor, width: 1.w),
            ),
          ),
          child: TextFormField(
            controller: controller,
            enabled: enabled,
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: enabled ? Colors.white : AppColors.homeGrey,
            ),
          ),
        ),
      ],
    );
  }
}
