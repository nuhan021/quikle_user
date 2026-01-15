import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/chatting/controllers/chat_controller.dart';
import 'message_bubble.dart';

typedef FormatTimestamp = String Function(dynamic ts);
typedef IsDisplayable = bool Function(dynamic message);

class MessagesList extends StatelessWidget {
  const MessagesList({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.riderName,
    required this.formatTimestamp,
    required this.isDisplayable,
  });

  final ChatController controller;
  final ScrollController scrollController;
  final String riderName;
  final FormatTimestamp formatTimestamp;
  final IsDisplayable isDisplayable;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final visible = controller.messages.where(isDisplayable).toList();

      if (visible.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 56,
                color: Colors.grey[400],
              ),
              SizedBox(height: 8.h),
              Text(
                'No messages yet',
                style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        controller: scrollController,
        reverse: true,
        padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
        itemCount: visible.length + 1,
        itemBuilder: (context, index) {
          if (index == visible.length) {
            return Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Today 10:45 AM',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            );
          }

          final message = visible[visible.length - 1 - index];
          final isSent = message.isSent == true;

          return MessageBubble(
            message: message,
            isSent: isSent,
            riderName: riderName,
            formatTimestamp: formatTimestamp,
          );
        },
      );
    });
  }
}
