import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';
import 'package:quikle_user/features/orders/controllers/order_tracking_controller.dart';

class OrderTrackingAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onShareTap;

  const OrderTrackingAppBar({super.key, this.onBackTap, this.onShareTap});

  @override
  Widget build(BuildContext context) {
    return CommonAppBar(
      title: "Order Tracking",
      onBackTap: onBackTap ?? () => Get.back(),
      showBackButton: true,
      actions: [
        IconButton(
          onPressed:
              onShareTap ??
              () => Get.find<OrderTrackingController>().shareTrackingInfo(),
          icon: Icon(
            Icons.share_outlined,
            color: AppColors.ebonyBlack,
            size: 24.sp,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
