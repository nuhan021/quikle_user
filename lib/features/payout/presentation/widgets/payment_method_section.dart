import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/payout/data/models/payment_method_model.dart';
import '../../controllers/payout_controller.dart';

class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    final payoutController = Get.find<PayoutController>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Payment Method',
            style: getTextStyle(
              font: CustomFonts.manrope,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF333333),
            ),
          ),

          SizedBox(height: 8.h),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E9E9)),
          SizedBox(height: 12.h),

          Obx(() {
            final controller = payoutController;
            final methods = controller.paymentMethods;
            final selected = controller.selectedPaymentMethod;

            return DropdownButtonFormField<PaymentMethodModel>(
              initialValue:
                  selected ?? (methods.isNotEmpty ? methods.first : null),
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 18.h,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Color(0xFFE8E9E9)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Color(0xFFE8E9E9)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 20.sp,
                color: Colors.grey[600],
              ),

              selectedItemBuilder: (ctx) => methods.map((m) {
                return Row(
                  children: [
                    if (m.icon != null && m.icon!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: Image.asset(
                          m.icon!,
                          width: 28.w,
                          height: 28.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    Flexible(
                      child: Text(
                        m.name,
                        overflow: TextOverflow.ellipsis,
                        style: getTextStyle(
                          font: CustomFonts.manrope,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF262D2C),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),

              items: methods.map((m) {
                return DropdownMenuItem<PaymentMethodModel>(
                  value: m,
                  child: Row(
                    children: [
                      if (m.icon != null && m.icon!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: Image.asset(
                            m.icon!,
                            width: 28.w,
                            height: 28.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                      Flexible(
                        child: Text(
                          m.name,
                          overflow: TextOverflow.ellipsis,
                          style: getTextStyle(
                            font: CustomFonts.manrope,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF262D2C),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (PaymentMethodModel? val) {
                if (val != null) controller.selectPaymentMethod(val);
              },
            );
          }),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
