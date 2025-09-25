import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/features/profile/controllers/payment_method_controller.dart';
import 'package:quikle_user/features/profile/presentation/widgets/add_payment_method_button.dart';
import 'package:quikle_user/features/profile/presentation/widgets/payment_method_list_item.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';

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
                    Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: AddPaymentMethodButton(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Add new payment method functionality coming soon!',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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
