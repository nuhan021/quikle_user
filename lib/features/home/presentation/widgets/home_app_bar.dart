import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onNotificationTap;

  const HomeAppBar({super.key, required this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          border: Border(bottom: BorderSide(color: Colors.yellow, width: 2)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Image.asset(ImagePath.locationIcon, width: 24, height: 24),
              //Icon(Iconsax.location, color: Colors.black),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),
                    Text(
                      '12B, Palm Grove, Versova',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        color: AppColors.ebonyBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Ranchi, Jharkhand',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        color: AppColors.featherGrey,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Iconsax.empty_wallet, color: Colors.black),
                onPressed: onNotificationTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
