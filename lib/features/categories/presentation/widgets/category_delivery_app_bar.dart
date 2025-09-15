import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';
import 'package:quikle_user/features/home/presentation/widgets/address/adress_sheet_widget.dart';
import 'package:quikle_user/features/profile/controllers/address_controller.dart';
import 'package:quikle_user/routes/app_routes.dart';

class CategoryDeliveryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final RxString? reactiveTitle;
  final VoidCallback? onBackTap;

  const CategoryDeliveryAppBar({
    super.key,
    this.title,
    this.reactiveTitle,
    this.onBackTap,
  }) : assert(
         title != null || reactiveTitle != null,
         'Either title or reactiveTitle must be provided',
       );

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
    final String displayTitle = title ?? (reactiveTitle?.value ?? '');

    return CommonAppBar(
      title: displayTitle,
      showBackButton: true,
      showNotification: false,
      showProfile: false,
      backgroundColor: Colors.white,
      onBackTap: onBackTap,
      titleWidget: Row(
        children: [
          // Category title
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: reactiveTitle != null
                  ? Obx(
                      () => Text(
                        reactiveTitle!.value,
                        style: getTextStyle(
                          font: CustomFonts.obviously,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.ebonyBlack,
                        ),
                      ),
                    )
                  : Text(
                      displayTitle,
                      style: getTextStyle(
                        font: CustomFonts.obviously,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.ebonyBlack,
                      ),
                    ),
            ),
          ),

          // Delivery location section
          Expanded(
            flex: 3,
            child: GetBuilder<AddressController>(
              init: AddressController(),
              builder: (addressController) {
                final defaultAddress = addressController.defaultAddress;

                return GestureDetector(
                  onTap: () async {
                    // Handle address selection similar to home page
                    if (addressController.addresses.isEmpty) {
                      Get.toNamed(AppRoute.getAddAddress());
                      return;
                    }

                    final pickedId = await showAddressSelectionSheet(
                      addressController,
                    );
                    final currentId = addressController.defaultAddress?.id;

                    if (pickedId != null &&
                        pickedId.isNotEmpty &&
                        pickedId != currentId) {
                      try {
                        await addressController.setAsDefault(pickedId);
                      } catch (e) {
                        Get.snackbar(
                          'Update failed',
                          'Could not set default address',
                        );
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.h,
                      horizontal: 8.w,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          ImagePath.locationIcon,
                          width: 16.w,
                          height: 16.h,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      defaultAddress != null
                                          ? '${_getAddressTypeLabel(defaultAddress.type)} - ${defaultAddress.name}'
                                          : 'Add Address',
                                      style: getTextStyle(
                                        font: CustomFonts.inter,
                                        color: AppColors.ebonyBlack,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 14.sp,
                                    color: AppColors.featherGrey,
                                  ),
                                ],
                              ),
                              Text(
                                defaultAddress != null
                                    ? _formatAddress(
                                        defaultAddress.address,
                                        defaultAddress.city,
                                      )
                                    : 'Tap to select delivery address',
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  color: AppColors.featherGrey,
                                  fontSize: 10.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
