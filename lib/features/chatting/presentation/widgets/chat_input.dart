import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/features/chatting/controllers/chat_controller.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({
    super.key,
    required this.controller,
    required this.riderName,
  });

  final ChatController controller;
  final String riderName;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: .85),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Padding(
            padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _quickReplies(),
                SizedBox(height: 10.h),
                _messageComposer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _quickReplies() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _quickChip("I'm here"),
          SizedBox(width: 8.w),
          _quickChip("OK"),
          SizedBox(width: 8.w),
          _quickChip("Be there in 2 mins"),
          SizedBox(width: 8.w),
          _quickChip("Near the entrance"),
        ],
      ),
    );
  }

  Widget _messageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              minLines: 1,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Message $riderName...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),
          SizedBox(width: 6.w),
          _sendButton(),
        ],
      ),
    );
  }

  Widget _sendButton() {
    return GestureDetector(
      onTap: controller.sendMessage,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(Icons.send_rounded, size: 20.sp, color: Colors.black87),
      ),
    );
  }

  Widget _quickChip(String text) {
    return GestureDetector(
      onTap: () {
        controller.messageController.text = text;
        controller.sendMessage();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFC200).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: const Color(0xFFFFC200).withValues(alpha: 0.35),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
