import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/features/profile/payment/controllers/payment_method_controller.dart';
import 'package:quikle_user/features/profile/payment/presentation/widgets/add_payment_method_button.dart';
import 'package:quikle_user/features/profile/payment/presentation/widgets/payment_method_list_item.dart';
import 'package:quikle_user/features/profile/user_profile/presentation/widgets/unified_profile_app_bar.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaymentMethodController>();

    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      body: SafeArea(
        child: Column(
          children: [
            const UnifiedProfileAppBar(
              title: 'Payment Method',
              showActionButton: false,
            ),

            /// Supported payment info text
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Payment methods we support',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    Expanded(
                      child: Obx(() {
                        return ListView.builder(
                          itemCount: controller.paymentMethods.length,
                          itemBuilder: (context, index) {
                            final paymentMethod =
                                controller.paymentMethods[index];
                            return PaymentMethodListItem(
                              paymentMethod: paymentMethod,
                              onRemove: paymentMethod.isRemovable
                                  ? () => controller.removePaymentMethod(
                                      paymentMethod.id,
                                    )
                                  : null,
                            );
                          },
                        );
                      }),
                    ),

                    // Uncomment when add-payment is ready
                    // Padding(
                    //   padding: EdgeInsets.only(bottom: 24.h),
                    //   child: AddPaymentMethodButton(
                    //     onTap: () {},
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
