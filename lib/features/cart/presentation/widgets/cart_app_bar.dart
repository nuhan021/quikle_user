import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';

class CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onClearAll;
  final VoidCallback? onBackTap;
  final bool showBackButton;

  const CartAppBar({
    super.key,
    required this.onClearAll,
    this.onBackTap,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return CommonAppBar(
      title: 'Cart',
      onBackTap: onBackTap ?? () => Navigator.pop(context),
      showBackButton: showBackButton,
      actions: [
        TextButton(
          onPressed: onClearAll,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            minimumSize: Size(0, kToolbarHeight),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Clear all',
            textAlign: TextAlign.center,
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.ebonyBlack,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
