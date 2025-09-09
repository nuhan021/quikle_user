import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import '../widgets/checkout_app_bar.dart';
import '../widgets/order_summary_section.dart';
import '../widgets/shipping_address_section.dart';
import '../widgets/delivery_options_section.dart';
import '../widgets/payment_method_section.dart';
import '../widgets/coupon_section.dart';
import '../widgets/place_order_button.dart';
import '../../controllers/payout_controller.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PayoutController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.homeGrey,
        body: SafeArea(
          child: Column(
            children: [
              const CheckoutAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      SizedBox(height: 16.h),
                      const OrderSummarySection(),

                      SizedBox(height: 19.h),
                      const ShippingAddressSection(),

                      SizedBox(height: 19.h),
                      const DeliveryOptionsSection(),

                      SizedBox(height: 19.h),
                      PaymentMethodSection(),

                      SizedBox(height: 19.h),
                      const CouponSection(),
                    ],
                  ),
                ),
              ),
              const PlaceOrderButton(),
            ],
          ),
        ),
      ),
    );
  }
}
