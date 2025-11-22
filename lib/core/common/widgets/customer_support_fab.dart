import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/services/freshchat_service.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';

/// Floating Action Button for Customer Support
///
/// This widget provides a consistent customer support button across the app
/// Shows unread message count badge if there are unread messages
class CustomerSupportFAB extends StatelessWidget {
  final double? bottom;
  final double? right;
  final VoidCallback? onPressed;

  const CustomerSupportFAB({
    super.key,
    this.bottom,
    this.right,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Get or initialize Freshchat service
    final FreshchatService freshchatService;

    if (Get.isRegistered<FreshchatService>()) {
      freshchatService = Get.find<FreshchatService>();
    } else {
      freshchatService = Get.put(FreshchatService());
    }

    return Positioned(
      bottom: bottom ?? 90.h,
      right: right ?? 16.w,
      child: Obx(() {
        final unreadCount = freshchatService.unreadMessageCount.value;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Main FAB
            FloatingActionButton(
              onPressed:
                  onPressed ?? () => _handleSupportPress(freshchatService),
              backgroundColor: AppColors.primary,
              elevation: 4,
              child: Icon(
                Icons.support_agent_rounded,
                color: Colors.white,
                size: 28.sp,
              ),
            ),

            // Unread badge
            if (unreadCount > 0)
              Positioned(
                top: -4.h,
                right: -4.w,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  constraints: BoxConstraints(minWidth: 20.w, minHeight: 20.h),
                  child: Center(
                    child: Text(
                      unreadCount > 99 ? '99+' : '$unreadCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  void _handleSupportPress(FreshchatService service) {
    // Track event
    service.trackEvent('support_opened');

    // Open Freshchat
    service.openChat();
  }
}
