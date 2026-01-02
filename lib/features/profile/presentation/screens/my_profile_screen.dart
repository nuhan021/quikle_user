import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/profile/controllers/profile_controller.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/profile/presentation/widgets/profile_card.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';

class MyProfileScreen extends StatefulWidget {
  MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late final ProfileController controller;

  // Local controllers owned by this screen to avoid attaching disposed
  // TextEditingControllers from the ProfileController into the widget tree.
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _postalCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Resolve the ProfileController if registered. If not, create one to
    // avoid runtime errors (typical flows should have the controller registered).
    try {
      controller = Get.find<ProfileController>();
    } catch (e) {
      AppLoggerHelper.debug('ProfileController not found via Get.find(): $e');
      controller = Get.put(ProfileController());
    }

    // Initialize local controllers from the profile controller safely.
    try {
      _nameController.text = controller.nameController.text;
      _emailController.text = controller.emailController.text;
      _phoneController.text = controller.phoneController.text;
      _address1Controller.text = controller.address1Controller.text;
      _address2Controller.text = controller.address2Controller.text;
      _postalCodeController.text = controller.postalCodeController.text;
    } catch (e) {
      AppLoggerHelper.debug('Failed to read text from ProfileController: $e');
    }
  }

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
              : (isEditing ? _onSavePressed : _onEditPressed),
          showBackButton: true,
          showActionButton: true,
        ),
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 14.h, bottom: 16.h),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    ProfileCard(
                      name: _nameController.text,
                      email: _emailController.text,
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

  void _onEditPressed() {
    try {
      if (!controller.isClosed) {
        controller.enableEditing();
      } else {
        Get.snackbar(
          'Error',
          'Profile is not available',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      AppLoggerHelper.debug('Error enabling edit: $e');
      Get.snackbar(
        'Error',
        'Unable to enable editing',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> _onSavePressed() async {
    try {
      if (controller.isClosed) {
        Get.snackbar(
          'Error',
          'Profile controller is not available',
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      // Copy local controller values back to the profile controller's
      // TextEditingControllers so saveProfile() works as expected.
      try {
        controller.nameController.text = _nameController.text;
        controller.emailController.text = _emailController.text;
        controller.phoneController.text = _phoneController.text;
        controller.address1Controller.text = _address1Controller.text;
        controller.address2Controller.text = _address2Controller.text;
        controller.postalCodeController.text = _postalCodeController.text;
      } catch (e) {
        AppLoggerHelper.debug('Failed to copy back to ProfileController: $e');
      }

      await controller.saveProfile();
    } catch (e) {
      AppLoggerHelper.debug('Error saving profile: $e');
      Get.snackbar(
        'Error',
        'Failed to save profile',
        snackPosition: SnackPosition.TOP,
      );
    }
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
            controller: _nameController,
            label: 'Full Name',
            enabled: isEditing,
          ),
          SizedBox(height: 20.h),
          _buildEditableField(
            controller: _emailController,
            label: 'Email Address',
            enabled: isEditing,
          ),
          SizedBox(height: 20.h),
          _buildEditableField(
            controller: _phoneController,
            label: 'Phone Number',
            enabled: isEditing,
          ),
          SizedBox(height: 20.h),
          _buildEditableField(
            controller: _address1Controller,
            label: 'Address Line 1',
            enabled: isEditing,
          ),
          SizedBox(height: 20.h),
          _buildEditableField(
            controller: _address2Controller,
            label: 'Address Line 2',
            enabled: isEditing,
          ),
          SizedBox(height: 20.h),
          _buildEditableField(
            controller: _postalCodeController,
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
              : (isEditing ? _onSavePressed : _onEditPressed),
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
