import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/profile/presentation/widgets/profile_card.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Aanya Desai');
  final _emailController = TextEditingController(text: 'anyadesai@gmail.com');
  final _phoneController = TextEditingController(text: '+91 9876543210');
  final _address1Controller = TextEditingController(
    text: '123 Main Street, Apartment 4B',
  );
  final _address2Controller = TextEditingController(
    text: 'Near Central Park, Mumbai, Maharashtra 400001',
  );
  final _postalCodeController = TextEditingController(text: '10001');

  bool _isEditing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      appBar: UnifiedProfileAppBar(
        title: _isEditing ? 'Edit Profile' : 'My Profile',
        actionText: _isEditing ? 'Save' : 'Edit',
        onActionPressed: _isEditing ? _saveProfile : _enableEditing,
        showBackButton: true,
        showActionButton: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 14.h),
                    const ProfileCard(
                      name: 'Aanya Desai',
                      email: 'anyadesai@gmail.com',
                    ),
                    SizedBox(height: 24.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x0A616161),
                            blurRadius: 8.r,
                            offset: Offset(0, 2.h),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _isEditing ? 'Edit Profile' : 'My Profile',
                                style: getTextStyle(
                                  font: CustomFonts.obviously,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              GestureDetector(
                                onTap: _isEditing
                                    ? _saveProfile
                                    : _enableEditing,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.textPrimary,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    _isEditing ? 'Save' : 'Edit',
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
                          ),
                          SizedBox(height: 24.h),
                          _buildEditableField(
                            controller: _nameController,
                            label: 'Full Name',
                            enabled: _isEditing,
                          ),
                          SizedBox(height: 20.h),
                          _buildEditableField(
                            controller: _emailController,
                            label: 'Email Address',
                            enabled: _isEditing,
                          ),
                          SizedBox(height: 20.h),
                          _buildEditableField(
                            controller: _phoneController,
                            label: 'Phone Number',
                            enabled: _isEditing,
                          ),
                          SizedBox(height: 20.h),
                          _buildEditableField(
                            controller: _address1Controller,
                            label: 'Address Line 1',
                            enabled: _isEditing,
                          ),
                          SizedBox(height: 20.h),
                          _buildEditableField(
                            controller: _address2Controller,
                            label: 'Address Line 2',
                            enabled: _isEditing,
                          ),
                          SizedBox(height: 20.h),
                          _buildEditableField(
                            controller: _postalCodeController,
                            label: 'Postal Code',
                            enabled: _isEditing,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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

  void _enableEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isEditing = false;
      });
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
