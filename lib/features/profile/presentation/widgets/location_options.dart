import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/profile/controllers/add_address_controller.dart';
import 'package:quikle_user/features/profile/presentation/screens/map_address_picker_screen.dart';

class LocationOptions extends StatelessWidget {
  final VoidCallback onLocationSelected;

  const LocationOptions({super.key, required this.onLocationSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: getTextStyle(
            font: CustomFonts.inter,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),

        // Use Current Location Button
        _CurrentLocationButton(onLocationSelected: onLocationSelected),

        SizedBox(height: 12.h),

        // Add from Map Button
        _MapPickerButton(
          onMapSelected: () {
            Navigator.of(context).pop();
            MapAddressPickerScreen.show(context);
          },
        ),
      ],
    );
  }
}

class _CurrentLocationButton extends StatelessWidget {
  final VoidCallback onLocationSelected;

  const _CurrentLocationButton({required this.onLocationSelected});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddAddressController>();

    return Obx(
      () => GestureDetector(
        onTap: controller.isLoading.value
            ? null
            : () async {
                controller.setUseCurrentLocation(true);

                final success = await controller
                    .getCurrentLocationAndPopulateAddress();

                if (success) {
                  Navigator.of(context).pop();
                  onLocationSelected();
                }
              },
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: controller.isLoading.value
                ? AppColors.homeGrey.withOpacity(0.5)
                : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.cardColor, width: 1.5.w),
          ),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: AppColors.beakYellow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: controller.isLoading.value
                    ? SizedBox(
                        width: 22.w,
                        height: 22.h,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.w,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.beakYellow,
                            ),
                          ),
                        ),
                      )
                    : Icon(
                        Icons.my_location_rounded,
                        color: AppColors.beakYellow,
                        size: 22.sp,
                      ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.isLoading.value
                          ? 'Detecting Location...'
                          : 'Use Current Location',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      controller.isLoading.value
                          ? 'Please wait...'
                          : 'Auto-detect your location',
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
              if (!controller.isLoading.value)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.textSecondary,
                  size: 18.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapPickerButton extends StatelessWidget {
  final VoidCallback onMapSelected;

  const _MapPickerButton({required this.onMapSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onMapSelected,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.cardColor, width: 1.5.w),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: AppColors.beakYellow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.map_rounded,
                color: AppColors.beakYellow,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Address',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Pick location from map',
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
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textSecondary,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}
