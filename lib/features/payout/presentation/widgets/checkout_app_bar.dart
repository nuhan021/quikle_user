import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';

class CheckoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onShareTap;

  const CheckoutAppBar({super.key, this.onBackTap, this.onShareTap});

  @override
  Widget build(BuildContext context) {
    return CommonAppBar(
      title: "Checkout",
      onBackTap: onBackTap ?? () => Get.back(),
      showBackButton: true,
      actions: [
        IconButton(
          onPressed: onShareTap ?? () {},
          icon: Icon(Icons.share, size: 24.sp, color: Colors.black),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
