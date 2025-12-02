import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/profile/controllers/address_controller.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';
import 'package:quikle_user/features/profile/presentation/widgets/address_card.dart';
import 'package:quikle_user/features/profile/presentation/screens/add_address_screen.dart';

class AddressBookScreen extends StatelessWidget {
  final bool selectionMode;

  const AddressBookScreen({super.key, this.selectionMode = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddressController>();

    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      body: SafeArea(
        child: Column(
          children: [
            UnifiedProfileAppBar(
              title: selectionMode ? 'Select Address' : 'Address Book',
              showActionButton: false,
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return _buildShimmerList();
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

  Widget _buildAddressList(BuildContext context, AddressController controller) {
    final double buttonHeight = 56.h;
    final double gesture = MediaQuery.of(context).viewPadding.bottom;
    const double navHeight = kBottomNavigationBarHeight;

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        16.w,
        16.w,
        16.w,

        16.h + buttonHeight + gesture + navHeight,
      ),
      itemCount: controller.addresses.length,
      itemBuilder: (context, index) {
        final address = controller.addresses[index];
        return AddressCard(
          address: address,
          onTap: () {
            if (selectionMode) {
              // In selection mode, select the address and go back
              controller.selectAddress(address);
              Get.back();
            } else {
              // In normal mode, show options
              _showAddressOptions(address, controller);
            }
          },
          onSetDefault: () => controller.setAsDefault(address.id),
          onEdit: () => _navigateToEditAddress(address),
          onDelete: () => _showDeleteConfirmation(address, controller),
        );
      },
    );
  }

  Widget _buildAddNewAddressButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
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
        child: SafeArea(
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
                  onTap: () async {
                    Navigator.of(
                      Get.context!,
                    ).pop(); // Close bottom sheet using Navigator
                    await Future.delayed(const Duration(milliseconds: 100));
                    controller.setAsDefault(address.id);
                  },
                ),
              _buildBottomSheetOption(
                icon: Iconsax.edit_2,
                title: 'Edit Address',
                onTap: () async {
                  Navigator.of(
                    Get.context!,
                  ).pop(); // Close bottom sheet using Navigator
                  await Future.delayed(const Duration(milliseconds: 100));
                  _navigateToEditAddress(address);
                },
              ),
              _buildBottomSheetOption(
                icon: Iconsax.trash,
                title: 'Delete Address',
                color: AppColors.error,
                onTap: () async {
                  Navigator.of(
                    Get.context!,
                  ).pop(); // Close bottom sheet using Navigator
                  await Future.delayed(const Duration(milliseconds: 100));
                  _showDeleteConfirmation(address, controller);
                },
              ),
              SizedBox(height: 32.h),
            ],
          ),
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
    // Bottom sheet is already closed by the caller
    AddAddressScreen.show(Get.context!, addressToEdit: address);
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
            onPressed: () async {
              Navigator.of(
                Get.context!,
              ).pop(); // Close the confirmation dialog using Navigator
              await Future.delayed(
                const Duration(milliseconds: 100),
              ); // Small delay
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

  /// ✨ Shimmer skeleton list that mimics address cards
  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 3,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left icon placeholder
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(width: 8.w),

                // Middle content shimmer lines
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Container(
                        height: 14.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Phone
                      Container(
                        height: 12.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Address line 1
                      Container(
                        height: 12.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Address line 2
                      Container(
                        height: 12.h,
                        width: 180.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right side - default badge placeholder
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 60.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
