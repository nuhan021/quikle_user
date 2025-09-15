import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/home/presentation/widgets/address/adress_sheet_widget.dart';
import 'package:quikle_user/features/profile/controllers/address_controller.dart';
import 'package:quikle_user/routes/app_routes.dart';

class AddressWidget extends StatelessWidget {
  final AddressController addressController = Get.find<AddressController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressController>(
      init: addressController,
      builder: (controller) {
        final defaultAddress = controller.defaultAddress;

        return GestureDetector(
          onTap: () async {
            if (controller.addresses.isEmpty) {
              Get.toNamed(AppRoute.getAddAddress());
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      defaultAddress != null
                          ? '${_getAddressTypeLabel(defaultAddress.type)} - ${defaultAddress.name}'
                          : 'Add Address',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        color: AppColors.ebonyBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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
                const SizedBox(height: 2.0),
                Text(
                  defaultAddress != null
                      ? _formatAddress(
                          defaultAddress.address,
                          defaultAddress.city,
                        )
                      : 'Tap to select your delivery address',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    color: AppColors.featherGrey,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

  String _formatAddress(String address, String city) {
    var shortAddress = address.split(',').first;
    if (shortAddress.length > 20) {
      shortAddress = '${shortAddress.substring(0, 20)}...';
    }
    return '$shortAddress, $city';
  }
}
