import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/profile/data/models/shipping_address_model.dart';
import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';

class AddressCard extends StatelessWidget {
  final ShippingAddressModel address;
  final VoidCallback? onTap;
  final VoidCallback? onSetDefault;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AddressCard({
    super.key,
    required this.address,
    this.onTap,
    this.onSetDefault,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A616161),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAddressTypeIcon(),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address.name,
                            style: getTextStyle(
                              font: CustomFonts.obviously,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.ebonyBlack,
                            ),
                          ),
                          SizedBox(height: 4.h),

                          Text(
                            address.phoneNumber,
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${address.address}\n${address.city}, ${address.state} ${address.zipCode}',
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.featherGrey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (address.isDefault)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.freeColor.withValues(alpha: .12),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              'Default',
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.freeColor,
                              ),
                            ),
                          ),

                        SizedBox(height: 32.h),

                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 20.sp,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressTypeIcon() {
    return SizedBox(
      width: 66.w,
      height: 66.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(_getAddressTypeIconPath(), width: 32.sp, height: 32.sp),

          SizedBox(height: 8.h),

          Text(
            _getAddressTypeLabel(),
            textAlign: TextAlign.center,
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.ebonyBlack,
            ),
          ),
        ],
      ),
    );
  }

  String _getAddressTypeIconPath() {
    switch (address.type) {
      case AddressType.home:
        return ImagePath.homeAddressIcon;
      case AddressType.office:
        return ImagePath.officeAddressIcon;

      default:
        return ImagePath.homeAddressIcon;
    }
  }

  String _getAddressTypeLabel() {
    switch (address.type) {
      case AddressType.home:
        return 'Home';
      case AddressType.office:
        return 'Office';
      case AddressType.other:
        return 'Other';
    }
  }
}
