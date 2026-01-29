import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/profile/address/controllers/add_address_controller.dart';
import 'package:quikle_user/features/profile/address/data/models/shipping_address_model.dart';
import 'package:quikle_user/features/profile/address/presentation/widgets/address_type_selector.dart';
import 'package:quikle_user/features/profile/address/presentation/widgets/location_options.dart';
import 'package:quikle_user/features/profile/user_profile/presentation/widgets/bottom_sheet_header.dart';
import 'package:quikle_user/features/profile/address/presentation/widgets/address_text_field.dart';
import 'package:quikle_user/features/profile/address/presentation/screens/map_address_picker_screen.dart';

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
        // Only clear the form if the user didn't proceed to select an
        // address (from map or current location) or intentionally
        // navigated to the map picker. We set `willOpenMap` before
        // popping the initial sheet when the user chooses "Add from Map",
        // so skip clearing in that case to preserve the selected type.
        if (!(controller.useCurrentLocation.value ||
            controller.isAddressFromMap.value ||
            controller.willOpenMap.value)) {
          controller.clearForm();
        }
        // If the user cancelled the sheet without going to map/current location,
        // clearForm() will have been called above.
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

                    // Address Type Selection (show when editing)
                    if (addressToEdit != null) ...[
                      const AddressTypeSelector(),
                      SizedBox(height: 28.h),
                    ],

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

                    // Full Address Field - Non-editable if from map or current location
                    Obx(() {
                      final isFromMapOrLocation =
                          controller.isAddressFromMap.value ||
                          controller.useCurrentLocation.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: AddressTextField(
                                  controller: controller.addressController,
                                  hintText: 'Full Address',
                                  icon: Icons.edit_location_alt_rounded,
                                  maxLines: 3,
                                  errorText: controller.addressError,
                                  enabled: !isFromMapOrLocation,
                                ),
                              ),
                              if (isFromMapOrLocation) ...[
                                SizedBox(width: 8.w),
                                InkWell(
                                  onTap: () {
                                    // Close current sheet and open map
                                    Navigator.of(context).pop();
                                    Future.delayed(
                                      const Duration(milliseconds: 300),
                                      () {
                                        Get.find<AddAddressController>()
                                                .isAddressFromMap
                                                .value =
                                            false;
                                        Get.find<AddAddressController>()
                                                .useCurrentLocation
                                                .value =
                                            false;
                                        MapAddressPickerScreen.show(
                                          Get.context!,
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.beakYellow,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Icon(
                                      Icons.edit_location_rounded,
                                      color: Colors.white,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (isFromMapOrLocation) ...[
                            SizedBox(height: 8.h),
                            Padding(
                              padding: EdgeInsets.only(left: 4.w),
                              child: Text(
                                'Address selected from ${controller.useCurrentLocation.value ? "current location" : "map"}. Tap the icon to change.',
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    }),

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
