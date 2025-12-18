import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/profile/controllers/add_address_controller.dart';
import 'package:quikle_user/features/profile/data/models/shipping_address_model.dart';
import 'package:quikle_user/features/profile/presentation/widgets/address_type_selector.dart';
import 'package:quikle_user/features/profile/presentation/widgets/location_options.dart';
import 'package:quikle_user/features/profile/presentation/widgets/bottom_sheet_header.dart';
import 'package:quikle_user/features/profile/presentation/widgets/address_text_field.dart';

/// First Sheet - Address Type & Location Selection
class AddAddressScreen extends StatelessWidget {
  final ShippingAddressModel? addressToEdit;

  const AddAddressScreen({super.key, this.addressToEdit});

  static void show(
    BuildContext context, {
    ShippingAddressModel? addressToEdit,
  }) {
    final controller = Get.put(AddAddressController());

    // Pre-fill form if editing
    if (addressToEdit != null) {
      controller.prefillAddress(addressToEdit);
      // If editing, skip to details screen directly
      _showAddressDetailsScreen(context, addressToEdit);
    } else {
      // Show the initial selection screen
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const AddAddressScreen(),
      ).whenComplete(() {
        controller.clearForm();
      });
    }
  }

  static void _showAddressDetailsScreen(
    BuildContext context,
    ShippingAddressModel? addressToEdit,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddressDetailsScreen(addressToEdit: addressToEdit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddAddressController>();

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20.r,
                  offset: Offset(0, -4.h),
                ),
              ],
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BottomSheetHeader(
                      title: 'Add New Address',
                      subtitle: 'Select address type and location',
                      onClose: () {
                        controller.clearForm();
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(height: 28.h),

                    // Address Type Selection
                    const AddressTypeSelector(),

                    SizedBox(height: 32.h),

                    // Location Options
                    LocationOptions(
                      onLocationSelected: () {
                        _showAddressDetailsScreen(context, null);
                      },
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Second Sheet - Address Details Form
class AddressDetailsScreen extends StatelessWidget {
  final ShippingAddressModel? addressToEdit;

  const AddressDetailsScreen({super.key, this.addressToEdit});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddAddressController>();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20.r,
                  offset: Offset(0, -4.h),
                ),
              ],
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  24.w,
                  16.h,
                  24.w,
                  MediaQuery.of(context).viewInsets.bottom + 24.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BottomSheetHeader(
                      title: addressToEdit != null
                          ? 'Edit Address Details'
                          : 'Address Details',
                      subtitle: 'Fill in your address information',
                      onClose: () {
                        controller.clearForm();
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(height: 28.h),

                    // Address Details Section
                    Text(
                      'Address Details',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    AddressTextField(
                      controller: controller.flatHouseBuildingController,
                      hintText: 'Flat / House No / Building Name',
                      icon: Icons.apartment_rounded,
                      errorText: controller.flatHouseBuildingError,
                    ),

                    SizedBox(height: 16.h),

                    AddressTextField(
                      controller: controller.floorNumberController,
                      hintText: 'Floor Number (Optional)',
                      icon: Icons.stairs_rounded,
                      keyboardType: TextInputType.number,
                    ),

                    SizedBox(height: 16.h),

                    AddressTextField(
                      controller: controller.nearbyLandmarkController,
                      hintText: 'Nearby Landmark',
                      icon: Icons.location_city_rounded,
                      errorText: controller.nearbyLandmarkError,
                    ),

                    SizedBox(height: 16.h),

                    AddressTextField(
                      controller: controller.addressController,
                      hintText: 'Full Address',
                      icon: Icons.edit_location_alt_rounded,
                      maxLines: 3,
                      errorText: controller.addressError,
                    ),

                    SizedBox(height: 28.h),

                    // Contact Details Section
                    Text(
                      'Contact Details',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    AddressTextField(
                      controller: controller.nameController,
                      hintText: 'Full Name',
                      icon: Icons.person_rounded,
                      errorText: controller.nameError,
                    ),

                    SizedBox(height: 16.h),

                    AddressTextField(
                      controller: controller.phoneController,
                      hintText: 'Phone Number',
                      icon: Icons.phone_rounded,
                      keyboardType: TextInputType.phone,
                      errorText: controller.phoneError,
                    ),

                    SizedBox(height: 24.h),

                    // Make Default Switch
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.homeGrey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.cardColor,
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.bookmark_rounded,
                            color: AppColors.textPrimary,
                            size: 22.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'Set as default address',
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Obx(
                            () => Switch(
                              value: controller.isDefault.value,
                              onChanged: (value) =>
                                  controller.setDefault(value),
                              activeColor: AppColors.beakYellow,
                              activeTrackColor: AppColors.beakYellow
                                  .withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // Submit Button
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => addressToEdit != null
                                    ? controller.updateAddress(
                                        addressToEdit!.id,
                                      )
                                    : controller.addAddress(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.textPrimary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            elevation: controller.isLoading.value ? 0 : 4,
                            shadowColor: AppColors.textPrimary.withOpacity(0.3),
                          ),
                          child: controller.isLoading.value
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 22.w,
                                      height: 22.h,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5.w,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      addressToEdit != null
                                          ? 'Updating...'
                                          : 'Adding...',
                                      style: getTextStyle(
                                        font: CustomFonts.inter,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  addressToEdit != null
                                      ? 'Update Address'
                                      : 'Add Address',
                                  style: getTextStyle(
                                    font: CustomFonts.inter,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
