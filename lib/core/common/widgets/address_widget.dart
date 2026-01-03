import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/home/presentation/widgets/address/adress_sheet_widget.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/profile/controllers/address_controller.dart';
import 'package:quikle_user/features/profile/presentation/screens/add_address_screen.dart';

class AddressWidget extends StatelessWidget {
  final AddressController addressController = Get.find<AddressController>();
  final double? nameFontSize;
  final double? addressFontSize;

  AddressWidget({Key? key, this.nameFontSize, this.addressFontSize})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressController>(
      init: addressController,
      builder: (controller) {
        final defaultAddress = controller.defaultAddress;

        return GestureDetector(
          onTap: () async {
            if (controller.addresses.isEmpty) {
              AddAddressScreen.show(context);
              return;
            }

            final pickedId = await showAddressSelectionSheet(controller);
            final currentId = controller.defaultAddress?.id;

            if (pickedId != null &&
                pickedId.isNotEmpty &&
                pickedId != currentId) {
              try {
                await controller.setAsDefault(pickedId);
              } catch (e) {
                Get.snackbar('Update failed', 'Could not set default address');
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Small icon for address type (use asset icons)
                if (defaultAddress != null) ...[
                  Image.asset(
                    defaultAddress.type == AddressType.home
                        ? ImagePath.homeAddressIcon
                        : defaultAddress.type == AddressType.office
                        ? ImagePath.officeAddressIcon
                        : ImagePath.addressIcon,
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 6),
                ],
                SizedBox(width: 6.w),

                // Type label + first name (top) and shortened address (bottom)
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        defaultAddress != null
                            ? '${_getAddressTypeLabel(defaultAddress.type)} - ${_firstName(defaultAddress.name)}'
                            : 'No Address',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          color: defaultAddress != null
                              ? AppColors.ebonyBlack
                              : AppColors.featherGrey,
                          fontSize: (nameFontSize ?? 12).sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      if (defaultAddress != null)
                        Text(
                          _shortAddress(
                            defaultAddress.address,
                            defaultAddress.city,
                          ),
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            color: AppColors.featherGrey,
                            fontSize: (addressFontSize ?? 10).sp,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),

                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: AppColors.featherGrey,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getAddressTypeLabel(AddressType type) {
    switch (type) {
      case AddressType.home:
        return 'Home';
      case AddressType.office:
        return 'Office';
      case AddressType.other:
        return 'Other';
    }
  }

  String _firstName(String fullName) {
    if (fullName.trim().isEmpty) return fullName;
    return fullName.trim().split(RegExp(r"\s+"))[0];
  }

  String _shortAddress(String address, String city) {
    final combined = [address, city].where((s) => s.isNotEmpty).join(', ');
    const max = 24;
    if (combined.length <= max) return combined;
    return '${combined.substring(0, max).trim()}...';
  }
}
