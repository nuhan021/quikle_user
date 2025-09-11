import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/profile/controllers/address_controller.dart';
import 'package:quikle_user/routes/app_routes.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onNotificationTap;

  const HomeAppBar({super.key, required this.onNotificationTap});

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
    // Take first part of address (before comma or first 20 characters)
    String shortAddress = address.split(',').first;
    if (shortAddress.length > 20) {
      shortAddress = '${shortAddress.substring(0, 20)}...';
    }
    return '$shortAddress, $city';
  }

  void _showAddressSelectionSheet(AddressController addressController) {
    // Track the selected address in this sheet
    final selectedAddressId =
        addressController.defaultAddress?.id.obs ?? ''.obs;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Delivery Address',
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ebonyBlack,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                Get.toNamed(AppRoute.getAddressBook()),
                            icon: Icon(
                              Icons.edit_location_alt_outlined,
                              color: AppColors.gradientColor,
                              size: 24,
                            ),
                            tooltip: 'Manage Addresses',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Address list
                      Obx(() {
                        return Column(
                          children: addressController.addresses.map((address) {
                            final isSelected =
                                selectedAddressId.value == address.id;

                            return GestureDetector(
                              onTap: () {
                                selectedAddressId.value = address.id;
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
                                    // Address type icon
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.gradientColor
                                            : Colors.grey[400],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        address.type == AddressType.home
                                            ? Icons.home
                                            : address.type == AddressType.office
                                            ? Icons.business
                                            : Icons.location_on,
                                        color: Colors.white,
                                        size: 20,
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
                                                    color:
                                                        AppColors.gradientColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    'Current',
                                                    style: getTextStyle(
                                                      font: CustomFonts.inter,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                    // Selection indicator
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
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
                      if (addressController.addresses.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.location_off,
                                size: 48,
                                color: Colors.grey[400],
                              ),
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
                        ),
                      // Save button
                      if (addressController.addresses.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            // Cancel button
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Get.back(),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.grey[400]!),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: getTextStyle(
                                    font: CustomFonts.inter,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600]!,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Save button
                            Expanded(
                              flex: 2,
                              child: Obx(() {
                                final hasSelectionChanged =
                                    selectedAddressId.value !=
                                    addressController.defaultAddress?.id;

                                return ElevatedButton(
                                  onPressed: hasSelectionChanged
                                      ? () async {
                                          if (selectedAddressId
                                              .value
                                              .isNotEmpty) {
                                            await addressController
                                                .setAsDefault(
                                                  selectedAddressId.value,
                                                );
                                            Get.back();
                                          }
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: hasSelectionChanged
                                        ? AppColors.gradientColor
                                        : Colors.grey[300],
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    elevation: hasSelectionChanged ? 2 : 0,
                                  ),
                                  child: Text(
                                    hasSelectionChanged
                                        ? 'Save Changes'
                                        : 'No Changes',
                                    style: getTextStyle(
                                      font: CustomFonts.inter,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: hasSelectionChanged
                                          ? Colors.white
                                          : Colors.grey[600]!,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        border: Border(
          bottom: BorderSide(color: AppColors.gradientColor, width: 2),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Image.asset(ImagePath.locationIcon, width: 24, height: 24),
              const SizedBox(width: 8),
              Expanded(
                child: GetBuilder<AddressController>(
                  init: AddressController(),
                  builder: (addressController) {
                    final defaultAddress = addressController.defaultAddress;

                    return GestureDetector(
                      onTap: () {
                        if (addressController.addresses.isEmpty) {
                          Get.toNamed(AppRoute.getAddAddress());
                        } else {
                          _showAddressSelectionSheet(addressController);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6.0),
                            Row(
                              children: [
                                // Address type and person name
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
                ),
              ),
              IconButton(
                icon: const Icon(Iconsax.empty_wallet, color: Colors.black),
                onPressed: () {
                  Get.toNamed(AppRoute.getPaymentMethods());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
