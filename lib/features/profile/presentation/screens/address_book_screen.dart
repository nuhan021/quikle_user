import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/profile/controllers/address_controller.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';
import 'package:quikle_user/features/profile/presentation/widgets/address_card.dart';
import 'package:quikle_user/features/profile/presentation/screens/add_address_screen.dart';

class AddressBookScreen extends StatelessWidget {
  const AddressBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddressController>();

    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      body: Column(
        children: [
          const UnifiedProfileAppBar(
            title: 'Address Book',
            showActionButton: false,
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.beakYellow),
                );
              }

              if (controller.addresses.isEmpty) {
                return _buildEmptyState(context);
              }

              return _buildAddressList(context, controller);
            }),
          ),

          _buildAddNewAddressButton(context),
        ],
      ),
    );
  }

  // Empty state stays centered, no special bottom handling needed
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.location,
                size: 48.sp,
                color: AppColors.featherGrey,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'No Addresses Found',
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.ebonyBlack,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Add your first delivery address to\nget started with quick orders',
              textAlign: TextAlign.center,
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.featherGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List gets bottom padding so last card never hides behind the fixed button or navbar
  Widget _buildAddressList(BuildContext context, AddressController controller) {
    // Estimated button height
    final double buttonHeight = 56.h;
    // Space for gesture pill and your custom navbar
    final double gesture = MediaQuery.of(context).viewPadding.bottom;
    const double navHeight = kBottomNavigationBarHeight;

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        16.w,
        16.w,
        16.w,
        // bottom padding ensures scrollable content clears the fixed button and navbar
        16.h + buttonHeight + gesture + navHeight,
      ),
      itemCount: controller.addresses.length,
      itemBuilder: (context, index) {
        final address = controller.addresses[index];
        return AddressCard(
          address: address,
          onTap: () => _showAddressOptions(address, controller),
          onSetDefault: () => controller.setAsDefault(address.id),
          onEdit: () => _navigateToEditAddress(address),
          onDelete: () => _showDeleteConfirmation(address, controller),
        );
      },
    );
  }

  Widget _buildAddNewAddressButton(BuildContext context) {
    final double gesture = MediaQuery.of(context).viewPadding.bottom;
    //const double navHeight = kBottomNavigationBarHeight;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h + gesture),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _navigateToAddAddress(Get.context!),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.ebonyBlack,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            elevation: 0,
          ),
          icon: Icon(Icons.add, size: 24.sp),
          label: Text(
            'Add New Address',
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showAddressOptions(address, AddressController controller) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 8.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.featherGrey,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Address Options',
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.ebonyBlack,
              ),
            ),
            SizedBox(height: 24.h),
            if (!address.isDefault)
              _buildBottomSheetOption(
                icon: Iconsax.tick_circle,
                title: 'Set as Default',
                onTap: () {
                  Get.back();
                  controller.setAsDefault(address.id);
                },
              ),
            _buildBottomSheetOption(
              icon: Iconsax.edit_2,
              title: 'Edit Address',
              onTap: () {
                Get.back();
                _navigateToEditAddress(address);
              },
            ),
            _buildBottomSheetOption(
              icon: Iconsax.trash,
              title: 'Delete Address',
              color: AppColors.error,
              onTap: () {
                Get.back();
                _showDeleteConfirmation(address, controller);
              },
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color ?? AppColors.ebonyBlack, size: 24.sp),
      title: Text(
        title,
        style: getTextStyle(
          font: CustomFonts.inter,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: color ?? AppColors.ebonyBlack,
        ),
      ),
    );
  }

  void _navigateToAddAddress(BuildContext context) {
    AddAddressScreen.show(context);
  }

  void _navigateToEditAddress(address) {
    Get.snackbar(
      'Coming Soon',
      'Edit address functionality will be implemented next',
      backgroundColor: AppColors.beakYellow,
      colorText: AppColors.ebonyBlack,
    );
  }

  void _showDeleteConfirmation(address, AddressController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(
          'Delete Address',
          style: getTextStyle(
            font: CustomFonts.obviously,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.ebonyBlack,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this address? This action cannot be undone.',
          style: getTextStyle(
            font: CustomFonts.inter,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteAddress(address.id);
            },
            child: Text(
              'Delete',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
