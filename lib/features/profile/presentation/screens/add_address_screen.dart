import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';
import 'package:quikle_user/features/profile/controllers/add_address_controller.dart';

class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddAddressScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddAddressController());

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 16.r,
                offset: Offset(0, -4.h),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20.w,
                20.h,
                20.w,
                MediaQuery.of(context).viewInsets.bottom + 20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Add New Address',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: AppColors.homeGrey,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 20.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  Obx(
                    () => Row(
                      children: AddressType.values.map((type) {
                        final isSelected =
                            controller.selectedAddressType.value == type;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => controller.setAddressType(type),
                            child: Container(
                              margin: EdgeInsets.only(
                                right: type != AddressType.values.last
                                    ? 8.w
                                    : 0,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.beakYellow
                                    : AppColors.homeGrey,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.beakYellow
                                      : AppColors.cardColor,
                                  width: 1.w,
                                ),
                              ),
                              child: Text(
                                type.typeDisplayName,
                                textAlign: TextAlign.center,
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  _buildTextField(
                    controller: controller.nameController,
                    hintText: 'Full Name',
                    errorText: controller.nameError,
                  ),

                  SizedBox(height: 16.h),

                  _buildTextField(
                    controller: controller.phoneController,
                    hintText: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    errorText: controller.phoneError,
                  ),

                  SizedBox(height: 16.h),

                  _buildTextField(
                    controller: controller.addressController,
                    hintText: 'Full Address',
                    errorText: controller.addressError,
                  ),

                  SizedBox(height: 16.h),

                  Obx(
                    () => _buildDropdown(
                      value: controller.selectedCountry.value,
                      hintText: 'Select Country',
                      items: controller.countries,
                      onChanged: controller.setCountry,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  Obx(
                    () => _buildDropdown(
                      value: controller.selectedCity.value,
                      hintText: 'Select City',
                      items: controller.cities,
                      onChanged: controller.setCity,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  _buildTextField(
                    controller: controller.zipCodeController,
                    hintText: 'Zip Code',
                    keyboardType: TextInputType.number,
                    errorText: controller.zipCodeError,
                  ),

                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Text(
                        'Make default',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Obx(
                        () => Switch(
                          value: controller.isDefault.value,
                          onChanged: (value) => controller.setDefault(value),
                          activeThumbColor: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 32.h),

                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.addAddress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.textPrimary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isLoading.value
                            ? SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.w,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Add New Address',
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
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
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    RxString? errorText,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.cardColor, width: 1.w),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Obx(
            () => errorText.value.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: 4.h, left: 4.w),
                    child: Text(
                      errorText.value,
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.red,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
      ],
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hintText,
    required RxList<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColors.homeGrey,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.cardColor, width: 1.w),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        hint: Text(
          hintText,
          style: getTextStyle(
            font: CustomFonts.inter,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

extension AddressTypeExtension on AddressType {
  String get typeDisplayName {
    switch (this) {
      case AddressType.home:
        return 'Home';
      case AddressType.office:
        return 'Office';
      case AddressType.other:
        return 'Other';
    }
  }
}
