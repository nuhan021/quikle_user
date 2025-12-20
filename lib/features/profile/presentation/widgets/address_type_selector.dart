import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';
import 'package:quikle_user/features/profile/controllers/add_address_controller.dart';

class AddressTypeSelector extends StatelessWidget {
  const AddressTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddAddressController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address Type',
          style: getTextStyle(
            font: CustomFonts.inter,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => Row(
            children: AddressType.values.map((type) {
              final isSelected = controller.selectedAddressType.value == type;
              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.setAddressType(type),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: type != AddressType.values.last ? 10.w : 0,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                AppColors.beakYellow,
                                AppColors.beakYellow.withOpacity(0.8),
                              ],
                            )
                          : null,
                      color: isSelected ? null : AppColors.homeGrey,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.beakYellow
                            : AppColors.cardColor,
                        width: 1.5.w,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.beakYellow.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          type == AddressType.home
                              ? Icons.home_rounded
                              : type == AddressType.office
                              ? Icons.business_rounded
                              : Icons.location_on_rounded,
                          size: 18.sp,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          type.typeDisplayName,
                          textAlign: TextAlign.center,
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
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
