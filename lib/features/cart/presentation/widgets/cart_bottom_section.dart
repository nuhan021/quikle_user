import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';
import '../../../profile/controllers/address_controller.dart';
import '../../../profile/controllers/payment_method_controller.dart';
import '../../../home/presentation/widgets/address/adress_sheet_widget.dart';
import '../../../cart/controllers/cart_controller.dart';

class CartBottomSection extends StatelessWidget {
  final VoidCallback onPlaceOrder;
  final VoidCallback onPaymentMethodTap;

  /// NEW: pass cart total from caller
  final double totalAmount;

  static String? _selectedAddressIdForCart;

  const CartBottomSection({
    super.key,
    required this.onPlaceOrder,
    required this.onPaymentMethodTap,
    this.totalAmount = 0.0,
  });

  String _getAddressTypeText(AddressType type) {
    switch (type) {
      case AddressType.home:
        return 'Home';
      case AddressType.office:
        return 'Work';
      case AddressType.other:
        return 'Other';
    }
  }

  /// Changed: pass BuildContext so we can use ScaffoldMessenger (no Get.snackbar)
  void _showAddressSelection(BuildContext context) async {
    final addressController = Get.find<AddressController>();

    if (addressController.addresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No Addresses. Please add an address first.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final pickedId = await showAddressSelectionSheet(addressController);

    if (pickedId != null && pickedId.isNotEmpty) {
      _selectedAddressIdForCart = pickedId;
      addressController.update();
    }
  }

  static void clearSelectedAddress() {
    _selectedAddressIdForCart = null;
  }

  static String? getSelectedAddressId() {
    return _selectedAddressIdForCart;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: Column(
        children: [
          // Address row
          GetBuilder<AddressController>(
            init: AddressController(),
            builder: (controller) {
              final selectedAddress = _selectedAddressIdForCart != null
                  ? controller.addresses.firstWhereOrNull(
                      (addr) => addr.id == _selectedAddressIdForCart,
                    )
                  : controller.defaultAddress;

              final addressTypeText = selectedAddress != null
                  ? _getAddressTypeText(selectedAddress.type)
                  : 'Home';
              final addressDetails =
                  selectedAddress?.address ?? 'No address selected';

              return Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Image.asset(
                      ImagePath.homeIcon,
                      width: 40.w,
                      height: 40.h,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$addressTypeText',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.ebonyBlack,
                          ),
                        ),
                        Text(
                          addressDetails,
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 14.sp,
                            color: Colors.grey[600]!,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showAddressSelection(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 25.sp,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Change',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.beakYellow,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          SizedBox(height: 16.h),

          // ======== COMPACT PAY USING + EXPANDED PLACE ORDER ========
          Row(
            children: [
              // Compact Pay Using button (intrinsic width)
              Obx(() {
                final paymentController = Get.find<PaymentMethodController>();
                final selectedMethod = paymentController.selectedPaymentMethod;

                return GestureDetector(
                  onTap: onPaymentMethodTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 10.w,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.ebonyBlack),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (selectedMethod != null &&
                            selectedMethod.type.iconPath != null) ...[
                          Image.asset(
                            selectedMethod.type.iconPath!,
                            width: 16.w,
                            height: 16.h,
                          ),
                          SizedBox(width: 4.w),
                        ],
                        Text(
                          selectedMethod?.type.displayName ?? 'Pay Using',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16.sp,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                );
              }),

              SizedBox(width: 12.w),

              // Expanded Place Order button with total (takes remaining space)
              Expanded(
                child: Obx(() {
                  final cartController = Get.find<CartController>();
                  final isPlacingOrder = cartController.isPlacingOrder;

                  return GestureDetector(
                    onTap: isPlacingOrder ? null : onPlaceOrder,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 12.w,
                      ),
                      decoration: BoxDecoration(
                        color: isPlacingOrder ? Colors.grey : Colors.black,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: isPlacingOrder
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 16.w,
                                  height: 16.h,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Processing...',
                                  style: getTextStyle(
                                    font: CustomFonts.inter,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Total price (left)
                                Flexible(
                                  child: Text(
                                    '\$ ${totalAmount.toStringAsFixed(2)}',
                                    style: getTextStyle(
                                      font: CustomFonts.inter,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                // Thin divider
                                SizedBox(width: 8.w),
                                Container(
                                  width: 1.w,
                                  height: 20.h,
                                  color: Colors.white.withValues(alpha: .25),
                                ),
                                SizedBox(width: 8.w),

                                // Place order (right)
                                Text(
                                  'Place order',
                                  style: getTextStyle(
                                    font: CustomFonts.inter,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.beakYellow,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
