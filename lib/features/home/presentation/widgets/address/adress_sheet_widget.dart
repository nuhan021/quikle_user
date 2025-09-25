import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/profile/controllers/address_controller.dart';
import 'package:quikle_user/features/profile/presentation/screens/add_address_screen.dart';
import 'package:quikle_user/routes/app_routes.dart';

Future<String?> showAddressSelectionSheet(AddressController addressController) {
  return Get.bottomSheet<String>(
    _AddressSelectionSheet(addressController: addressController),
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: true,
  );
}

class _AddressSelectionSheet extends StatelessWidget {
  final AddressController addressController;

  const _AddressSelectionSheet({required this.addressController});

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Delivery Address',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 14, // Slightly larger for emphasis
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2A2A2A),
                        ),
                      ),
                      InkWell(
                        onTap: () => _navigateToAddAddress(Get.context!),
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(
                            milliseconds: 200,
                          ), // Smooth animation
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF26A69A), // Teal
                                Color(0xFF4DD0E1), // Cyan
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(
                              14,
                            ), // Softer corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white, // White for contrast
                                size: 16, // Slightly larger for visibility
                              ),
                              const SizedBox(
                                width: 8,
                              ), // More spacing for balance
                              Text(
                                'Add Address',
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize:
                                      14, // Slightly larger for readability
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    final items = addressController.addresses;
                    if (items.isEmpty) {
                      return _EmptyAddresses();
                    }
                    final currentDefaultId =
                        addressController.defaultAddress?.id;
                    return Column(
                      children: items.map((address) {
                        final isSelected = currentDefaultId == address.id;
                        return GestureDetector(
                          onTap: () {
                            Get.back(result: address.id);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.gradientColor.withValues(
                                      alpha: 0.15,
                                    )
                                  : Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.gradientColor
                                    : Colors.grey[300]!,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  // decoration: BoxDecoration(
                                  //   color: isSelected
                                  //       ? AppColors.gradientColor
                                  //       : Colors.grey[400],
                                  //   borderRadius: BorderRadius.circular(8),
                                  // ),
                                  child: Image.asset(
                                    address.type == AddressType.home
                                        ? ImagePath.homeAddressIcon
                                        : address.type == AddressType.office
                                        ? ImagePath.officeAddressIcon
                                        : ImagePath.addressIcon,
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.contain,
                                    //color: Colors.white,
                                  ),
                                ),

                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${_getAddressTypeLabel(address.type)} - ${address.name}',
                                            style: getTextStyle(
                                              font: CustomFonts.inter,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.ebonyBlack,
                                            ),
                                          ),
                                          if (address.isDefault) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.gradientColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                'Current',
                                                style: getTextStyle(
                                                  font: CustomFonts.inter,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatAddress(
                                          address.address,
                                          address.city,
                                        ),
                                        style: getTextStyle(
                                          font: CustomFonts.inter,
                                          fontSize: 12,
                                          color: AppColors.featherGrey,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    isSelected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_unchecked,
                                    color: isSelected
                                        ? AppColors.gradientColor
                                        : Colors.grey[400],
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddAddress(BuildContext context) {
    AddAddressScreen.show(context);
  }
}

class _EmptyAddresses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.location_off, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No addresses found',
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]!,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first delivery address',
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 14,
              color: Colors.grey[500]!,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed(AppRoute.getAddAddress());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gradientColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Add Address',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
