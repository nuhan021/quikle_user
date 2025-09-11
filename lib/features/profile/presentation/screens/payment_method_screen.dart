import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/payment_enums.dart';
import 'package:quikle_user/features/profile/data/models/payment_method_model.dart';
import 'package:quikle_user/features/profile/presentation/widgets/add_payment_method_button.dart';
import 'package:quikle_user/features/profile/presentation/widgets/payment_method_list_item.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  // Sample payment methods based on the Figma design
  List<PaymentMethodModel> paymentMethods = [
    const PaymentMethodModel(
      id: '1',
      type: PaymentMethodType.paytm,
      isRemovable: true,
    ),
    const PaymentMethodModel(
      id: '2',
      type: PaymentMethodType.googlePay,
      isRemovable: true,
    ),
    const PaymentMethodModel(
      id: '3',
      type: PaymentMethodType.phonePe,
      isRemovable: true,
    ),
    const PaymentMethodModel(
      id: '4',
      type: PaymentMethodType.cashfree,
      isRemovable: true,
    ),
    const PaymentMethodModel(
      id: '5',
      type: PaymentMethodType.razorpay,
      isRemovable: true,
    ),
    const PaymentMethodModel(
      id: '6',
      type: PaymentMethodType.cashOnDelivery,
      isRemovable: false, // COD cannot be removed
    ),
  ];

  void _removePaymentMethod(String id) {
    setState(() {
      paymentMethods.removeWhere((method) => method.id == id);
    });
  }

  void _addNewPaymentMethod() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add new payment method functionality coming soon!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      body: Column(
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
                  //SizedBox(height: 4.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: paymentMethods.length,
                      itemBuilder: (context, index) {
                        final paymentMethod = paymentMethods[index];
                        return PaymentMethodListItem(
                          paymentMethod: paymentMethod,
                          onRemove: paymentMethod.isRemovable
                              ? () => _removePaymentMethod(paymentMethod.id)
                              : null,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: AddPaymentMethodButton(onTap: _addNewPaymentMethod),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
