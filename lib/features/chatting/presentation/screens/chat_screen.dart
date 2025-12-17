import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/chatting/controllers/chat_controller.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.rider, this.riderId});

  final dynamic rider;
  final String? riderId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatController controller;
  final ScrollController _scrollController = ScrollController();

  bool _isDisplayable(dynamic message) {
    try {
      final text = (message?.text ?? '').toString().trim();
      if (text.isEmpty) return false;
      final low = text.toLowerCase();
      // filter out common socket pings or control messages
      if (low == 'ping' ||
          low == 'pong' ||
          low == 'heartbeat' ||
          low == 'keepalive')
        return false;
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    // determine riderId: prefer explicit param, otherwise extract from rider object
    String riderId = '';
    try {
      if (widget.riderId != null && widget.riderId!.isNotEmpty) {
        riderId = widget.riderId!;
      } else if (widget.rider == null) {
        riderId = '';
      } else if (widget.rider is Map) {
        riderId = (widget.rider['riderId'] ?? widget.rider['id'] ?? '')
            .toString();
      } else {
        final dyn = widget.rider;
        riderId = (dyn.riderId ?? dyn.id ?? '').toString();
      }
    } catch (_) {
      riderId = '';
    }

    controller = Get.put(ChatController(riderId: riderId));
    ever(controller.messages, (_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final riderName = () {
      try {
        if (widget.rider == null) return 'Rider';
        if (widget.rider is Map)
          return (widget.rider['riderName'] ?? widget.rider['name'] ?? 'Rider')
              .toString();
        final dyn = widget.rider;
        return (dyn.riderName ?? dyn.name ?? 'Rider').toString();
      } catch (_) {
        return 'Rider';
      }
    }();

    AppLoggerHelper.debug('Opening chat screen for rider: $riderName');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Chat with $riderName',
              style: TextStyle(fontSize: 18.sp, color: Colors.black87),
            ),
            SizedBox(height: 2.h),
            Text(
              'Live chat',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final visible = controller.messages
                      .where(_isDisplayable)
                      .toList();

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
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: visible.length,
                    padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                    itemBuilder: (context, index) {
                      final message = visible[visible.length - 1 - index];
                      final isSent = message.isSent;
                      final bubbleColor = isSent
                          ? Color(0xFFDCF8C6)
                          : Colors.white;
                      final textColor = Colors.black87;

                      return Row(
                        mainAxisAlignment: isSent
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 6.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: bubbleColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.r),
                                  topRight: Radius.circular(16.r),
                                  bottomLeft: Radius.circular(
                                    isSent ? 16.r : 4.r,
                                  ),
                                  bottomRight: Radius.circular(
                                    isSent ? 4.r : 16.r,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.text,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  if (message.timestamp != null) ...[
                                    SizedBox(height: 6.h),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          message.timestamp!,
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
              ),
            ),

            // input area (WhatsApp-like)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.messageController,
                              minLines: 1,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: 'Type a message',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.h,
                                ),
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller.messageController,
                    builder: (context, value, child) {
                      final enabled = value.text.trim().isNotEmpty;
                      return GestureDetector(
                        onTap: enabled ? controller.sendMessage : null,
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: enabled
                                ? Color(0xFF128C7E)
                                : Colors.grey.shade300,
                          ),
                          child: Icon(
                            Icons.send,
                            color: enabled ? Colors.white : Colors.grey[600],
                            size: 20.sp,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
