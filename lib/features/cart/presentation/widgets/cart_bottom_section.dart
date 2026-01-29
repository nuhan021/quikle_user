import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';
import 'package:quikle_user/features/profile/address/controllers/address_controller.dart';
import 'package:quikle_user/features/profile/payment/controllers/payment_method_controller.dart';
import '../../../home/presentation/widgets/address/adress_sheet_widget.dart';
import 'package:quikle_user/features/profile/address/presentation/screens/add_address_screen.dart';
import '../../../cart/controllers/cart_controller.dart';

class CartBottomSection extends StatelessWidget {
  final VoidCallback onPlaceOrder;
  final VoidCallback onPaymentMethodTap;

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

  void _showAddressSelection(BuildContext context) async {
    final addressController = Get.find<AddressController>();

    if (addressController.addresses.isEmpty) {
      AddAddressScreen.show(context);
      return;
    }

    final pickedId = await showAddressSelectionSheet(addressController);

    if (pickedId != null && pickedId.isNotEmpty) {
      _selectedAddressIdForCart = pickedId;
      try {
        await addressController.selectAndPersistDefault(pickedId);
      } catch (e) {
        final defaultAddr = addressController.defaultAddress;
        _selectedAddressIdForCart = defaultAddr?.id;
      }
    }
  }

  static void clearSelectedAddress() {
    _selectedAddressIdForCart = null;
  }

  static void setSelectedAddressId(String? id) {
    _selectedAddressIdForCart = id;
  }

  static String? getSelectedAddressId() {
    return _selectedAddressIdForCart;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8.r,
                offset: Offset(0, -2),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
          child: Column(
            children: [
              GetBuilder<AddressController>(
                builder: (controller) {
                  final defaultAddr = controller.defaultAddress;
                  final selectionMissing =
                      _selectedAddressIdForCart == null ||
                      controller.addresses.every(
                        (a) => a.id != _selectedAddressIdForCart,
                      );

                  if (selectionMissing) {
                    if (defaultAddr != null) {
                      _selectedAddressIdForCart = defaultAddr.id;
                    } else if (controller.addresses.isNotEmpty) {
                      _selectedAddressIdForCart = controller.addresses.first.id;
                    } else {
                      _selectedAddressIdForCart = null;
                    }
                  }

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

                  return GestureDetector(
                    onTap: () => _showAddressSelection(context),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 8.w),
                          child: Image.asset(
                            ImagePath.homeIcon,
                            width: 24.w,
                            height: 24.h,
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
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.ebonyBlack,
                                ),
                              ),
                              Text(
                                addressDetails,
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize: 12.sp,
                                  color: Colors.grey[600]!,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Row(
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
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      final paymentController =
                          Get.find<PaymentMethodController>();
                      final selectedMethod =
                          paymentController.selectedPaymentMethod;

                      return GestureDetector(
                        onTap: onPaymentMethodTap,
                        child: Container(
                          // Ensure same visual height as the Place order button
                          constraints: BoxConstraints(minHeight: 36.h),
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 10.w,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.ebonyBlack),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
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
                              Expanded(
                                child: Text(
                                  selectedMethod?.type.displayName ??
                                      'Pay Using',
                                  style: getTextStyle(
                                    font: CustomFonts.inter,
                                    fontSize: (selectedMethod != null)
                                        ? 11.sp
                                        : 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                  ),

                  SizedBox(width: 12.w),
                  IntrinsicWidth(
                    child: Obx(() {
                      final cartController = Get.find<CartController>();
                      final isPlacingOrder = cartController.isPlacingOrder;

                      return GestureDetector(
                        onTap: isPlacingOrder ? null : onPlaceOrder,
                        child: Container(
                          // Match minimum height with payment method container
                          constraints: BoxConstraints(minHeight: 36.h),
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
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '₹ ${totalAmount.toStringAsFixed(2)}',
                                      style: getTextStyle(
                                        font: CustomFonts.inter,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),

                                    SizedBox(width: 8.w),
                                    Container(
                                      width: 1.w,
                                      height: 20.h,
                                      color: Colors.white.withValues(
                                        alpha: .25,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),

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
        ),
      ),
    );
  }
}
