import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/orders/data/models/order_model.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order_status_helpers.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';
import 'package:quikle_user/features/orders/presentation/screens/order_tracking_screen.dart';
import 'package:quikle_user/core/common/widgets/customer_support_fab.dart';

class OrderInvoiceScreen extends StatelessWidget {
  final OrderModel order;

  const OrderInvoiceScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                UnifiedProfileAppBar(
                  title: 'Order Details',
                  showBackButton: true,
                  showActionButton: order.isTrackable,
                  actionText: order.isTrackable ? 'Track Order' : null,
                  onActionPressed: order.isTrackable
                      ? () => Get.to(() => OrderTrackingScreen(order: order))
                      : null,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      top: 16.h,
                      bottom: MediaQuery.of(context).padding.bottom,
                    ),
                    child: SingleChildScrollView(
                      // physics: const ClampingScrollPhysics(),
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOrderHeader(),
                          SizedBox(height: 16.h),
                          _buildOrderItems(),
                          SizedBox(height: 16.h),
                          _buildPricingDetails(),
                          SizedBox(height: 16.h),
                          _buildPaymentInfo(),
                          SizedBox(height: 16.h),
                          _buildShippingAddress(),
                          SizedBox(height: 16.h),
                          _buildDeliveryInfo(),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const CustomerSupportFAB(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- HEADER ROW ----------------
          Row(
            children: [
              // ORDER ID — should ellipse
              Expanded(
                child: Text(
                  '${order.orderId}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    font: CustomFonts.obviously,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ebonyBlack,
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // STATUS — must remain fully visible
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: OrderStatusHelpers.getStatusColor(
                    order.status,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OrderStatusHelpers.getStatusIcon(order.status),
                    SizedBox(width: 4.w),
                    Text(
                      OrderStatusHelpers.getStatusText(order.status),
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: OrderStatusHelpers.getStatusColor(order.status),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // ---------------- ORDER DATE ----------------
          Row(
            children: [
              Text(
                'Order Date: ',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF7C7C7C),
                ),
              ),
              Expanded(
                child: Text(
                  DateFormat('MMMM d, yyyy at h:mm a').format(order.orderDate),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ebonyBlack,
                  ),
                ),
              ),
            ],
          ),

          // ---------------- EST. DELIVERY ----------------
          if (order.estimatedDelivery != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  'Estimated Delivery: ',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7C7C7C),
                  ),
                ),
                Expanded(
                  child: Text(
                    DateFormat(
                      'MMM d, yyyy at h:mm a',
                    ).format(order.estimatedDelivery!),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.beakYellow,
                    ),
                  ),
                ),
              ],
            ),
          ],

          // ---------------- TRANSACTION ID ----------------
          if (order.transactionId != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  'Transaction ID: ',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7C7C7C),
                  ),
                ),
                Expanded(
                  child: Text(
                    order.transactionId!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ebonyBlack,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderItems() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Items',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.ebonyBlack,
            ),
          ),
          SizedBox(height: 12.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (context, index) =>
                Divider(height: 24.h, color: const Color(0xFFEEEEEE)),
            itemBuilder: (context, index) {
              final item = order.items[index];
              final unitPrice = double.parse(
                item.product.price.replaceAll('₹', '').trim(),
              );
              final lineTotal = unitPrice * item.quantity;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        item.product.imagePath,
                        fit: BoxFit.cover,
                        width: 60.w,
                        height: 60.w,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFF5F5F5),
                            child: Image.asset(
                              ImagePath.logo,
                              fit: BoxFit.contain,
                              // color: Colors.grey,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;

                          return Center(
                            child: SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  AppColors.beakYellow,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.title,
                          style: getTextStyle(
                            font: CustomFonts.obviously,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.ebonyBlack,
                          ),
                        ),
                        if (item.product.description.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Text(
                            item.product.description,
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF7C7C7C),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Qty: ${item.quantity}',
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.ebonyBlack,
                              ),
                            ),
                            Text(
                              '₹${lineTotal.toStringAsFixed(2)}',
                              style: getTextStyle(
                                font: CustomFonts.obviously,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ebonyBlack,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPricingDetails() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Details',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.ebonyBlack,
            ),
          ),
          SizedBox(height: 12.h),
          _buildPriceRow('Subtotal', order.subtotal),
          SizedBox(height: 8.h),
          _buildPriceRow('Delivery Fee', order.deliveryFee),
          if (order.discount != null && order.discount! > 0) ...[
            SizedBox(height: 8.h),
            _buildPriceRow('Discount', -order.discount!, isDiscount: true),
          ],
          SizedBox(height: 12.h),
          Divider(height: 1, color: const Color(0xFFEEEEEE)),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: getTextStyle(
                  font: CustomFonts.obviously,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ebonyBlack,
                ),
              ),
              Text(
                '₹${order.total.toStringAsFixed(2)}',
                style: getTextStyle(
                  font: CustomFonts.obviously,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.beakYellow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: getTextStyle(
            font: CustomFonts.inter,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF7C7C7C),
          ),
        ),
        Text(
          isDiscount
              ? '-₹${amount.abs().toStringAsFixed(2)}'
              : '₹${amount.toStringAsFixed(2)}',
          style: getTextStyle(
            font: CustomFonts.inter,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isDiscount ? Colors.green : AppColors.ebonyBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Information',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.ebonyBlack,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.payment, size: 20.sp, color: AppColors.beakYellow),
              SizedBox(width: 8.w),
              Text(
                _getPaymentMethodDisplayName(),
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ebonyBlack,
                ),
              ),
            ],
          ),
          // if (order.couponCode != null) ...[
          //   SizedBox(height: 8.h),
          //   Row(
          //     children: [
          //       Icon(Icons.local_offer, size: 20.sp, color: Colors.green),
          //       SizedBox(width: 8.w),
          //       Text(
          //         'Coupon Applied: ${order.couponCode}',
          //         style: getTextStyle(
          //           font: CustomFonts.inter,
          //           fontSize: 14.sp,
          //           fontWeight: FontWeight.w500,
          //           color: Colors.green,
          //         ),
          //       ),
          //     ],
          //   ),
          // ],
        ],
      ),
    );
  }

  Widget _buildShippingAddress() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Address',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.ebonyBlack,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, size: 20.sp, color: AppColors.beakYellow),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.shippingAddress.name,
                      style: getTextStyle(
                        font: CustomFonts.obviously,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.ebonyBlack,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${order.shippingAddress.address}\n${order.shippingAddress.city}, ${order.shippingAddress.state} ${order.shippingAddress.zipCode}',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7C7C7C),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      order.shippingAddress.phoneNumber,
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.ebonyBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Information',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.ebonyBlack,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.delivery_dining,
                size: 20.sp,
                color: AppColors.beakYellow,
              ),
              SizedBox(width: 8.w),
              Text(
                order.deliveryOption.title,
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ebonyBlack,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.only(left: 28.w),
            child: Text(
              order.deliveryOption.description,
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF7C7C7C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodDisplayName() {
    switch (order.paymentMethod.type.name) {
      case 'cashOnDelivery':
        return 'Cash on Delivery';
      case 'googlePay':
        return 'Google Pay';
      case 'paytm':
        return 'Paytm';
      case 'phonePe':
        return 'PhonePe';
      case 'razorpay':
        return 'Razorpay';
      case 'cashfree':
        return 'Cashfree';
      case 'wallet':
        return 'Wallet';
      default:
        return 'Unknown Payment Method';
    }
  }
}
