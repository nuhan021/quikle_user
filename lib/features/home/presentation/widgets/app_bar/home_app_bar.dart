import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quikle_user/core/common/widgets/address_widget.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/routes/app_routes.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CommonAppBar(
          title: ' ',
          titleWidget: AddressWidget(),
          showBackButton: false,
          showNotification: false,
          showProfile: false,
          backgroundColor: AppColors.eggshellWhite,
          isFromHome: true,
          actions: [
            IconButton(
              icon: const Icon(Iconsax.empty_wallet, color: Colors.black),
              onPressed: () => Get.toNamed(AppRoute.getPaymentMethods()),
            ),
          ],
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
