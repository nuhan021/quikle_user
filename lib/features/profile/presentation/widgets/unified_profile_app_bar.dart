import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';
import 'package:flutter/widgets.dart'; 

class UnifiedProfileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final bool showActionButton;
  final bool showBackButton;

  const UnifiedProfileAppBar({
    super.key,
    required this.title,
    this.actionText,
    this.onActionPressed,
    this.showActionButton = false,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final double statusBar = MediaQuery.paddingOf(context).top;
    return SizedBox(
      height: statusBar + kToolbarHeight,
      child: CommonAppBar(
        title: title,
        showBackButton: showBackButton,
        actions: [
          if (showActionButton && actionText != null)
            TextButton(
              onPressed: onActionPressed,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionText!,
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.beakYellow,
                ),
              ),
            ),
        ],
        showNotification: false,
        showProfile: false,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
