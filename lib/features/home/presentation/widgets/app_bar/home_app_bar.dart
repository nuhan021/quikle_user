// lib/features/home/presentation/widgets/app_bar/home_app_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quikle_user/core/common/widgets/address_widget.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';
import 'package:quikle_user/routes/app_routes.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonAppBar(
      title: ' ',
      titleWidget: AddressWidget(),
      showBackButton: false,
      showNotification: false,
      showProfile: false,
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Iconsax.empty_wallet, color: Colors.black),
          onPressed: () => Get.toNamed(AppRoute.getPaymentMethods()),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
