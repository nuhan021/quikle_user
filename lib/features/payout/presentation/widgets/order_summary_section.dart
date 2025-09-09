import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import '../../controllers/payout_controller.dart';
import '../../../cart/controllers/cart_controller.dart';

class OrderSummarySection extends StatelessWidget {
  const OrderSummarySection({super.key});

  String _formatItemPrice(double value) {
    if (value == value.roundToDouble()) {
      return '\$${value.toStringAsFixed(0)}';
    }
    return '\$${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final payoutController = Get.find<PayoutController>();
    final dividerColor = const Color(0xFFEAEAEA);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        final cartController = Get.find<CartController>();
        final cartItems = cartController.cartItems;

        // Dynamic parts from controller
        final subtotal = payoutController.subtotal;
        final deliveryFee =
            payoutController.deliveryFee; // <-- selected option + urgent
        final discount = payoutController.discountAmount; // 0 if none
        final total =
            payoutController.totalAmount; // subtotal - discount + deliveryFee

        // Label for delivery row (e.g., "Combined Delivery", "+ Urgent")
        final deliveryLabel = () {
          final opt = payoutController.selectedDeliveryOption;
          final base = opt?.title ?? 'Delivery';
          final urgent = payoutController.isUrgentDelivery ? '  •  Urgent' : '';
          return '$base$urgent';
        }();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Order Summary',
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.ebonyBlack,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.h, bottom: 6.h),
              child: Divider(height: 1, color: dividerColor),
            ),

            // Line items
            if (cartItems.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartItems.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: dividerColor),
                itemBuilder: (_, index) {
                  final item = cartItems[index];
                  final unitPrice = double.parse(
                    item.product.price.replaceAll('\$', '').trim(),
                  );
                  final lineTotal = unitPrice * item.quantity;

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.product.title} (${item.quantity}x)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 14.sp,
                              color: const Color(0xFF7C7C7C),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          _formatItemPrice(lineTotal),
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 14.sp,
                            color: const Color(0xFF7C7C7C),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

            if (cartItems.isNotEmpty) ...[
              SizedBox(height: 6.h),
              Divider(height: 1, color: dividerColor),
              SizedBox(height: 10.h),

              // Subtotal row
              _summaryRow(label: 'Subtotal', value: _formatItemPrice(subtotal)),

              SizedBox(height: 8.h),

              // Delivery row (from selected option)
              _summaryRow(
                label: deliveryLabel,
                value: deliveryFee > 0 ? _formatItemPrice(deliveryFee) : 'Free',
              ),

              // Discount row (if any)
              if (discount > 0) ...[
                SizedBox(height: 8.h),
                _summaryRow(
                  label: 'Discount',
                  value: '-${_formatItemPrice(discount)}',
                  valueColor: const Color(0xFF26A969),
                ),
              ],

              SizedBox(height: 10.h),
              Divider(height: 1, color: dividerColor),
              SizedBox(height: 10.h),

              // Total row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  Text(
                    _formatItemPrice(total),
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      }),
    );
  }

  Widget _summaryRow({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF7C7C7C),
            ),
          ),
        ),
        Text(
          value,
          style: getTextStyle(
            font: CustomFonts.inter,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF7C7C7C),
          ),
        ),
      ],
    );
  }
}
