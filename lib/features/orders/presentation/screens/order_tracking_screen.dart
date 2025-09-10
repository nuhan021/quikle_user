import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/orders/controllers/order_tracking_controller.dart';
import 'package:quikle_user/features/orders/data/models/order_model.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order_tracking_app_bar.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order_tracking_map_section.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order_details_section.dart';
import 'package:quikle_user/features/orders/presentation/widgets/time_estimation_section.dart';
import 'package:quikle_user/features/orders/presentation/widgets/progress_section.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Try to find existing controller first, create if not found
    OrderTrackingController controller;
    if (Get.isRegistered<OrderTrackingController>()) {
      controller = Get.find<OrderTrackingController>();
    } else {
      controller = Get.put(OrderTrackingController());
    }

    // Initialize with order (safe for hot reload)
    controller.initializeWithOrder(order);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshTrackingData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const OrderTrackingAppBar(),
                SizedBox(height: 24.h),
                const OrderTrackingMapSection(),

                SizedBox(height: 16.h),

                OrderDetailsSection(order: order, controller: controller),

                SizedBox(height: 16.h),

                TimeEstimationSection(controller: controller),

                SizedBox(height: 16.h),

                ProgressSection(controller: controller),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
