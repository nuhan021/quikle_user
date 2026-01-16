import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/main/presentation/screens/main_screen.dart';
import 'package:quikle_user/features/orders/controllers/orders_controller.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order/grouped_orders_section.dart';
import 'package:quikle_user/features/orders/presentation/screens/order/order_invoice_screen.dart';
import 'package:quikle_user/features/orders/presentation/screens/order/order_tracking_screen.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';
import 'package:shimmer/shimmer.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrdersController controller = Get.put(OrdersController());

    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const UnifiedProfileAppBar(
              title: 'My Orders',
              showBackButton: false,
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  // 👇 Show shimmer skeleton list here
                  return _buildShimmerList();
                }

                if (controller.error.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.r,
                          color: Colors.red,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Oops! Something went wrong',
                          style: getTextStyle(
                            font: CustomFonts.obviously,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.ebonyBlack,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Text(
                            controller.error.value,
                            textAlign: TextAlign.center,
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF7C7C7C),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: controller.refreshOrders,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.beakYellow,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 12.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Try Again',
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 80.r,
                          color: const Color(0xFF7C7C7C),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'No Orders Yet',
                          style: getTextStyle(
                            font: CustomFonts.obviously,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.ebonyBlack,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Text(
                            'You haven\'t placed any orders yet.\nStart shopping to see your orders here!',
                            textAlign: TextAlign.center,
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF7C7C7C),
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h),
                        ElevatedButton(
                          onPressed: () => _navigateToOrders(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.beakYellow,
                            padding: EdgeInsets.symmetric(
                              horizontal: 32.w,
                              vertical: 16.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Start Shopping',
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // ✅ Order list with grouping
                return RefreshIndicator(
                  onRefresh: controller.refreshOrders,
                  color: AppColors.beakYellow,
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 16.h, bottom: 100.h),
                    itemCount: controller.groupedOrders.length,
                    itemBuilder: (context, index) {
                      final groupedOrder = controller.groupedOrders[index];
                      // Show grouped section with all orders
                      return GroupedOrdersSection(
                        groupedOrder: groupedOrder,
                        onOrderTap: (order) {
                          Get.to(() => OrderInvoiceScreen(order: order));
                        },
                        onTrack: (order) {
                          Get.to(() => OrderTrackingScreen(order: order));
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// ✨ Shimmer skeleton list that mimics order cards
  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left image placeholder
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(width: 12.w),

                // Right content shimmer lines
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        height: 12.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        height: 10.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToOrders(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainScreen(initialIndex: 0),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child,
      ),
      (route) => false,
    );
  }
}
