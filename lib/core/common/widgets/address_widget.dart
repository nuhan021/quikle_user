import 'package:flutter/material.dart';
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

                // Type label + name (compact)
                Text(
                  defaultAddress != null
                      ? '${_getAddressTypeLabel(defaultAddress.type)} - ${defaultAddress.name}'
                      : 'No Address',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    color: defaultAddress != null
                        ? AppColors.ebonyBlack
                        : AppColors.featherGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
}
